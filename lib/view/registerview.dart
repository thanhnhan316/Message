import 'package:flutter/material.dart';
import 'package:message/configs/appcolors.dart';
import 'package:message/configs/appvalues.dart';
import 'package:message/databases/userdatabase.dart';
import 'package:message/models/user.dart';
import 'package:message/view/loginview.dart';
import 'package:message/widgets/widgetbutton.dart';
import 'package:message/widgets/widgetinput.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late Size size;
  late List<User> users;
  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final rePasswordController = TextEditingController();

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
            goToLogin();
            showToast(context, "Đăng ký thành công");
          } else {
            showToast(context, "Mật khẩu không trùng nhau");
          }
        } else {
          showToast(context, "Mật khẩu phải dài hơn 6 ký tự");
        }
      } else {
        showToast(context, "Tên người dùng đã tồn tại");
      }
    } else {
      showToast(context, "Chưa nhập đầy đủ thông tin");
    }
  }

  void goToLogin() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginView()));
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

  void showToast(BuildContext context, String value) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(value),
        action: SnackBarAction(
            label: 'Đã hiểu', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }
}
