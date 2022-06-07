import 'package:flutter/material.dart';
import 'package:message/configs/appcolors.dart';
import 'package:message/configs/appvalues.dart';
import 'package:message/models/user.dart';
import 'package:message/view/chat/homechatview.dart';
import 'package:message/view/homepage/review/allreviewview.dart';
import 'package:message/view/login/loginview.dart';
import 'package:message/view/profile/profileview.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeView extends StatefulWidget {
  User user;
  HomeView({Key? key, required this.user}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(body: buildBody());
  }

  Widget buildBody() {
    return Stack(children: [
      Container(
          width: size.width,
          height: size.height,
          color: AppColors.BACKGROUND,
          child: CustomPaint(
            painter: ShapePainter(),
          )),
      Container(
          margin: EdgeInsets.only(left: 20, right: 20, top: 10),
          child: Column(children: [
            buildAppbar(),
            SizedBox(height: 20),
            achievements(11, 8.25),
            buildItem()
          ]))
    ]);
  }

  Widget buildAppbar() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(AppValues.projectName,
          style:
              TextStyle(fontSize: size.height * 0.04, color: AppColors.WHITE)),
      PopupMenuButton(
          icon: Icon(
            Icons.list_rounded,
            color: AppColors.WHITE,
            size: size.height * 0.04,
          ),
          itemBuilder: (context) => [
                PopupMenuItem(
                    child: GestureDetector(
                        onTap: () => goToProfile(),
                        child: Container(
                            child: Row(children: [
                          Icon(Icons.person, size: size.height * 0.037),
                          SizedBox(width: 15),
                          Text(AppValues.profile)
                        ])))),
                PopupMenuItem(
                    child: GestureDetector(
                        onTap: () => showLogout(),
                        child: Container(
                            child: Row(children: [
                          Icon(Icons.logout, size: size.height * 0.037),
                          SizedBox(width: 15),
                          Text(AppValues.logout)
                        ]))))
              ])
    ]);
  }

  Widget buildItem() {
    return Expanded(
        child: ListView(children: [
      Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          itemMenu(Icons.menu_book_sharp, AppValues.review, () {
            goToReview();
          }),
          itemMenu(Icons.online_prediction_rounded, AppValues.training, () {})
        ]),
        SizedBox(height: 10),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          itemMenu(Icons.schedule, AppValues.schedule, () {}),
          itemMenu(Icons.sports_gymnastics_outlined, AppValues.game, () {}),
        ]),
        SizedBox(height: 10),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          itemMenu(Icons.chat_sharp, AppValues.chat, () {
            goToChatHome();
          }),
          itemMenu(Icons.photo_library_sharp, AppValues.library, () {})
        ])
      ])
    ]));
  }

  Widget itemMenu(IconData icons, String text, Function function) {
    return GestureDetector(
        onTap: () {
          function();
        },
        child: Card(
            elevation: 10,
            color: Colors.transparent,
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.all(10),
                width: size.height * 0.15,
                height: size.height * 0.15,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(
                        icons,
                        size: size.width * 0.12,
                        color: AppColors.BACKGROUND,
                      ),
                      Text(text),
                      Container(
                          height: 1,
                          width: double.maxFinite,
                          color: AppColors.BACKGROUND)
                    ]))));
  }

  Widget achievements(int test, double point) {
    return Card(
        elevation: 5,
        color: Colors.transparent,
        child: Container(
            width: size.width * 0.83,
            height: size.height * 0.2,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(
                      height: size.height * 0.15,
                      width: size.height * 0.15,
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(1000),
                          border: Border.all(
                              color: AppColors.BACKGROUND, width: 9)),
                      child: Align(
                          alignment: Alignment.center,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.auto_stories,
                                    color: AppColors.BACKGROUND),
                                Text('$test',
                                    style: TextStyle(
                                        fontSize: 35,
                                        color: AppColors.BACKGROUND,
                                        fontWeight: FontWeight.bold)),
                                Text(AppValues.topic,
                                    style: TextStyle(
                                        fontSize: 22,
                                        color: AppColors.BACKGROUND))
                              ]))),
                  Text(AppValues.did,
                      style:
                          TextStyle(fontSize: 15, color: AppColors.BACKGROUND))
                ]),
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(
                      height: size.height * 0.15,
                      width: size.height * 0.15,
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(1000),
                          border: Border.all(
                              color: AppColors.BACKGROUND, width: 9)),
                      child: Align(
                          alignment: Alignment.center,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.note_alt_outlined,
                                  color: AppColors.BACKGROUND,
                                ),
                                Text('$point',
                                    style: TextStyle(
                                        fontSize: 35,
                                        color: AppColors.BACKGROUND,
                                        fontWeight: FontWeight.bold)),
                                Text(AppValues.point,
                                    style: TextStyle(
                                        fontSize: 22,
                                        color: AppColors.BACKGROUND))
                              ]))),
                  Text(AppValues.pointBest,
                      style:
                          TextStyle(fontSize: 15, color: AppColors.BACKGROUND))
                ])
              ])
            ]),
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.86),
                borderRadius: BorderRadius.circular(20))));
  }

  void logout() {
    //xóa thông tin user đã login
    getUserPreference();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginView()),
        (Route<dynamic> route) => false);
  }

  Future getUserPreference() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userId');
  }

  void showLogout() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text(AppValues.logout),
              content: Text(AppValues.logoutSystem),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(AppValues.cancel)),
                TextButton(
                    onPressed: () {
                      logout();
                    },
                    child: Text(AppValues.logout))
              ]);
        });
  }

  void goToChatHome() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => HomeChatView(user: widget.user)));
  }

  void goToProfile() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProfileView(user: widget.user)));
  }

  void goToReview() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AllReviewView()));
  }
}

class ShapePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = AppColors.WHITE
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;

    Path path = Path();
    path.moveTo(0, size.height);
    path.lineTo(0, size.height * 0.4);
    path.quadraticBezierTo(
        size.width * 0.7, size.height * 0.4, size.width, size.height * 0.18);
    path.lineTo(size.width, size.height);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
