import 'package:flutter/material.dart';
import 'package:message/configs/appcolors.dart';
import 'package:message/configs/appimages.dart';
import 'package:message/databases/userdatabase.dart';
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
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    refreshUsers();
    getUsserPreference();
  }

  // Preference userId
  Future getUsserPreference() async {
    final prefs = await SharedPreferences.getInstance();
    int? counter = prefs.getInt('userId');
    print("id user: " + counter.toString());
  }

  Future refreshUsers() async {
    setState(() {
      isLoading = true;
    });
    listUsers = await UserDatabase.instance.readAllUser();
    //xóa user đăng nhập
    listUsers.removeWhere((i) => i.id == widget.user.id);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.WHITE,
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            buildAppBar(),
            buildSearch(),
            ListChatView(listUsers: listUsers, isLoading: isLoading),
          ],
        ),
      ),
    );
  }

  Widget buildAppBar() {
    return Container(
        width: double.maxFinite,
        height: size.height * 0.11,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
                radius: size.height * 0.032,
                backgroundImage: AssetImage(AppImages.Logo)),
            Text(widget.user.userName,
                style: TextStyle(
                    fontSize: size.height * 0.035,
                    fontWeight: FontWeight.bold)),
            PopupMenuButton(
                itemBuilder: (context) => [
                      PopupMenuItem(
                          child: GestureDetector(
                              onTap: () => goToProfile(),
                              child: Row(children: [
                                Icon(Icons.person, size: size.height * 0.037),
                                SizedBox(width: 15),
                                Text("Profile")
                              ]))),
                      PopupMenuItem(
                          child: GestureDetector(
                              onTap: () => logout(),
                              child: Row(children: [
                                Icon(Icons.logout, size: size.height * 0.037),
                                SizedBox(width: 15),
                                Text("Logout")
                              ])))
                    ])
          ],
        ));
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
                },
              ),
            )));
  }

  void search(String value) async {
    String searchKey = searchController.value.text.toLowerCase().trim();
    await refreshUsers();

    if (searchKey.isNotEmpty) {
      setState(() {
        listUsers.removeWhere((u) => !u.userName.toLowerCase().contains(value));
      });
    }
    print("Search  " + listUsers.length.toString());
    print(widget.user.id);
    UserDatabase.instance.delete(20);
  }

  Future getUserPreference() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userId');
  }

  void logout() {
    //xóa thông tin user đã login
    getUserPreference();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginView()));
  }
  void goToProfile(){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileView(user: widget.user)));
  }
}
