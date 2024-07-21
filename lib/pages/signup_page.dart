import 'package:flutter/material.dart';
import 'package:task_quill/database/task_quillDB.dart';
import 'package:task_quill/custom_widgets/responsive_fontSize.dart';
import 'package:task_quill/Models/user_info.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key, required this.db});

  final TaskQuillDB db;

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _insertUser() async {
    final name = _nameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;

    UserInfo user = UserInfo(
      name: name,
      email: email,
      password: password,
      age: null,
      bio: null,
      interests: null,
    );

    try {
      // Check if the email already exists
      bool emailExists = await widget.db.checkIfEmailExists(email);

      if (emailExists) {
        // If email exists, show a SnackBar and return
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User already exists!')),
          );
        }
        return;
      }

      // Insert the user if email does not exist
      await widget.db.insertUser(user);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User registered successfully!')),
        );
      }
    }
    catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }

    // try {
    //   final users = await widget.db.fetchUsers();
    //   for (var user in users) {
    //     print('User: ${user.name}, Email: ${user.email}');
    //   }
    // } catch (e) {
    //   print('Error fetching users: $e');
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.08,
              ),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.07,
                child: const FittedBox(
                  child: Text(
                    'TaskQuill',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                  ),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.1,
              child: ResponsiveText(
                text: 'Create your account',
                fontSize: 24,
                color: Colors.black,
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.03,
                left: MediaQuery.of(context).size.width * 0.07,
              ),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: ResponsiveText(
                  text: 'Name',
                  fontSize: 24,
                  color: Colors.black,
                  textAlign: TextAlign.left,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.04),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Your name',
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.01,
                left: MediaQuery.of(context).size.width * 0.07,
              ),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.05,
                child: ResponsiveText(
                  text: 'Email',
                  fontSize: 24,
                  color: Colors.black,
                  textAlign: TextAlign.left,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.04),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Your email',
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.01,
                left: MediaQuery.of(context).size.width * 0.07,
              ),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.05,
                child: ResponsiveText(
                  text: 'Password',
                  fontSize: 24,
                  color: Colors.black,
                  textAlign: TextAlign.left,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.04),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Your password',
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.03, horizontal: MediaQuery.of(context).size.width * 0.04),
              width: MediaQuery.of(context).size.width * 0.85,
              height: MediaQuery.of(context).size.height * 0.1,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.black,
                ),
                child: TextButton(
                  onPressed: _insertUser,
                  child: ResponsiveText(
                    text: 'Sign Up',
                    fontSize: 22,
                    color: Colors.white,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric( horizontal: MediaQuery.of(context).size.width * 0.04),
              width: MediaQuery.of(context).size.width * 0.85,
              height: MediaQuery.of(context).size.height * 0.1,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(color: Colors.black, width: 1.5),
                  color: Colors.white,
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: ResponsiveText(
                    text: 'Back to Login',
                    fontSize: 22,
                    color: Colors.black,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
