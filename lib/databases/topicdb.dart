import 'dart:io';
import 'package:flutter/services.dart';
import 'package:message/models/topic.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class TopicDatabase {
  static final TopicDatabase instance = TopicDatabase._init();
  static Database? _database;
  TopicDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('topics.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    ///data/user/0/com.example.message/databases/topics.db
    print(path);

    // //xóa db(nếu reStart App thì db sẽ bị xóa tất cả nên sẽ không dùng deleteDatabase)
    // await deleteDatabase(path);

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
    final textType = 'TEXT NOT NULL';

    await db.execute('''
CREATE TABLE $tableTopic ( 
  ${TopicFields.id} $idType, 
  ${TopicFields.topicName} $textType
  )
''');
  }

  //Tạo một Topic mới
  Future<Topic> create(Topic topic) async {
    final db = await instance.database;
    final id = await db.insert(tableTopic, topic.toJson());
    return topic.copy(id: id);
  }

  //Lấy 1 Topic qua id
  Future<Topic> readTopic(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      tableTopic,
      columns: TopicFields.values,
      where: '${TopicFields.id} = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Topic.fromJson(maps.first);
    }
    throw Exception('IDTopic  $id not found');
  }

  //Lấy tất cả Topic
  Future<List<Topic>> readAllTopic() async {
    final db = await instance.database;
    // sắp xếp
    // final orderBy = '${TopicFields.topicName} ASC';
    final result = await db.query(tableTopic);
    return result.map((json) => Topic.fromJson(json)).toList();
  }

//Cập nhật thông tin một Topic
  Future<int> update(Topic topic) async {
    final db = await instance.database;

    return db.update(
      tableTopic,
      topic.toJson(),
      where: '${TopicFields.id} = ?',
      whereArgs: [topic.id],
    );
  }

//Xóa thông tin một Topic
  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      tableTopic,
      where: '${TopicFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
