import 'package:flutter/material.dart';
import 'package:message/configs/appcolors.dart';
import 'package:message/configs/appimages.dart';
import 'package:message/configs/appvalues.dart';
import 'package:message/databases/userdb.dart';
import 'package:message/models/user.dart';
import 'package:message/view/homepage/homeview.dart';
import 'package:message/view/register/registerview.dart';
import 'package:message/widgets/widgetbutton.dart';
import 'package:message/widgets/widgetinput.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late Size size;
  late List<User> users;
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  late User user;

  @override
  void initState() {
    super.initState();
    allUsers();
  }

  Future allUsers() async {
    this.users = await UserDatabase.instance.readAllUser();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(backgroundColor: Colors.white, body: buildBody());
  }

  Widget buildBody() {
    return SingleChildScrollView(
      child: Container(
          padding: EdgeInsets.all(30),
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            SizedBox(height: size.height * 0.05),
            Image.asset(AppImages.imgLogo,
                fit: BoxFit.fitHeight, height: size.height * 0.15),
            SizedBox(height: size.height * 0.04),
            WidgetInput(
                name: AppValues.userName,
                icon: Icons.person,
                controller: userNameController),
            SizedBox(height: size.height * 0.03),
            WidgetInput(
                name: AppValues.password,
                icon: Icons.lock,
                controller: passwordController),
            SizedBox(height: size.height * 0.05),
            WidgetButton(
                name: AppValues.login,
                size: size,
                color: AppColors.BACKGROUND,
                function: () {
                  checkInformationUser();
                }),
            SizedBox(height: size.height * 0.05),
            line(size),
            SizedBox(height: size.height * 0.05),
            loginWith(),
            SizedBox(height: size.height * 0.05),
            register(),
            SizedBox(height: size.height * 0.05),
          ])),
    );
  }

  Widget line(Size size) {
    return Row(children: [
      Expanded(
          child: Container(
              height: 1, width: size.width, color: AppColors.BACKGROUND)),
      Text(AppValues.orLogin),
      Expanded(
          child: Container(
              height: 1, width: size.width, color: AppColors.BACKGROUND))
    ]);
  }

  Widget loginWith() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
            onTap: () {
              showToast(context, 'Ch??a th??? ????ng nh???p b???ng Facebook');
            },
            child: Icon(Icons.facebook, color: AppColors.BACKGROUND, size: 50)),
        GestureDetector(
          onTap: () {
            showToast(context, "Ch??a th??? ????ng nh???p b???ng Google");
          },
          child: CircleAvatar(
              radius: 22,
              child: Text('G',
                  style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              backgroundColor: AppColors.BACKGROUND),
        ),
      ],
    );
  }

  Widget register() {
    return GestureDetector(
        onTap: () {
          goToRegister();
        },
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(AppValues.notYourAcc),
          Text(AppValues.register,
              style: TextStyle(color: AppColors.BACKGROUND))
        ]));
  }

  void checkInformationUser() async {
    final prefs = await SharedPreferences.getInstance();
    if (checkFormValid()) {
      if (checkUserNamePass()) {
        showToast(context, "????ng nh???p th??nh c??ng");
        await prefs.setInt("userId", user.id ?? 0);
        goToHome();
      } else {
        showToast(context, "T??n ????ng nh???p ho???c m???t kh???u kh??ng ????ng");
      }
    } else {
      showToast(context, "Ch??a nh???p ?????y ????? th??ng tin");
    }
  }

  void goToHome() {
    // //x??a m??n h??nh tr?????c ????
    // Navigator.pushReplacement(
    //     context, MaterialPageRoute(builder: (context) => LoginView()));
    //x??a t???t c??? m??n h??nh ???? ??i qua
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => HomeView(user: user)),
        (Route<dynamic> route) => false);
  }

  void goToRegister() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => RegisterView()));
  }

  bool checkFormValid() {
    if (userNameController.value.text == "" ||
        passwordController.value.text == "") return false;
    return true;
  }

  bool checkUserNamePass() {
    for (User i in users) {
      if (userNameController.value.text.trim() == i.userName &&
          passwordController.value.text.trim() == i.password) {
        user = i;
        return true;
      }
    }
    return false;
  }

  void showToast(BuildContext context, String value) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(SnackBar(content: Text(value)));
  }
}
