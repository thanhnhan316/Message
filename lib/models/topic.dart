import 'package:message/databases/topicdb.dart';

final String tableTopic = "topics";

//đặt tên field để thống nhất tên chung
class TopicFields {
  static final List<String> values = [id, topicName];
  static final String id = 'id';
  static final String topicName = 'topicName';
}

class Topic {
  final int? id;
  final String topicName;

  Topic({this.id, required this.topicName});

  //khi goi ham copy thi se tra ve mot Topic
  Topic copy({int? id, String? topicName}) =>
      Topic(id: id ?? this.id, topicName: topicName ?? this.topicName);

  static Topic fromJson(Map<String, Object?> json) => Topic(
      id: json[TopicFields.id] as int?,
      topicName: json[TopicFields.topicName] as String);

  Map<String, Object?> toJson() => {
        TopicFields.id: id,
        TopicFields.topicName: topicName,
      };
}

List<String> lsTopicName = [
  "Toán hình học 12",
  "Toán đại số 12",
  "Sinh học 12",
  "Tin học 12",
  "Lịch sử 10",
  "Vật lý 11",
  "Hóa học 10",
  "Hóa học 11",
  "Toán đại số 10",
  "Toán đại số 11"
];
//database topic with sqlite (insert)
Future<List<Topic>> addTopic() async {
  List<Topic> lsTopic = await TopicDatabase.instance.readAllTopic();

  if (lsTopic.isEmpty) {
    for (String i in lsTopicName) {
      final topic = Topic(topicName: i);
      await TopicDatabase.instance.create(topic);
    
    }
    print("Nạp topic cho data khi restart");
    lsTopic = await TopicDatabase.instance.readAllTopic();
  }
  return lsTopic;
}
