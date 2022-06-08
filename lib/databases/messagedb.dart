import 'dart:io';
import 'package:flutter/services.dart';
import 'package:message/models/message.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class MessageDatabase {
  static final MessageDatabase instance = MessageDatabase._init();
  static Database? _database;
  MessageDatabase._init();
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('messages.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

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
    final intType = 'INTEGER NOT NULL';
    final textType = 'TEXT NOT NULL';

    await db.execute('''
CREATE TABLE $tableMessage ( 
  ${MessageFields.id} $idType, 
  ${MessageFields.senderId} $intType,
  ${MessageFields.receiverId} $intType,
  ${MessageFields.value} $textType,
  ${MessageFields.time} $textType)
''');
  }

  //Tạo một message mới
  Future<Message> create(Message message) async {
    final db = await instance.database;
    final id = await db.insert(tableMessage, message.toJson());
    return message.copy(id: id);
  }

  //Lấy 1 message qua id
  Future<Message> readMessage(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      tableMessage,
      columns: MessageFields.values,
      where: '${MessageFields.id} = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Message.fromJson(maps.first);
    }
    throw Exception('ID $id not found');
  }

  //Lấy tất cả message
  Future<List<Message>> readAllMessage() async {
    final db = await instance.database;
    // sắp xếp
    // final orderBy = '${UserFields.userName} ASC';
    // final result =
    //     await db.rawQuery('SELECT * FROM $tableNotes ORDER BY $orderBy');

    final result = await db.query(tableMessage);
    return result.map((json) => Message.fromJson(json)).toList();
  }

//Xóa thông tin một message
  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      tableMessage,
      where: '${MessageFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
