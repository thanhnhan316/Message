import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:message/configs/appcolors.dart';
import 'package:message/databases/messagedb.dart';
import 'package:message/models/message.dart';

class MessageItem extends StatefulWidget {
  List<Message> ls;
  int userId;
  MessageItem({Key? key, required this.ls, required this.userId})
      : super(key: key);

  @override
  State<MessageItem> createState() => _MessageState();
}

class _MessageState extends State<MessageItem> {
  List<bool> checkDelete = [];
  late Size size;
  @override
  void initState() {
    super.initState();
    for (Message i in widget.ls) checkDelete.add(false);
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return ListView.builder(
      reverse: true,
      padding: EdgeInsets.only(top: 15.0),
      itemCount: widget.ls.length,
      itemBuilder: (BuildContext context, int index) {
        return buildMessage(widget.ls[index], index);
      },
    );
  }

  Widget buildMessage(Message message, int index) {
    return GestureDetector(
        onLongPress: () {
          setState(() {
            checkDelete[index] = true;
          });
        },
        child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: message.senderId == widget.userId
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Container(
                  constraints: BoxConstraints(maxWidth: size.width * 0.75),
                  padding:
                      EdgeInsets.only(top: 5, bottom: 5, left: 15, right: 15),
                  margin: EdgeInsets.only(bottom: 7),
                  decoration: BoxDecoration(
                      color: message.senderId == widget.userId
                          ? AppColors.SENDMESSAGE
                          : AppColors.WHITE,
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(message.time,
                            style: TextStyle(
                                color: AppColors.BLACK38,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600)),
                        SizedBox(height: 8.0),
                        Text(message.value,
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.w600))
                      ])),
              checkDelete[index]
                  ? message.senderId == widget.userId
                      ? Row(mainAxisSize: MainAxisSize.min, children: [
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  checkDelete[index] = false;
                                });
                              },
                              child: Text("hủy")),
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  checkDelete[index] = false;
                                });
                                delete(message.id, index);
                              },
                              child: Text("xóa"))
                        ])
                      : SizedBox.shrink()
                  : SizedBox.shrink()
            ]));
  }

  void delete(int? id, int index) async {
    await MessageDatabase.instance.delete(id ?? 0);
    print("Xóa thành công");
    setState(() {
      widget.ls.removeAt(index);
    });
  }
}
