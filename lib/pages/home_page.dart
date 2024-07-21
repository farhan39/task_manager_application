import 'package:flutter/material.dart';
import 'package:task_quill/custom_widgets/home_task_display.dart';
import 'package:task_quill/pages/user_profile.dart';
import 'package:task_quill/custom_widgets/responsive_fontSize.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {

  Future<bool?> _showExitConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Exit App'),
          content: const Text('Are you sure you want to exit the app?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          final shouldExit = await _showExitConfirmationDialog(context);
          return shouldExit ?? false;
        },
        child: Scaffold(
        appBar: AppBar(
          title: ResponsiveText(
          text: 'TaskQuill',
          fontSize: 20,
          color: Colors.white
          ),

          toolbarHeight: 70,
          backgroundColor: Colors.black,
          leading: IconButton(
              icon: const Icon(Icons.timer, color: Colors.white),
              onPressed: () {
                // Handle menu button press
              }),
          actions: [
            IconButton(
                icon: const Icon(Icons.notifications,
                    color: Colors.white, size: 28),
                onPressed: () {
                  // Handle menu button press
                }),
            IconButton(
                icon: const Icon(Icons.account_circle_outlined,
                    color: Colors.white, size: 28),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute (builder: (context) {
                    return UserProfile();
                  }));
                  // Handle menu button press
                })
          ],
        ),
        body: SafeArea(
            child: ListView.builder(
            itemCount: 1, // Number of items in the list
            itemBuilder: (BuildContext context, int index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.05,
                          //right: MediaQuery.of(context).size.width * 0.05,
                          bottom: MediaQuery.of(context).size.height * 0.02,
                          top: MediaQuery.of(context).size.height * 0.03),
                      child: Row(
                        children: [
                          ResponsiveText(
                            text: 'Dashboard',
                            fontSize: 26,
                            color: Colors.black,
                            textAlign: TextAlign.left,
                            fontWeight: FontWeight.bold,
                          ),
                          const Spacer(),
                          Padding(
                            padding: EdgeInsets.only(
                                right: MediaQuery.of(context).size.width * 0.05),
                            child: OutlinedButton.icon(
                              onPressed: () {
                                // Add your desired functionality here
                              },
                              style: ButtonStyle(
                                  backgroundColor:
                                      WidgetStateProperty.all<Color>(
                                          Colors.black),
                                  foregroundColor:
                                      WidgetStateProperty.all<Color>(
                                          Colors.white)),
                              icon: Icon(Icons.add),
                              // Replace with your desired icon
                              label: ResponsiveText(
                              text: 'Add Task',
                              fontSize: 16,
                              color: Colors.white,
                              textAlign: TextAlign.left,
                            ),
                            ),
                          )
                        ],
                      )),
                  Container(
                    margin: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.05,
                        right: MediaQuery.of(context).size.width * 0.05,
                        bottom: MediaQuery.of(context).size.height * 0.02),
                    height: MediaQuery.of(context).size.height * 0.23,
                    decoration: BoxDecoration(
                      //color: Colors.red.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(10),
                      // Adjust the radius value as needed
                      border: Border.all(
                        color: Colors.black,
                        width: 1, // Adjust the width value as needed

                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(bottom: 4.0),
                            child: Icon(Icons.calendar_today_rounded,
                                // Example icon (you can use any icon from Icons class)
                                size: 45,
                                color: Colors.black),
                          ),
                          ResponsiveText(
                              text: '5',
                              fontSize: 36,
                              color: Colors.black,
                              fontWeight: FontWeight.bold
                          ),
                          ResponsiveText(
                              text: 'Tasks due today',
                              fontSize: 20,
                              color: Colors.black,
                              textAlign: TextAlign.left,
                              fontWeight: FontWeight.w400
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.05,
                        right: MediaQuery.of(context).size.width * 0.05,
                        bottom: MediaQuery.of(context).size.height * 0.02),
                    height: MediaQuery.of(context).size.height * 0.23,
                    decoration: BoxDecoration(
                      //color: Colors.green.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(10),
                      // Adjust the radius value as needed
                      border: Border.all(
                        color: Colors.black,
                        width: 1, // Adjust the width value as needed
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(bottom: 4.0),
                            child: Icon(
                              Icons.calendar_month_rounded,
                              // Example icon (you can use any icon from Icons class)
                              size: 50,
                              color: Colors.black,
                            ),
                          ),
                          ResponsiveText(
                              text: '12',
                              fontSize: 36,
                              color: Colors.black,
                              fontWeight: FontWeight.bold
                          ),
                          ResponsiveText(
                              text: 'Upcoming Tasks',
                              fontSize: 20,
                              color: Colors.black,
                              textAlign: TextAlign.left,
                              fontWeight: FontWeight.w400
                          ),
                        ],
                      ),
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.05,
                        right: MediaQuery.of(context).size.width * 0.05),
                    height: MediaQuery.of(context).size.height * 0.23,
                    decoration: BoxDecoration(
                        //color: Colors.blue.withOpacity(0.55),
                        borderRadius: BorderRadius.circular(10),
                        // Adjust the radius value as needed
                        border: Border.all(
                          color: Colors.black,
                          width: 1, // Adjust the width value as needed
                        )),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(bottom: 4.0),
                            child: Icon(
                              Icons.done,
                              // Example icon (you can use any icon from Icons class)
                              size: 50,
                              color: Colors.black,
                            ),
                          ),
                          ResponsiveText(
                              text: '20',
                              fontSize: 36,
                              color: Colors.black,
                              fontWeight: FontWeight.bold
                          ),
                          ResponsiveText(
                              text: 'Completed Tasks',
                              fontSize: 20,
                              color: Colors.black,
                              textAlign: TextAlign.left,
                              fontWeight: FontWeight.w400
                          ),
                        ],
                      ),
                    ),
                  ),

                  Container(
                      margin: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.06,
                          bottom: MediaQuery.of(context).size.height * 0.02,
                          top: MediaQuery.of(context).size.height * 0.04),
                      child: Row(
                        children: [
                          ResponsiveText(
                            text: 'Tasks',
                            fontSize: 30,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * 0.6),
                              child: const Icon(Icons.sort_rounded, size: 35)
                          )
                        ],
                      )),

                  Container(
                      margin: EdgeInsets.only(
                          //left: MediaQuery.of(context).size.width * 0.06,
                          bottom: MediaQuery.of(context).size.height * 0.02,
                          top: MediaQuery.of(context).size.height * 0.001),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ResponsiveText(
                            text: 'Today',
                            fontSize: 30,
                            color: Colors.black,
                            textAlign: TextAlign.center,
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      )),

                  HomeTaskDisplay(title: 'Dinner', description: 'Dinner pe jana he kal'),
                  HomeTaskDisplay(title: 'Home Task', description: 'Do homework tomorrow of mathematics'),

                  Container(
                      margin: EdgeInsets.only(
                          //left: MediaQuery.of(context).size.width * 0.06,
                          bottom: MediaQuery.of(context).size.height * 0.02,
                          top: MediaQuery.of(context).size.height * 0.001),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ResponsiveText(
                            text: 'Upcoming',
                            fontSize: 30,
                            color: Colors.black,
                            textAlign: TextAlign.left,
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      )
                  ),

                  HomeTaskDisplay(title: 'Football Match', description: 'College football in the oval-ground'),
                  HomeTaskDisplay(title: 'Museum Time', description: 'Go museum with Ali'),

                  Container(
                      margin: EdgeInsets.only(
                          //left: MediaQuery.of(context).size.width * 0.06,
                          bottom: MediaQuery.of(context).size.height * 0.02,
                          top: MediaQuery.of(context).size.height * 0.001),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ResponsiveText(
                            text: 'Completed',
                            fontSize: 30,
                            color: Colors.black,
                            textAlign: TextAlign.left,
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      )
                  ),

                  HomeTaskDisplay(title: 'Piano Time', description: 'Piano class with instructor', lineThrough: true,),
                  HomeTaskDisplay(title: 'Doctor Appointment', description: 'Checkup with doctor Javaid', lineThrough: true,),

                ],
              );
            }))));
  }
}
