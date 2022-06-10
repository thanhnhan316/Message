import 'dart:io';
import 'package:flutter/services.dart';
import 'package:message/models/question.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class QuestionsDatabase {
  static final QuestionsDatabase instance = QuestionsDatabase._init();
  static Database? _database;
  QuestionsDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('questions.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    ///data/user/0/com.example.message/databases/questions.db
    print(path);

    // //xóa db(nếu reStart App thì db sẽ bị xóa tất cả nên sẽ không dùng deleteDatabase)
    await deleteDatabase(path);

    // Kiểm tra xem cơ sở dữ liệu có tồn tại không
    var exists = await databaseExists(path);

    if (!exists) {
      // Chỉ xảy ra lần đầu tiên bạn khởi chạy ứng dụng
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      // Sao chép từ nội dung
      ByteData data = await rootBundle.load(join("assets/db", filePath));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Viết và xóa các byte đã viết
      await File(path).writeAsBytes(bytes, flush: true);
    }

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final intType = 'INTEGER NOT NULL';
    final textType = 'TEXT NOT NULL';

    await db.execute('''
CREATE TABLE $tableQuestion ( 
  ${QuestionFields.id} $idType,
  ${QuestionFields.topicId} $intType,
  ${QuestionFields.content} $textType,
  ${QuestionFields.answer1} $textType,
  ${QuestionFields.answer2} $textType,
  ${QuestionFields.answer3} $textType,
  ${QuestionFields.answer4} $textType,
  ${QuestionFields.correctAnswer} $textType,
  ${QuestionFields.information} $textType
  )
''');
  }

  //Tạo một Question mới
  Future<Question> create(Question question) async {
    final db = await instance.database;
    final id = await db.insert(tableQuestion, question.toJson());
    return question.copy(id: id);
  }

  //Lấy 1 Question qua id
  Future<Question> readQuestion(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      tableQuestion,
      columns: QuestionFields.values,
      where: '${QuestionFields.id} = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Question.fromJson(maps.first);
    }
    throw Exception('IDQuestion  $id not found');
  }

  //Lấy tất cả Question
  Future<List<Question>> readAllQuestion() async {
    final db = await instance.database;
    // sắp xếp
    // final orderBy = '${QuestionFields.QuestionName} ASC';
    final result = await db.query(tableQuestion);
    return result.map((json) => Question.fromJson(json)).toList();
  }

  //Lấy tất cả Question có id là id
  Future<List<Question>> readQuestionById(int id) async {
    final db = await instance.database;
    // điều kiện
    final where = '${QuestionFields.topicId} = $id';
    final result = await db.query(tableQuestion, where: where);
    return result.map((json) => Question.fromJson(json)).toList();
  }

//Cập nhật thông tin một Question
  Future<int> update(Question question) async {
    final db = await instance.database;

    return db.update(
      tableQuestion,
      question.toJson(),
      where: '${QuestionFields.id} = ?',
      whereArgs: [question.id],
    );
  }

//Xóa thông tin một Question
  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      tableQuestion,
      where: '${QuestionFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
