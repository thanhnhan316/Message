import 'dart:math';
import 'package:flutter/material.dart';
import 'package:message/configs/appcolors.dart';
import 'package:message/configs/appvalues.dart';
import 'package:message/models/question.dart';
import 'package:message/models/topic.dart';
import 'package:message/view/homepage/review/reviewview.dart';

class AllReviewView extends StatefulWidget {
  const AllReviewView({Key? key}) : super(key: key);

  @override
  State<AllReviewView> createState() => _AllReviewViewState();
}

class _AllReviewViewState extends State<AllReviewView> {
  late Size size;
  List<Topic> lsTopic = [];
  bool isLoading = true;
  Random random = new Random();

  @override
  void initState() {
    super.initState();
    getAllTopic();
  }

  // get dữ liệu từ database ra
  Future getAllTopic() async {
    lsTopic = await addTopic();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
            backgroundColor: AppColors.BACKGROUND,
            title: Text(AppValues.review)),
        body: buildBody());
  }

  Widget buildBody() {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: lsTopic.length,
            itemBuilder: (context, i) {
              return buildCard(lsTopic[i], AppColors.colors[random.nextInt(5)]);
            });
  }

  Widget buildCard(Topic topic, Color colors) {
    return Column(children: [
      SizedBox(height: 20),
      Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: GestureDetector(
              onTap: () {
                goToReview(topic);
              },
              child: Card(
                  elevation: 7,
                  child: Container(
                      padding: EdgeInsets.all(20),
                      height: size.height * 0.12,
                      width: size.width,
                      decoration: BoxDecoration(
                          color: AppColors.WHITE,
                          borderRadius: BorderRadius.circular(20)),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Icon(Icons.auto_stories,
                                size: size.height * 0.042, color: colors),
                            SizedBox(width: 10),
                            Expanded(
                                child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                  Text("Bộ đề ôn ${topic.topicName}",
                                      style: TextStyle(
                                          fontSize: size.height * 0.02,
                                          color: colors),
                                      maxLines: 1),
                                  Text(
                                    "${topicLength(topic.id!)} câu",
                                    style: TextStyle(color: colors),
                                  ),
                                  Container(
                                      height: 1,
                                      width: size.width * 0.6,
                                      color: colors)
                                ]))
                          ])))))
    ]);
  }

  Future<int> topicLength(int id) async {
    print("11111111");
    List<Question> ls = await addQuestion(id);
    int n = ls.length;
    print(ls.length);
    return n;
  }

  void goToReview(Topic topic) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ReviewView(topic: topic)));
  }
}
