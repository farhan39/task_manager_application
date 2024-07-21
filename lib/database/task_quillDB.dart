import 'package:task_quill/Models/user_info.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TaskQuillDB {
  Database? _database;

  Future<Database> get database async {
    if (_database != null)
      return _database!;

    _database = await _initialize();
    return _database!;
  }

  Future<Database> _initialize() async {
    final String path = join(await getDatabasesPath(), 'task_quill.db');
    return await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          await db.execute(
          '''
            CREATE TABLE user_info (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT NOT NULL,
              email TEXT NOT NULL UNIQUE,
              password TEXT NOT NULL,
              age INTEGER,
              bio TEXT,
              interests TEXT
            )
            '''
          );
          await db.execute(
          '''
            CREATE TABLE task_info (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              title TEXT NOT NULL,
              subtitle TEXT,
              description TEXT
            )
            '''
          );
        }
    );
  }

  Future<int> insertUser(UserInfo user) async {
    final db = await database;
    return await db.rawInsert(
      """INSERT INTO user_info (id, name, email, password, age, bio, interests)
       VALUES (?, ?, ?, ?, ?, ?, ?)""",
      [user.id, user.name, user.email, user.password, user.age, user.bio, user.interests],
    );
  }

  // Future<List<UserInfo>> fetchUsers() async{
  //   final db = await database;
  //   final List<Map<String, dynamic>> maps = await db.query('user_info');
  //   return List.generate(maps.length, (i) {
  //     return UserInfo( // Step 4
  //       name: maps[i]['name'],
  //       email: maps[i]['email'],
  //       password: maps[i]['password'],
  //       age: maps[i]['age'],
  //       bio: maps[i]['bio'],
  //       interests: maps[i]['interests'],
  //     );
  //   });
  // }

  Future<UserInfo?> checkUser(String email, String password) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'user_info',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (maps.isNotEmpty) {
      return UserInfo(
        name: maps[0]['name'],
        email: maps[0]['email'],
        password: maps[0]['password'],
        age: maps[0]['age'],
        bio: maps[0]['bio'],
        interests: maps[0]['interests'],
      );
    } else {
      return null;
    }
  }

  Future<bool> checkIfEmailExists(String email) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'user_info',
      where: 'email = ?',
      whereArgs: [email],
    );
    return result.isNotEmpty;
  }
}