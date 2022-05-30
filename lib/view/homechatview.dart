import 'package:flutter/material.dart';
import 'package:message/configs/appcolors.dart';
import 'package:message/configs/appimages.dart';
import 'package:message/databases/messagedatabase.dart';
import 'package:message/databases/userdatabase.dart';
import 'package:message/models/message.dart';
import 'package:message/models/user.dart';
import 'package:message/view/loginview.dart';
import 'package:message/view/profileview.dart';
import 'package:message/widgets/listchat.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeChatView extends StatefulWidget {
  User user;
  HomeChatView({Key? key, required this.user}) : super(key: key);

  @override
  State<HomeChatView> createState() => _HomeChatViewState();
}

class _HomeChatViewState extends State<HomeChatView> {
  late List<User> listUsers = [];
  late Size size;
  bool isLoading = false;
  bool isSelect = true;
  final searchController = TextEditingController();
  int? userId;
  late List<User> listUserInteractive = [];

  @override
  void initState() {
    super.initState();
    refreshUsers();
    refreshAllMessage();
    getUsserPreference();
  }

  // Preference userId
  Future getUsserPreference() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('userId');
    print("id user: " + userId.toString());
  }

  Future refreshUsers() async {
    setState(() {
      isLoading = true;
    });
    listUsers = await UserDatabase.instance.readAllUser();
    //xóa user đăng nhập
    setState(() {
      listUsers.removeWhere((i) => i.id == widget.user.id);
    });
    setState(() {
      isLoading = false;
    });
  }

  Future refreshAllMessage() async {
    List<Message> list = await MessageDatabase.instance.readAllMessage();
    List<int> lsInteractive = [];
    listUserInteractive = [];
    for (Message i in list) {
      if (i.senderId == userId) {
        setState(() {
          lsInteractive.add(i.receiverId);
        });
      }
      if (i.receiverId == userId) {
        setState(() {
          lsInteractive.add(i.senderId);
        });
      }
    }
    //xóa phần tử trùng nhau
    lsInteractive = lsInteractive.toSet().toList();
    lsInteractive = lsInteractive.reversed.toList();
    for (int i in lsInteractive) {
      for (User j in listUsers) {
        if (i == j.id) {
          listUserInteractive.add(j);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: AppColors.WHITE,
        body: Container(
            padding: EdgeInsets.all(10),
            child: Column(children: [
              buildAppBar(),
              buildSearch(),
              buildSelectLs(),
              ListChatView(
                  listUsers: isSelect ? listUserInteractive : listUsers,
                  isLoading: isLoading)
            ])));
  }

  Widget buildAppBar() {
    return Container(
        width: double.maxFinite,
        height: size.height * 0.11,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          CircleAvatar(
              radius: size.height * 0.032,
              backgroundImage: AssetImage(AppImages.Logo)),
          Text(widget.user.userName,
              style: TextStyle(
                  fontSize: size.height * 0.035, fontWeight: FontWeight.bold)),
          PopupMenuButton(
              itemBuilder: (context) => [
                    PopupMenuItem(
                        child: GestureDetector(
                            onTap: () => goToProfile(),
                            child: Container(
                                child: Row(children: [
                              Icon(Icons.person, size: size.height * 0.037),
                              SizedBox(width: 15),
                              Text("Profile")
                            ])))),
                    PopupMenuItem(
                        child: GestureDetector(
                            onTap: () => logout(),
                            child: Container(
                                child: Row(children: [
                              Icon(Icons.logout, size: size.height * 0.037),
                              SizedBox(width: 15),
                              Text("Logout")
                            ]))))
                  ])
        ]));
  }

  Widget buildSearch() {
    return Container(
        child: Card(
            elevation: 5,
            child: new ListTile(
                leading: Icon(Icons.search),
                title: new TextField(
                    controller: searchController,
                    decoration: new InputDecoration(
                        hintText: 'Search', border: InputBorder.none),
                    onChanged: (value) {
                      search(value.toLowerCase().trim());
                    }))));
  }

  Widget buildSelectLs() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      GestureDetector(
          onTap: () {
            setState(() {
              refreshAllMessage();
              isSelect = true;
            });
          },
          child: Card(
              elevation: 5,
              child: Container(
                  color: isSelect ? AppColors.SENDMESSAGE : AppColors.WHITE,
                  width: size.width * 0.45,
                  height: size.height * 0.05,
                  child: Center(child: Text("Đã tương tác"))))),
      GestureDetector(
          onTap: () {
            setState(() {
              refreshUsers();
              isSelect = false;
            });
          },
          child: Card(
              elevation: 5,
              child: Container(
                  color: !isSelect ? AppColors.SENDMESSAGE : AppColors.WHITE,
                  width: size.width * 0.45,
                  height: size.height * 0.05,
                  child: Center(child: Text("Người dùng hệ thống")))))
    ]);
  }

  void search(String value) async {
    String searchKey = searchController.value.text.toLowerCase().trim();
    await refreshUsers();
    await refreshAllMessage();
    if (searchKey.isNotEmpty) {
      setState(() {
        listUserInteractive
            .removeWhere((u) => !u.userName.toLowerCase().contains(value));

        listUsers.removeWhere((u) => !u.userName.toLowerCase().contains(value));
      });
    }
  }

  Future getUserPreference() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userId');
  }

  void logout() {
    //xóa thông tin user đã login
    getUserPreference();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginView()),
        (Route<dynamic> route) => false);
  }

  void goToProfile() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProfileView(user: widget.user)));
  }
}
