import 'package:task_quill/Models/task_info.dart';

class UserInfo {
  int? id;
  // int? completedTasks;
  // int? incompleteTasks;
  final String name;
  final String email;
  final String password;
  final int? age;
  final String? bio;
  final String? interests;
  final List<Task> tasks; // Adding tasks array

  UserInfo({
    // this.completedTasks = 0,
    // this.incompleteTasks = 0,
    this.id,
    required this.name,
    required this.email,
    required this.password,
    this.age,
    this.bio,
    this.interests,
    this.tasks = const [], // Initialize tasks with an empty list
  });

  // void setCompletedTasks (int? value) async{
  //   completedTasks = value;
  // }
  //
  // void setIncompleteTasks (int? value) async{
  //   incompleteTasks = value;
  // }

  int getID() {
    return id!;
  }

  void setID(int ID) {
    id = ID;
  }

  String toString() {
    return 'UserInfo{id: $id}';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'age': age,
      'bio': bio,
      'interests': interests,
      // 'completedTasks': completedTasks,
      // 'incompleteTasks': incompleteTasks
    };
  }
}