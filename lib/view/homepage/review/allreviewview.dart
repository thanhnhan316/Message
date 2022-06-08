import 'package:flutter/material.dart';
import 'package:message/configs/appcolors.dart';
import 'package:message/configs/appvalues.dart';
import 'package:message/view/homepage/review/reviewview.dart';

class AllReviewView extends StatefulWidget {
  const AllReviewView({Key? key}) : super(key: key);

  @override
  State<AllReviewView> createState() => _AllReviewViewState();
}

class _AllReviewViewState extends State<AllReviewView> {
  late Size size;
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
    return ListView.builder(
        itemCount: 10,
        itemBuilder: (context, i) {
          return buildCard();
        });
  }

  Widget buildCard() {
    return Column(children: [
      SizedBox(height: 20),
      Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: GestureDetector(
              onTap: () {
                goToReview();
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
                                size: size.height * 0.042,
                                color: AppColors.BACKGROUND),
                            SizedBox(width: 10),
                            Expanded(
                                child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                  Text("Tên bộ đề",
                                      style: TextStyle(
                                          fontSize: size.height * 0.02),
                                      maxLines: 1),
                                  Text('30 Câu'),
                                  Container(
                                      height: 1,
                                      width: size.width * 0.6,
                                      color: AppColors.BACKGROUND)
                                ]))
                          ])))))
    ]);
  }

  void goToReview() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ReviewView()));
  }
}
