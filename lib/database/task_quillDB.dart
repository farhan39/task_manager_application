import 'package:task_quill/Models/user_info.dart';
import 'package:task_quill/Models/task_info.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:typed_data';


class TaskQuillDB {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initialize();
    return _database!;
  }

  static Future<void> deleteDatabase1() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'task_quill.db');

    await deleteDatabase(path);
    print("Database deleted");
  }

  Future<Database> _initialize() async {
    final String path = join(await getDatabasesPath(), 'task_quill.db');
    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''
          CREATE TABLE user_info (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            email TEXT NOT NULL UNIQUE,
            password TEXT NOT NULL,
            age INTEGER,
            bio TEXT,
            interests TEXT,
            profileImage BLOB
          )
          ''');
      await db.execute('''
          CREATE TABLE task_info (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            subtitle TEXT,
            description TEXT,
            userId INTEGER,
            isCompleted INTEGER,
            dueDate TEXT NOT NULL,
            FOREIGN KEY(userId) REFERENCES user_info(id) ON DELETE CASCADE
          )
          ''');
    }
    );
  }

  Future<int> insertUser(UserInfo user) async {
    final db = await database;
    return await db.insert('user_info', user.toMap());
  }

  Future<void> insertTaskForUser(int? userId, Task task) async {
    final db = await database;
    await db.insert(
      'task_info',
      task.toMap()..['userId'] = userId,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateTaskStatus(int taskId, int isCompleted) async {
    final db = await database;

    await db.update(
      'task_info',
      {'isCompleted': isCompleted},
      where: 'id = ?',
      whereArgs: [taskId],
    );
  }

  Future<void> deleteCompletedTaskForUser(int taskId, int userId) async {
    final db = await database;

    await db.delete(
      'task_info',
      where: 'id = ? AND userId = ? AND isCompleted = 0',
      whereArgs: [taskId, userId],
    );
  }

  Future<void> deleteIncompleteTaskForUser(int taskId, int userId) async {
    final db = await database;

    await db.delete(
      'task_info',
      where: 'id = ? AND userId = ? AND isCompleted = 1',
      whereArgs: [taskId, userId],
    );
  }

  Future<void> deleteUpcomingTaskForUser(int taskId, int userId) async {
    final db = await database;

    // Get the current date
    DateTime currentDate = DateTime.now();
    String formattedCurrentDate = "${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.day.toString().padLeft(2, '0')}";

    await db.delete(
      'task_info',
      where: 'id = ? AND userId = ? AND isCompleted = 0 AND dueDate != ?',
      whereArgs: [taskId, userId, formattedCurrentDate],
    );
  }


  Future<void> updateTaskForUser(Task task) async {
    final db = await database;

    await db.update(
      'task_info',
      {
        'title': task.title,
        'subtitle': task.subtitle,
        'description': task.description,
        'dueDate': task.dueDate.toIso8601String(),
      },
      where: 'id = ? AND userId = ?',
      whereArgs: [task.id, task.userId],
    );
  }

  // Add this method to the TaskQuillDB class
  Future<List<Task>> fetchIncompleteTasksForUser(int? userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
        'task_info',
        where: 'userId = ? AND isCompleted = ?',
        whereArgs: [userId, 0]
    );

    DateTime now = DateTime.now();
    String today = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    List<Task?> tasks = List.generate(maps.length, (i) {
      DateTime dueDate = DateTime.parse(maps[i]['dueDate']);
      String taskDate = "${dueDate.year}-${dueDate.month.toString().padLeft(2, '0')}-${dueDate.day.toString().padLeft(2, '0')}";

      if (taskDate == today) {
        return Task(
          id: maps[i]['id'],
          title: maps[i]['title'],
          subtitle: maps[i]['subtitle'],
          description: maps[i]['description'],
          userId: maps[i]['userId'],
          isCompleted: maps[i]['isCompleted'],
          dueDate: dueDate,
        );
      }
      return null;
    });

    return tasks.whereType<Task>().toList();
  }

  Future<List<Task>> fetchUpcomingTasksForUser(int? userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
        'task_info',
        where: 'userId = ? AND isCompleted = ?',
        whereArgs: [userId, 0]
    );

    DateTime now = DateTime.now();
    String today = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    List<Task?> tasks = List.generate(maps.length, (i) {
      DateTime dueDate = DateTime.parse(maps[i]['dueDate']);
      String taskDate = "${dueDate.year}-${dueDate.month.toString().padLeft(2, '0')}-${dueDate.day.toString().padLeft(2, '0')}";

      if (taskDate != today) {
        return Task(
          id: maps[i]['id'],
          title: maps[i]['title'],
          subtitle: maps[i]['subtitle'],
          description: maps[i]['description'],
          userId: maps[i]['userId'],
          isCompleted: maps[i]['isCompleted'],
          dueDate: dueDate,
        );
      }
      return null;
    });

    return tasks.whereType<Task>().toList();
  }



  Future<int> calculateCompletedTasksLen(int? userId) async {
    final db = await database;
    final List<Map<String, dynamic>> completedTasks = await db.rawQuery(
      'SELECT COUNT(*) AS count FROM task_info WHERE userId = ? AND isCompleted != 0',
      [userId],
    );

    final int? count = Sqflite.firstIntValue(completedTasks);
    return count ?? 0;
  }

  Future<int> calculateIncompleteTasksLen(int? userId) async {
    final db = await database;
    final currentDate = DateTime.now().toIso8601String().split('T')[0]; // Get current date in YYYY-MM-DD format
    final List<Map<String, dynamic>> incompleteTasks = await db.rawQuery(
      'SELECT COUNT(*) AS count FROM task_info WHERE userId = ? AND isCompleted == 0 AND DATE(dueDate) == ?',
      [userId, currentDate],
    );

    final int? count = Sqflite.firstIntValue(incompleteTasks);
    return count ?? 0;
  }

  Future<int> calculateUpcomingTasksLen(int? userId) async {
    final db = await database;
    final currentDate = DateTime.now().toIso8601String().split('T')[0]; // Get current date in YYYY-MM-DD format
    final List<Map<String, dynamic>> incompleteTasks = await db.rawQuery(
      'SELECT COUNT(*) AS count FROM task_info WHERE userId = ? AND isCompleted == 0 AND DATE(dueDate) != ?',
      [userId, currentDate],
    );

    final int? count = Sqflite.firstIntValue(incompleteTasks);
    return count ?? 0;
  }


  Future<List<Task>> fetchCompletedTasksForUser(int? userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'task_info',
      where: 'userId = ? AND isCompleted = ?',
      whereArgs: [userId, 1], // Replace 1 with the appropriate value for completed status
    );


    return List.generate(maps.length, (i) {
      return Task(
          id: maps[i]['id'],
          title: maps[i]['title'],
          subtitle: maps[i]['subtitle'],
          description: maps[i]['description'],
          userId: maps[i]['userId'],
          isCompleted: maps[i]['isCompleted'],
          dueDate: DateTime.parse(maps[i]['dueDate']),
      );
    });
  }


  // Future<List<UserInfo>> fetchUsers() async {
  //   final db = await database;
  //   final List<Map<String, dynamic>> usersMapList = await db.query('user_info');
  //
  //   List<UserInfo> users = [];
  //   for (var userMap in usersMapList) {
  //     final userId = userMap['id'];
  //     final List<Map<String, dynamic>> tasksMapList = await db.query(
  //       'tasks',
  //       where: 'user_id = ?',
  //       whereArgs: [userId],
  //     );
  //     List<Task> tasks = tasksMapList.map((taskMap) {
  //       return Task(
  //         title: taskMap['title'],
  //         subtitle: taskMap['subtitle'],
  //         description: taskMap['description'],
  //       );
  //     }).toList();
  //
  //     users.add(UserInfo(
  //       name: userMap['name'],
  //       email: userMap['email'],
  //       password: userMap['password'],
  //       age: userMap['age'],
  //       bio: userMap['bio'],
  //       interests: userMap['interests'],
  //       tasks: tasks,
  //     ));
  //   }
  //   return users;
  // }

  Future<UserInfo?> getUserInfo(int? userId) async {
    if (userId == null) return null;
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'user_info',
      where: 'id = ?',
      whereArgs: [userId],
    );

    if (maps.isNotEmpty) {
      return UserInfo(
        id: maps[0]['id'],
        name: maps[0]['name'],
        email: maps[0]['email'],
        password: maps[0]['password'],
        bio: maps[0]['bio'] ?? 'Not Added Yet',
        interests: maps[0]['interests'] ?? 'Not Added Yet',
        tasks: [], // You need to handle tasks separately if needed
      );
    } else {
      return null;
    }
  }

  Future<void> updateUserInfo(UserInfo userInfo) async {
    final db = await database;
    await db.update(
      'user_info',
      {
        'name': userInfo.name,
        'email': userInfo.email,
        'password': userInfo.password,
        'bio': userInfo.bio,
        'interests': userInfo.interests,
      },
      where: 'id = ?',
      whereArgs: [userInfo.id],
    );
  }

  Future<UserInfo?> checkUser(String email, String password) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'user_info',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (maps.isNotEmpty) {
      return UserInfo(
        id: maps[0]['id'],
        name: maps[0]['name'],
        email: maps[0]['email'],
        password: maps[0]['password'],
        age: maps[0]['age'],
        bio: maps[0]['bio'],
        interests: maps[0]['interests'],
        // completedTasks: maps[0]['completedTasks'],
        // incompleteTasks: maps[0]['incompleteTasks']
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

  Future<void> saveUserProfileImage(int? userId, Uint8List imageBytes) async {
    final db = await database;
    await db.update(
      'user_info',
      {'profileImage': imageBytes},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  Future<Uint8List?> getUserProfileImage(int? userId) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'user_info',
      columns: ['profileImage'],
      where: 'id = ?',
      whereArgs: [userId],
    );
    if (result.isNotEmpty) {
      return result.first['profileImage'];
    }
    return null;
  }
}
