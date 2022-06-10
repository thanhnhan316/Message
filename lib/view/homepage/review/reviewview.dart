import 'dart:math';
import 'package:flutter/material.dart';
import 'package:message/configs/appcolors.dart';
import 'package:message/configs/appvalues.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:message/models/question.dart';
import 'package:message/models/topic.dart';

class ReviewView extends StatefulWidget {
  Topic topic;
  ReviewView({Key? key, required this.topic}) : super(key: key);

  @override
  State<ReviewView> createState() => _ReviewViewState();
}

class _ReviewViewState extends State<ReviewView> {
  CarouselController carouselController = CarouselController();
  late Size size;
  int i = 1;
  List<Question> lsQuestion = [];
  bool isLoading = true;
  Random random = new Random();

  @override
  void initState() {
    super.initState();
    getAllQuestion();
  }

// get dữ liệu từ database ra
  Future getAllQuestion() async {
    lsQuestion = await addQuestion(widget.topic.id!);
    setState(() {
      isLoading = false;
    });
    for (Question i in lsQuestion) print(i.id);
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: AppColors.BACKGROUND,
          title: Text(widget.topic.topicName)),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Stack(
      children: [
        Container(
          width: double.maxFinite,
          padding: EdgeInsets.all(10),
          child: buildQuestion(),
        ),
        buildControl()
      ],
    );
  }

  Widget buildQuestion() {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : lsQuestion.isEmpty
            ? Center(child: Text("Bộ đề chưa được cập nhật"))
            : CarouselSlider.builder(
                carouselController: carouselController,
                itemCount: lsQuestion.length,
                itemBuilder:
                    (BuildContext context, int index, int pageViewIndex) =>
                        buildContent(lsQuestion[index], index + 1,
                            AppColors.colors[random.nextInt(5)]),
                options: CarouselOptions(
                    height: double.infinity,
                    enlargeCenterPage: true,
                    onPageChanged: (index, reason) {
                      setState(() {
                        i = index + 1;
                      });
                    }));
  }

  Widget buildControl() {
    return Positioned(
        child: Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            color: AppColors.BACKGROUND,
            width: size.width,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () {
                        carouselController.previousPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.linear);
                      },
                      icon: Icon(Icons.arrow_circle_left_outlined,
                          color: AppColors.WHITE, size: size.height * 0.04)),
                  TextButton(
                      onPressed: () {
                        modalBottomSheetMenu();
                      },
                      child: Column(children: [
                        Icon(Icons.keyboard_arrow_up_outlined,
                            size: size.height * 0.04, color: AppColors.WHITE),
                        Text("Thông tin câu hỏi $i",
                            style: TextStyle(color: AppColors.WHITE))
                      ])),
                  IconButton(
                      onPressed: () {
                        carouselController.nextPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.linear);
                      },
                      icon: Icon(Icons.arrow_circle_right_outlined,
                          color: AppColors.WHITE, size: size.height * 0.04)),
                ])),
        bottom: 0);
  }

  Widget buildContent(Question question, int index, Color color) {
    return Container(
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.all(10),
        width: size.width * 0.9,
        child: Column(children: [
          Text('Câu hỏi $index?',
              style: TextStyle(
                  fontSize: 18, color: color, fontWeight: FontWeight.bold)),
          Text(question.content,
              style: TextStyle(
                fontSize: 18,
                color: color,
              ),
              textAlign: TextAlign.center),
          SizedBox(height: 10),
          Container(
            width: size.width * 0.8,
            height: 2,
            color: color,
          ),
          testAnswer(question.answer1, question.correctAnswer, color),
          testAnswer(question.answer2, question.correctAnswer, color),
          testAnswer(question.answer3, question.correctAnswer, color),
          testAnswer(question.answer4, question.correctAnswer, color)
        ]),
        decoration: BoxDecoration(
          color: AppColors.WHITE,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color),
        ));
  }

  Widget testAnswer(String value, String correct, Color color) {
    var isChecker = false;
    return Row(children: [
      SizedBox(width: 25),
      Checkbox(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        onChanged: (value) {},
        value: value == correct ? true : false,
      ),
      SizedBox(width: 10),
      Expanded(child: Text(value, style: TextStyle(fontSize: 15, color: color)))
    ]);
  }

  void modalBottomSheetMenu() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return new Container(
              padding: EdgeInsets.all(20),
              height: size.height * 0.45,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text("Thông tin thêm về câu hỏi $i",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 15),
                    Text(lsQuestion[i - 1].information),
                  ],
                ),
              ));
        });
  }
}
