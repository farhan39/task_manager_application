import 'package:flutter/material.dart';
import 'package:task_quill/Models/task_info.dart';
import 'package:task_quill/database/task_quillDB.dart';
import 'package:task_quill/pages/home_page.dart';
import 'package:task_quill/custom_widgets/responsive_fontSize.dart';
import 'package:task_quill/pages/signup_page.dart';
import 'package:task_quill/Models/user_info.dart';
import 'package:task_quill/shared_pref_utility.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.db});

  final TaskQuillDB db;
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Future<String> _login() async {
  //   try {
  //     final response = await http.post(
  //       Uri.parse('http://192.168.100.8:57263/login'), // Replace with your API endpoint
  //       body: {
  //         'email': _emailController.text,
  //         'password': _passwordController.text,
  //       },
  //     );
  //
  //     if (response.statusCode == 200) {
  //       // Handle successful login
  //       final data = json.decode(response.body); // This will contain the JSON response
  //       print(data);
  //
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (context) => const HomePage(title: 'Dashboard')),
  //       );
  //       // Return email and password as JSON object
  //       return '{"email": "${_emailController.text}", "password": "${_passwordController.text}"}';
  //     } else {
  //       // Handle login error
  //       print('Login failed: ${response.body}');
  //       return 'Login failed: ${response.body}';
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //     return 'Error: $e';
  //   }
  // }

  Future<void> _login() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    UserInfo? user = await widget.db.checkUser(email, password);
    user.toString();
    if (user != null) {
      SharedPreferencesUtil.saveUserId(user.getID());
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage(db: widget.db)),
      );
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Login failed: Invalid email or password')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.07,
              child: const FittedBox(
                  child: Text(
                'Welcome to TaskQuill',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
              )),
            ),
          ),
          Container(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.1,
              child: ResponsiveText(
                text: 'Manage your tasks with ease',
                fontSize: 24,
                color: Colors.black,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.05,
              left: MediaQuery.of(context).size.width * 0.07,
            ),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
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
            margin: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.04,
              right: MediaQuery.of(context).size.width * 0.04,
            ),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'iamhuman@example.com',
                  ),
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
            margin: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.04,
              right: MediaQuery.of(context).size.width * 0.04,
            ),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '',
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.04,
              left: MediaQuery.of(context).size.width * 0.04,
              right: MediaQuery.of(context).size.width * 0.04,
            ),
            width: MediaQuery.of(context).size.width * 0.85,
            height: MediaQuery.of(context).size.height * 0.1,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.black,
              ),
              child: TextButton(
                onPressed: _login,
                child: ResponsiveText(
                  text: 'Sign In',
                  fontSize: 22,
                  color: Colors.white,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.02,
              left: MediaQuery.of(context).size.width * 0.04,
              right: MediaQuery.of(context).size.width * 0.04,
            ),
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SignUpPage(db: widget.db)));
                },
                child: ResponsiveText(
                  text: 'Sign Up',
                  fontSize: 22,
                  color: Colors.black,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
