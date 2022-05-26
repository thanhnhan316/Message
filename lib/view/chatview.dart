import 'package:flutter/material.dart';
import 'package:message/configs/appcolors.dart';
import 'package:message/configs/appimages.dart';
import 'package:message/databases/messagedatabase.dart';
import 'package:message/models/message.dart';
import 'package:message/models/user.dart';
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
    print(userId);
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
            radius: size.height * 0.027,
            backgroundImage: AssetImage(AppImages.Logo),
          ),
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
      child:ls.length == 0 ? Center(child: Text("Chưa có tin nhắn nào")): isLoading
          ? Container(
              height: size.height * 0.1, child: CircularProgressIndicator())
          : ListView.builder(
              reverse: true,
              padding: EdgeInsets.only(top: 15.0),
              itemCount: ls.length,
              itemBuilder: (BuildContext context, int index) {
                return buildMessage(ls[index]);
              },
            ),
    );
  }

  Widget buildMessage(Message message) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 17, vertical: 9),
        margin: message.senderId == userId
            ? EdgeInsets.only(bottom: 10, left: size.width * 0.3)
            : EdgeInsets.only(bottom: 10, right: size.width * 0.3),
        decoration: BoxDecoration(
            color: message.senderId == userId
                ? AppColors.SENDMESSAGE
                : AppColors.WHITE,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                bottomLeft: Radius.circular(15.0))),
        child: Container(
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: message.senderId == userId
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: <Widget>[
                Text(message.time,
                    style: TextStyle(
                        color: AppColors.BLACK38,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600)),
                SizedBox(height: 8.0),
                Text(message.value,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ))
              ]),
        ));
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
        inputController.value = TextEditingValue.empty;
      });
      print(
          "senderId = ${message.senderId}, receiverId = ${message.receiverId}, value = ${message.value},time = ${message.time}");
      refreshAllMessage();
    }
  }
}
