import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:message/configs/appcolors.dart';
import 'package:message/configs/appimages.dart';
import 'package:message/configs/appvalues.dart';
import 'package:message/databases/messagedb.dart';
import 'package:message/models/message.dart';
import 'package:message/models/user.dart';
import 'package:message/widgets/message.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatView extends StatefulWidget {
  User user;
  ChatView({Key? key, required this.user}) : super(key: key);

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  dynamic inputController = TextEditingController();
  late int userId;
  bool isLoading = false;
  late List<Message> ls = [];
  @override
  void initState() {
    super.initState();
    getUserPreference();
    refreshAllMessage();
  }

  //lấy thông tin user đã login
  Future getUserPreference() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('userId') ?? 0;
  }

  Future refreshAllMessage() async {
    setState(() {
      isLoading = true;
    });

    List<Message> list = await MessageDatabase.instance.readAllMessage();
    // chỉ lấy những tin nhắn liên quan đến người gửi và người nhận
    ls = [];
    for (Message i in list) {
      if ((i.senderId == userId && i.receiverId == widget.user.id) ||
          (i.senderId == widget.user.id && i.receiverId == userId)) {
        ls.add(i);
      }
    }
    ls = ls.reversed.toList();
    for (Message i in ls) {
      print(
          "senderId = ${i.senderId}, receiverId = ${i.receiverId}, value = ${i.value},time = ${i.time}");
    }
    setState(() {
      isLoading = false;
    });
  }

  late Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.WHITE,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            buildHeader(),
            buildContent(),
            inputMessage(),
          ],
        ),
      ),
    );
  }

  Widget buildHeader() {
    return Container(
      height: size.height * 0.086,
      color: AppColors.WHITE,
      padding: EdgeInsets.only(left: 10),
      child: Row(
        children: <Widget>[
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back,
                  color: AppColors.BLACK87, size: size.height * 0.04)),
          Spacer(flex: 2),
          CircleAvatar(
              radius: size.height * 0.032,
              child: widget.user.avatar == "avatar"
                  ? ClipRRect(
                      child: Image.network(
                          "https://cdn-icons-png.flaticon.com/512/149/149071.png"),
                      borderRadius: BorderRadius.circular(50.0))
                  : ClipRRect(
                      child: Image.memory(base64Decode(widget.user.avatar),
                          width: double.maxFinite,
                          height: double.maxFinite,
                          fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(50.0))),
          Spacer(flex: 1),
          Text(widget.user.userName,
              style: TextStyle(
                  color: AppColors.BLACK87,
                  fontSize: size.height * 0.027,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0)),
          Spacer(flex: 20),
          IconButton(
              icon: Icon(Icons.phone_forwarded_outlined),
              iconSize: size.height * 0.035,
              color: AppColors.BLACK87,
              onPressed: () {}),
          Spacer(flex: 2),
        ],
      ),
    );
  }

  Widget buildContent() {
    return Expanded(
        child: ls.length == 0
            ? Center(child: Text(AppValues.noMessage))
            : isLoading
                ? Container(
                    height: size.height * 0.1,
                    child: CircularProgressIndicator())
                : MessageItem(ls: ls, userId: userId));
  }

  inputMessage() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        height: size.height * 0.086,
        child: Column(children: [
          Container(
              width: double.maxFinite, height: 2, color: AppColors.BACKGROUND),
          SizedBox(height: 10),
          Row(children: [
            Expanded(
                child: Container(
                    child: Row(children: [
                      IconButton(
                          icon: Icon(Icons.photo),
                          iconSize: size.height * 0.04,
                          color: AppColors.BACKGROUND,
                          onPressed: () {}),
                      Expanded(
                          child: TextField(
                              controller: inputController,
                              textCapitalization: TextCapitalization.sentences,
                              decoration: InputDecoration.collapsed(
                                hintText: 'Type a message...',
                              )))
                    ]),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.BACKGROUND),
                      borderRadius: BorderRadius.circular(20),
                    ))),
            SizedBox(width: 10),
            Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: AppColors.BACKGROUND),
                child: IconButton(
                    icon: Icon(Icons.send),
                    iconSize: size.height * 0.04,
                    color: AppColors.WHITE,
                    onPressed: () {
                      sendMessage();
                    }))
          ])
        ]));
  }

  void sendMessage() async {
    DateTime _now = DateTime.now();
    String timeNow = '${_now.hour}:${_now.minute}';
    if (inputController.value.text != "") {
      final message = Message(
          senderId: userId,
          receiverId: widget.user.id ?? 0,
          value: inputController.value.text,
          time: timeNow);
      await MessageDatabase.instance.create(message);
      setState(() {
        inputController.clear();
      });
      print(
          "senderId = ${message.senderId}, receiverId = ${message.receiverId}, value = ${message.value},time = ${message.time}");
      refreshAllMessage();
    }
  }
}
