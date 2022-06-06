import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:message/configs/appcolors.dart';
import 'package:message/configs/appimages.dart';
import 'package:message/databases/userdatabase.dart';
import 'package:message/models/user.dart';
import 'package:message/view/chat/chatview.dart';
import 'package:message/view/chat/homechatview.dart';

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
            child: widget.listUsers.isEmpty
                ? Center(child: Text("Chưa có tin nhắn!"))
                : ListView.builder(
                    itemCount: widget.listUsers.length > 0
                        ? widget.listUsers.length
                        : 0,
                    itemBuilder: (BuildContext context, int index) {
                      final User user = widget.listUsers[index];
                      return GestureDetector(
                          onTap: () {
                            goToChat(user);
                          },
                          child: Slidable(
                              child: buildChat(user),
                              endActionPane: ActionPane(
                                  motion: const DrawerMotion(),
                                  children: [
                                    SlidableAction(
                                        backgroundColor: Color(0xFF21B7CA),
                                        foregroundColor: Colors.white,
                                        icon: Icons.info,
                                        label: 'thông tin',
                                        onPressed: (BuildContext context) {
                                          showNotification(user);
                                        }),
                                    SlidableAction(
                                        backgroundColor: Color(0xFFFE4A49),
                                        foregroundColor: Colors.white,
                                        icon: Icons.delete,
                                        label: 'xóa',
                                        onPressed: (BuildContext context) {
                                          showDelete(user);
                                        })
                                  ])));
                    }));
  }

  Widget buildChat(User user) {
    return Container(
        margin: EdgeInsets.only(bottom: 15),
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(children: <Widget>[
                CircleAvatar(
                    radius: size.height * 0.032,
                    backgroundImage: AssetImage(AppImages.imgLogo)),
                SizedBox(width: 10.0),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                              overflow: TextOverflow.ellipsis))
                    ])
              ]),
              Column(children: <Widget>[
                Text("22 : 02",
                    style: TextStyle(
                        color: AppColors.BLACK38,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 5.0),
              ])
            ]));
  }

  void goToChat(User user) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ChatView(user: user)));
  }

  void showNotification(User user) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text('Thông tin'),
              content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Tên: ${user.userName}'),
                    Text('Họ Tên: ${user.fullName}'),
                    Text('Email: ${user.email}'),
                    Text('Tình trạng: ${user.status}')
                  ]),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('thoát'))
              ]);
        });
  }

  void showDelete(User user) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text('Xóa'),
              content: Text('${user.userName} sẽ bị xóa khỏi hệ thống!'),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Hủy')),
                TextButton(
                    onPressed: () {
                      deleteUser(user.id);
                    },
                    child: Text('Xóa'))
              ]);
        });
  }

  void deleteUser(int? id) async {
    await UserDatabase.instance.delete(id ?? 0);
    print("xóa thành công");
    Navigator.pop(context);
    setState(() {
      widget.listUsers.removeWhere((i) => i.id == id);
    });
  }
}
