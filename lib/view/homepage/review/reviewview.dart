import 'dart:math';

import 'package:flutter/material.dart';
import 'package:message/configs/appcolors.dart';
import 'package:message/configs/appvalues.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:message/databases/questiondb.dart';
import 'package:message/models/question.dart';

class ReviewView extends StatefulWidget {
  const ReviewView({Key? key}) : super(key: key);

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
    addQuestion(() {
      getAllQuestion();
    });
  }

// get dữ liệu từ database ra
  Future getAllQuestion() async {
    lsQuestion = await QuestionsDatabase.instance.readAllQuestion();
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
          backgroundColor: AppColors.BACKGROUND, title: Text(AppValues.review)),
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
        : CarouselSlider.builder(
            carouselController: carouselController,
            itemCount: lsQuestion.length,
            itemBuilder: (BuildContext context, int index, int pageViewIndex) =>
                buildContent(lsQuestion[index], index,
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
          Text('Câu hỏi $index?', style: TextStyle(fontSize: 18, color: color)),
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
          testAnswer(question.answer1, color),
          testAnswer(question.answer2, color),
          testAnswer(question.answer3, color),
          testAnswer(question.answer4, color)
        ]),
        decoration: BoxDecoration(
          color: AppColors.WHITE,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color),
        ));
  }

  Widget testAnswer(String value, Color color) {
    var isChecker = false;
    return Row(children: [
      SizedBox(width: 25),
      Checkbox(
          hoverColor: AppColors.RED,
          activeColor: color,
          checkColor: AppColors.RED,
          value: false,
          onChanged: (newValue) {
            setState(() {
              // isChecker = newValue!;
            });
          }),
      SizedBox(width: 10),
      Expanded(child: Text(value, style: TextStyle(fontSize: 15, color: color)))
    ]);
  }

  void modalBottomSheetMenu() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return new Container(
              height: size.height * 0.5,
              child: new Center(
                  child: new Text(
                      "Thông tin chi tiết về câu hỏi và đáp án câu $i")));
        });
  }
}
