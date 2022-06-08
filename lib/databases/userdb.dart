import 'dart:io';

import 'package:flutter/services.dart';
import 'package:message/models/user.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class UserDatabase {
  static final UserDatabase instance = UserDatabase._init();
  static Database? _database;
  UserDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('users.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    ///data/user/0/com.example.message/databases/users.db
    print(path);

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

    return await openDatabase(path,
        readOnly: true, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';

    await db.execute('''
CREATE TABLE $tableUser ( 
  ${UserFields.id} $idType, 
  ${UserFields.userName} $textType,
  ${UserFields.fullName} $textType,
  ${UserFields.password} $textType,
  ${UserFields.email} $textType,
  ${UserFields.avatar} $textType,
  ${UserFields.status} $textType)
''');
  }

  //Tạo một user mới
  Future<User> create(User users) async {
    final db = await instance.database;
    final id = await db.insert(tableUser, users.toJson());
    return users.copy(id: id);
  }

  //Lấy 1 user qua id
  Future<User> readUser(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      tableUser,
      columns: UserFields.values,
      where: '${UserFields.id} = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return User.fromJson(maps.first);
    }
    throw Exception('ID $id not found');
  }

  //Lấy tất cả user
  Future<List<User>> readAllUser() async {
    final db = await instance.database;
    // sắp xếp
    // final orderBy = '${UserFields.userName} ASC';
    final result = await db.query(tableUser);
    return result.map((json) => User.fromJson(json)).toList();
  }

//Cập nhật thông tin một user
  Future<int> update(User users) async {
    final db = await instance.database;

    return db.update(
      tableUser,
      users.toJson(),
      where: '${UserFields.id} = ?',
      whereArgs: [users.id],
    );
  }

//Xóa thông tin một user
  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      tableUser,
      where: '${UserFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
