import 'package:message/databases/questiondb.dart';

final String tableQuestion = "questions";

class QuestionFields {
  static final List<String> values = [
    id,
    topicId,
    content,
    answer1,
    answer2,
    answer3,
    answer4,
    correctAnswer,
    information
  ];

  static final String id = 'id';
  static final String topicId = 'topicId';
  static final String content = 'content';
  static final String answer1 = 'answer1';
  static final String answer2 = 'answer2';
  static final String answer3 = 'answer3';
  static final String answer4 = 'answer4';
  static final String correctAnswer = 'correctAnswer';
  static final String information = 'information';
}

class Question {
  final int? id;
  final int topicId;
  final String content;
  final String answer1;
  final String answer2;
  final String answer3;
  final String answer4;
  final String correctAnswer;
  final String information;
  Question(
      {this.id,
      required this.topicId,
      required this.content,
      required this.answer1,
      required this.answer2,
      required this.answer3,
      required this.answer4,
      required this.correctAnswer,
      required this.information});

  //khi goi ham copy thi se tra ve mot Topic
  Question copy(
          {int? id,
          int? topicId,
          String? content,
          String? answer1,
          String? answer2,
          String? answer3,
          String? answer4,
          String? correctAnswer,
          String? information}) =>
      Question(
          id: id ?? this.id,
          topicId: topicId ?? this.topicId,
          content: content ?? this.content,
          answer1: answer1 ?? this.answer1,
          answer2: answer2 ?? this.answer2,
          answer3: answer3 ?? this.answer3,
          answer4: answer4 ?? this.answer4,
          correctAnswer: correctAnswer ?? this.correctAnswer,
          information: information ?? this.information);

  static Question fromJson(Map<String, Object?> json) => Question(
      id: json[QuestionFields.id] as int,
      topicId: json[QuestionFields.topicId] as int,
      content: json[QuestionFields.content] as String,
      answer1: json[QuestionFields.answer1] as String,
      answer2: json[QuestionFields.answer2] as String,
      answer3: json[QuestionFields.answer3] as String,
      answer4: json[QuestionFields.answer4] as String,
      correctAnswer: json[QuestionFields.correctAnswer] as String,
      information: json[QuestionFields.information] as String);

  Map<String, Object?> toJson() => {
        QuestionFields.id: id,
        QuestionFields.topicId: topicId,
        QuestionFields.content: content,
        QuestionFields.answer1: answer1,
        QuestionFields.answer2: answer2,
        QuestionFields.answer3: answer3,
        QuestionFields.answer4: answer4,
        QuestionFields.correctAnswer: correctAnswer,
        QuestionFields.information: information
      };
}

List<Question> lsQuestion = [
  Question(
      topicId: 1,
      content: "1 + 1 b???ng m???y",
      answer1: "b???ng 1",
      answer2: "B???ng 2",
      answer3: "B???ng 3",
      answer4: "B???ng 4",
      correctAnswer: "B???ng 2",
      information: "Kh??ng c?? th??ng tin th??m"),
  Question(
      topicId: 1,
      content: "Trong m???t tam gi??c c??:",
      answer1: "3 c???nh",
      answer2: "3 g??c",
      answer3: "3 ?????nh",
      answer4: "C??? A,B,C ?????u ????ng",
      correctAnswer: "C??? A,B,C ?????u ????ng",
      information:
          "Tam gi??c ABC l?? h??nh g???m ba ??o???n th???ng AB, BC, CA khi ba ??i???m A, B, C kh??ng th???ng h??ng."),
  Question(
      topicId: 1,
      content:
          "T??nh di???n t??ch h??nh tam gi??c c?? ????? d??i ????y l?? 5m v?? chi???u cao l?? 27dm.",
      answer1: "67,5m2",
      answer2: "67,5dm2",
      answer3: "675m2",
      answer4: "675dm2",
      correctAnswer: "675dm2",
      information: "Kh??ng c?? th??ng tin th??m"),
  Question(
      topicId: 1,
      content: "T??nh: 41,22 : 3",
      answer1: "1,374",
      answer2: "13,74",
      answer3: "137,4",
      answer4: "1374",
      correctAnswer: "13,74",
      information: "Kh??ng c?? th??ng tin th??m"),
  Question(
      topicId: 1,
      content: "T??m x bi???t: 5 ?? x = 82,7",
      answer1: "x = 14,56",
      answer2: "x = 15,56",
      answer3: "x = 15,64",
      answer4: "x = 16,54",
      correctAnswer: "x = 16,54",
      information: "Kh??ng c?? th??ng tin th??m"),
];

//database question with sqlite (insert)
Future<List<Question>> addQuestion(int id) async {
  List<Question> ls = await QuestionsDatabase.instance.readAllQuestion();
  List<Question> lsById = await QuestionsDatabase.instance.readQuestionById(id);

  if (ls.isEmpty) {
    for (Question i in lsQuestion) {
      await QuestionsDatabase.instance.create(i);
    }
    print("N???p question cho data khi restart");
    lsById = await QuestionsDatabase.instance.readQuestionById(id);
  }
  return lsById;
}
