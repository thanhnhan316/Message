import 'package:message/models/user.dart';

final String tableMessage = "messages";

//đặt tên để thống nhất tên chung
class MessageFields {
  static final List<String> values = [id, senderId, receiverId, value, time];

  static final String id = 'id';
  static final String senderId = 'senderId';
  static final String receiverId = 'receiverId';
  static final String value = 'value';
  static final String time = 'time';
}

class Message {
  final int? id;
  final int senderId;
  final int receiverId;
  final String value;
  final String time;

  Message(
      {this.id,
      required this.senderId,
      required this.receiverId,
      required this.value,
      required this.time});

  Message copy(
          {int? id,
          int? senderId,
          int? receiverId,
          String? value,
          String? time}) =>
      Message(
          id: id ?? this.id,
          senderId: senderId ?? this.senderId,
          receiverId: receiverId ?? this.receiverId,
          value: value ?? this.value,
          time: time ?? this.time);

// từ json trả về đối tượng Message
  static Message fromJson(Map<String, Object?> json) => Message(
      id: json[MessageFields.id] as int,
      senderId: json[MessageFields.senderId] as int,
      receiverId: json[MessageFields.receiverId] as int,
      value: json[MessageFields.value] as String,
      time: json[MessageFields.time] as String);
// Đưa về chuỗi json
  Map<String, Object?> toJson() => {
        MessageFields.id: id,
        MessageFields.senderId: senderId,
        MessageFields.receiverId: receiverId,
        MessageFields.value: value,
        MessageFields.time: time
      };
}
