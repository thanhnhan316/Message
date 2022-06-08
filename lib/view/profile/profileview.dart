import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:message/configs/appcolors.dart';
import 'package:message/configs/appvalues.dart';
import 'package:message/databases/userdb.dart';
import 'package:message/models/user.dart';
import 'package:message/view/chat/homechatview.dart';
import 'package:message/view/homepage/homeview.dart';
import 'package:message/widgets/widgetbutton.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

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
  File? image;
  late String imageName;
  late bool selectImage = false;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
        body: Stack(children: [
      SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          SizedBox(height: size.height * 0.1),
          Container(
              child: Stack(children: [
            CircleAvatar(
                radius: 50,
                child: image != null
                    ? ClipRRect(
                        child: Image.file(image!,
                            width: double.maxFinite, fit: BoxFit.fitWidth),
                        borderRadius: BorderRadius.circular(50.0))
                    : widget.user.avatar == "avatar"
                        ? ClipRRect(
                            child: Image.network(
                                "https://cdn-icons-png.flaticon.com/512/149/149071.png"),
                            borderRadius: BorderRadius.circular(50.0))
                        : ClipRRect(
                            child: Image.asset(widget.user.avatar),
                            borderRadius: BorderRadius.circular(50.0))),
            Positioned(
                child: IconButton(
                    onPressed: () {
                      setState(() {
                        selectImage = true;
                      });
                    },
                    icon: Icon(Icons.add_a_photo)),
                bottom: 1,
                right: 1),
          ])),
          SizedBox(height: 35),
          Container(
              child: Column(children: [
            itemProfile(Icons.person, widget.user.userName, userNameController),
            itemProfile(Icons.person, widget.user.fullName, fullNameController),
            itemProfile(Icons.email, widget.user.email, emailController),
            itemProfile(Icons.book, widget.user.status, statusController),
            SizedBox(height: size.height * 0.05),
            WidgetButton(
                name: AppValues.saveChange,
                size: size,
                color: AppColors.BACKGROUND,
                function: () {
                  checkUpdate();
                }),
            SizedBox(height: size.height * 0.02),
            WidgetButton(
                name: AppValues.undo,
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
      ),
      selectImage
          ? Center(
              child: Card(
                  child: Container(
                      width: size.width * 0.35,
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        TextButton(
                            onPressed: () {
                              PickAndImage();
                              setState(() {
                                selectImage = false;
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(Icons.camera),
                                Text("Máy ảnh"),
                              ],
                            )),
                        TextButton(
                            onPressed: () {
                              PickAndGallery();
                              setState(() {
                                selectImage = false;
                              });
                            },
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(Icons.image),
                                  Text("Thư viện ảnh")
                                ])),
                        TextButton(
                            onPressed: () {
                              setState(() {
                                selectImage = false;
                              });
                            },
                            child: Text("Hủy"))
                      ]))))
          : Container()
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
        avatar: imageName.isNotEmpty ? imageName : widget.user.avatar,
        status: status.isNotEmpty ? status : widget.user.status);
    await UserDatabase.instance.update(user);
    showToast(context, AppValues.savedChange);
    reBuildHome(user);
  }

  void goToHome() {
    Navigator.pop(context);
  }

  void reBuildHome(User user) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => HomeView(user: user)),
        (Route<dynamic> route) => false);
  }

  Future PickAndGallery() async {
    try {
      final i = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (i == null) return;
      //file Hình ảnh tạm thời
      final imageTemporary = File(i.path);
      //Lấy địa chỉ foder trong thiết bị
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String path = appDocDir.path;

      final File newImage =
          await imageTemporary.copy('$path/${getRandString(10)}.jpg');

      setState(() {
        image = newImage;
        imageName = newImage.path;
      });
    } on PlatformException catch (e) {
      print("Lỗi : $e");
    }
  }

  Future PickAndImage() async {
    try {
      //lấy ảnh ra
      final i = await ImagePicker().pickImage(source: ImageSource.camera);
      if (i == null) return;
      //file Hình ảnh tạm thời
      final imageTemporary = File(i.path);
      //Lấy địa chỉ foder trong thiết bị
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String path = appDocDir.path;

      final File newImage =
          await imageTemporary.copy('$path/${getRandString(10)}.jpg');

      setState(() {
        image = newImage;
        imageName = newImage.path;
      });
      print("${image!.path}");
    } on PlatformException catch (e) {
      print("Lỗi : $e");
    }
  }

  Future<String> _createFileFromString() async {
    final encodedStr = "...";
    Uint8List bytes = base64.decode(encodedStr);
    String dir = (await getApplicationDocumentsDirectory()).path;
    String fullPath = '$dir/abc.png';
    print("local file full path ${fullPath}");
    File file = File(fullPath);
    await file.writeAsBytes(bytes);
    print(file.path);

    final result = await ImageGallerySaver.saveImage(bytes);
    print(result);

    return file.path;
  }
}

String getRandString(int len) {
  var random = Random.secure();
  var values = List<int>.generate(len, (i) => random.nextInt(255));
  return base64UrlEncode(values);
}

void showToast(BuildContext context, String value) {
  final scaffold = ScaffoldMessenger.of(context);
  scaffold.showSnackBar(SnackBar(content: Text(value)));
}
