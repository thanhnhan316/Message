import 'package:flutter/material.dart';
import 'package:message/configs/appcolors.dart';
import 'package:message/configs/appimages.dart';
import 'package:message/models/user.dart';
import 'package:message/view/chatview.dart';

class ListChatView extends StatefulWidget {
  List<User> listUsers;
  bool isLoading;
  ListChatView({Key? key, required this.listUsers, required this.isLoading})
      : super(key: key);

  @override
  State<ListChatView> createState() => _ListChatViewState();
}

class _ListChatViewState extends State<ListChatView> {
  late Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return buildListChat();
  }

  Widget buildListChat() {
    return widget.isLoading
        ? CircularProgressIndicator()
        : Expanded(
            child: ListView.builder(
                itemCount:
                    widget.listUsers.length > 0 ? widget.listUsers.length : 0,
                itemBuilder: (BuildContext context, int index) {
                  final User user = widget.listUsers[index];
                  return GestureDetector(
                      onTap: () {
                        goToChat(user);
                      },
                      child: Container(
                          margin: EdgeInsets.only(bottom: 15),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(children: <Widget>[
                                  CircleAvatar(
                                      radius: size.height * 0.032,
                                      backgroundImage:
                                          AssetImage(AppImages.imgLogo)),
                                  SizedBox(width: 10.0),
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          user.userName,
                                          style: TextStyle(
                                              color: AppColors.BLACK87,
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 5.0),
                                        Container(
                                            width: size.width * 0.45,
                                            child: Text(user.email,
                                                style: TextStyle(
                                                  color: AppColors.BLACK38,
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                overflow:
                                                    TextOverflow.ellipsis))
                                      ])
                                ]),
                                Column(
                                  children: <Widget>[
                                    Text("22 : 02",
                                        style: TextStyle(
                                            color: AppColors.BLACK38,
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(height: 5.0),
                                  ],
                                )
                              ])));
                }),
          );
  }

  void goToChat(User user) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ChatView(user: user)));
  }
}
