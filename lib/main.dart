import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_quill/pages/login_page.dart';
import 'package:task_quill/pages/home_page.dart'; // Import your HomePage
import 'package:task_quill/database/task_quillDB.dart';
import 'package:task_quill/shared_pref_utility.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final TaskQuillDB db = TaskQuillDB();

  //await TaskQuillDB.deleteDatabase1();

  bool loginStatus = await SharedPreferencesUtil.loginStatus; // Fetch login status from SharedPreferences
  runApp(MyApp(db: db, loginStatus: loginStatus));
}

class MyApp extends StatelessWidget {
  MyApp({super.key, required this.db, required this.loginStatus});

  final TaskQuillDB db;
  final bool loginStatus;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaskQuill',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.montserratTextTheme(
          Theme.of(context).textTheme,
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      home: loginStatus ? HomePage(db: db) : LoginPage(db: db), // Redirect based on login status
    );
  }
}
