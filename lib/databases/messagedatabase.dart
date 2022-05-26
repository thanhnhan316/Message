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

// //Cập nhật thông tin một message
//   Future<int> update(Message users) async {
//     final db = await instance.database;

//     return db.update(
//       tableMessage,
//       users.toJson(),
//       where: '${MessageFields.id} = ?',
//       whereArgs: [users.id],
//     );
//   }

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
