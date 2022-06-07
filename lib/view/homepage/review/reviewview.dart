import 'package:flutter/material.dart';
import 'package:message/configs/appcolors.dart';
import 'package:message/configs/appvalues.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ReviewView extends StatefulWidget {
  const ReviewView({Key? key}) : super(key: key);

  @override
  State<ReviewView> createState() => _ReviewViewState();
}

class _ReviewViewState extends State<ReviewView> {
  CarouselController carouselController = CarouselController();
  late Size size;
  int i = 0;
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
          child: test(),
        ),
        buildControl()
      ],
    );
  }

  Widget test() {
    return CarouselSlider.builder(
        carouselController: carouselController,
        itemCount: 15,
        itemBuilder: (BuildContext context, int index, int pageViewIndex) =>
            buildTest(index),
        options: CarouselOptions(
            height: double.infinity,
            enlargeCenterPage: true,
            onPageChanged: (index, reason) {
              setState(() {
                i = index;
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

  Widget buildTest(int index) {
    return Container(
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.all(10),
        width: size.width * 0.9,
        child: Column(children: [
          Text('Câu hỏi $index?',
              style: TextStyle(fontSize: 18, color: AppColors.BACKGROUND)),
          SizedBox(height: 10),
          Container(
            width: size.width * 0.8,
            height: 2,
            color: AppColors.BACKGROUND,
          ),
          testAnswer(),
          testAnswer(),
          testAnswer(),
          testAnswer()
        ]),
        decoration: BoxDecoration(
            color: AppColors.WHITE, borderRadius: BorderRadius.circular(20)));
  }

  Widget testAnswer() {
    var isChecker = false;
    return Column(children: [
      Row(children: [
        SizedBox(width: 25),
        Checkbox(
            activeColor: AppColors.BACKGROUND,
            checkColor: AppColors.WHITE,
            value: false,
            onChanged: (newValue) {
              setState(() {
                isChecker = newValue!;
              });
            }),
        SizedBox(width: 10),
        Text('Câu trả lời', style: TextStyle(fontSize: 15)),
      ])
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
