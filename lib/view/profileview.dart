import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:message/configs/appcolors.dart';
import 'package:message/configs/appimages.dart';
import 'package:message/databases/userdatabase.dart';
import 'package:message/models/user.dart';
import 'package:message/view/homechatview.dart';
import 'package:message/widgets/widgetbutton.dart';

class ProfileView extends StatefulWidget {
  User user;
  ProfileView({Key? key, required this.user}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  late Size size;
  final userNameController = TextEditingController();
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final statusController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
        body: Stack(children: [
      SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          SizedBox(height: size.height * 0.1),
          CircleAvatar(
            radius: 50,
            backgroundImage:
                NetworkImage("https://s3.o7planning.com/images/boy-128.png"),
          ),
          SizedBox(height: 35),
          Container(
              child: Column(children: [
            itemProfile(Icons.person, widget.user.userName, userNameController),
            itemProfile(Icons.person, widget.user.fullName, fullNameController),
            itemProfile(Icons.email, widget.user.email, emailController),
            itemProfile(Icons.book, widget.user.status, statusController),
            SizedBox(height: size.height * 0.05),
            WidgetButton(
                name: "Lưu thay đổi",
                size: size,
                color: AppColors.BACKGROUND,
                function: () {
                  checkUpdate();
                }),
            SizedBox(height: size.height * 0.02),
            WidgetButton(
                name: "Hoàn tác",
                size: size,
                color: AppColors.RED,
                function: () {
                  goToHome();
                })
          ]))
        ]),
      ),
      Positioned(
        top: 20,
        child: IconButton(
            onPressed: () {
              goToHome();
            },
            icon: Icon(Icons.arrow_back,
                color: AppColors.BLACK87, size: size.height * 0.04)),
      )
    ]));
  }

  Widget itemProfile(IconData icon, String value, var controller) {
    return Container(
        margin: EdgeInsets.only(left: size.width * 0.1),
        child: Column(children: [
          TextField(
              controller: controller,
              onChanged: (value) {},
              style: TextStyle(fontSize: size.height * 0.022),
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                  prefixIcon: Icon(icon,
                      color: AppColors.BACKGROUND, size: size.height * 0.04),
                  hintText: value,
                  border: InputBorder.none)),
          SizedBox(height: 10),
          Container(
              height: 0.5,
              width: size.width,
              decoration: BoxDecoration(color: AppColors.BACKGROUND)),
          SizedBox(height: 10)
        ]));
  }

  void goToHome() {
    Navigator.pop(context);
  }

  void goToHomeWhenEdit(User user) {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => HomeChatView(user: user)));
  }

  void checkUpdate() async {
    String userName = userNameController.value.text.trim();
    String fullName = fullNameController.value.text.trim();
    String email = emailController.value.text.trim();
    String status = statusController.value.text.trim();
    print(userName + " " + fullName + " " + email + " " + status);
    User user = User(
        id: widget.user.id,
        userName: userName.isNotEmpty ? userName : widget.user.userName,
        fullName: fullName.isNotEmpty ? fullName : widget.user.fullName,
        password: widget.user.password,
        email: email.isNotEmpty ? email : widget.user.email,
        avatar: widget.user.avatar,
        status: status.isNotEmpty ? status : widget.user.status);
    await UserDatabase.instance.update(user);
    showToast(context, "Đã lưu thay đổi");
    goToHomeWhenEdit(user);
  }

  void showToast(BuildContext context, String value) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(SnackBar(content: Text(value)));
  }
}
