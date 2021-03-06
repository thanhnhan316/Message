import 'package:flutter/material.dart';
import 'package:message/configs/appcolors.dart';
import 'package:message/configs/appvalues.dart';
import 'package:message/databases/userdb.dart';
import 'package:message/models/user.dart';
import 'package:message/view/chat/homechatview.dart';
import 'package:message/view/login/loginview.dart';
import 'package:message/widgets/widgetbutton.dart';
import 'package:message/widgets/widgetinput.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late Size size;
  late List<User> users;
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController rePasswordController = TextEditingController();

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
    return Scaffold(
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return SingleChildScrollView(
      child: Container(
          padding: EdgeInsets.all(30),
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            SizedBox(height: size.height * 0.05),
            Text(AppValues.register,
                style: TextStyle(
                    fontSize: size.height * 0.04, color: AppColors.BACKGROUND)),
            SizedBox(height: size.height * 0.04),
            WidgetInput(
                name: AppValues.userName,
                icon: Icons.person,
                controller: userNameController),
            SizedBox(height: size.height * 0.02),
            WidgetInput(
                name: AppValues.email,
                icon: Icons.email,
                controller: emailController),
            SizedBox(height: size.height * 0.04),
            WidgetInput(
                name: AppValues.password,
                icon: Icons.lock,
                controller: passwordController),
            SizedBox(height: size.height * 0.02),
            WidgetInput(
                name: AppValues.rePassword,
                icon: Icons.lock,
                controller: rePasswordController),
            SizedBox(height: size.height * 0.05),
            WidgetButton(
                name: AppValues.register,
                size: size,
                color: AppColors.BACKGROUND,
                function: () {
                  addUser();
                }),
            SizedBox(height: size.height * 0.05),
            login(),
            SizedBox(height: size.height * 0.05),
          ])),
    );
  }

  Widget login() {
    return GestureDetector(
        onTap: () {
          goToLogin();
        },
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(AppValues.haveYourAcc),
          Text(AppValues.login, style: TextStyle(color: AppColors.BACKGROUND))
        ]));
  }

  void addUser() async {
    if (checkFormValid()) {
      if (checkUserName()) {
        if (checkEmail()) {
          if (checkLenthPassword()) {
            if (checkPassword()) {
              final user = User(
                  userName: userNameController.value.text.trim(),
                  fullName: "fullName",
                  password: passwordController.value.text.trim(),
                  email: emailController.value.text.trim(),
                  avatar: "avatar",
                  status: "status");

              await UserDatabase.instance.create(user);
              registerSuccess(user);
            } else {
              showToast(context, "M???t kh???u kh??ng tr??ng nhau");
            }
          } else {
            showToast(context, "M???t kh???u ph???i d??i h??n 6 k?? t???");
          }
        } else {
          showToast(context, "Email ch??a ????ng ?????nh d???ng");
        }
      } else {
        showToast(context, "T??n ng?????i d??ng ???? t???n t???i");
      }
    } else {
      showToast(context, "Ch??a nh???p ?????y ????? th??ng tin");
    }
  }

  void goToLogin() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginView()),
        (Route<dynamic> route) => false);
  }

  void goToHome(User user) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => HomeChatView(user: user)),
        (Route<dynamic> route) => false);
  }

  bool checkUserName() {
    for (User i in users) {
      if (userNameController.value.text == i.userName) return false;
    }
    return true;
  }

  bool checkFormValid() {
    if (userNameController.value.text == "" ||
        emailController.value.text == "" ||
        passwordController.value.text == "" ||
        rePasswordController.value.text == "") return false;
    return true;
  }

  bool checkLenthPassword() {
    if (passwordController.value.text.length < 6) return false;
    return true;
  }

  bool checkPassword() {
    if (passwordController.value.text.trim() !=
        rePasswordController.value.text.trim()) return false;
    return true;
  }

  bool checkEmail() {
    String value = emailController.value.text.trim();
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern as String);
    return (regex.hasMatch(value)) ? true : false;
  }

  void showToast(BuildContext context, String value) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(value),
        action: SnackBarAction(
            label: '???? hi???u', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  void registerSuccess(User user) async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text('${user.userName} ???? ????ng k?? th??nh c??ng'),
              content: Text(' B???n c?? mu???n ????ng nh???p?'),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      goToLogin();
                    },
                    child: Text('T???i trang ????ng nh???p')),
                TextButton(
                    onPressed: () {
                      setPreferences(user);
                      goToHome(user);
                    },
                    child: Text('????ng nh???p')),
              ]);
        });
  }

  void setPreferences(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("userId", user.id ?? 0);
  }
}
