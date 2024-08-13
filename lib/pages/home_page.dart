import 'package:flutter/material.dart';
import 'package:task_quill/Models/task_info.dart';
import 'package:task_quill/Models/user_info.dart';
import 'package:task_quill/custom_widgets/home_task_display.dart';
import 'package:task_quill/pages/login_page.dart';
import 'package:task_quill/pages/user_profile.dart';
import 'package:task_quill/custom_widgets/responsive_fontSize.dart';
import 'package:task_quill/database/task_quillDB.dart';
import 'package:task_quill/shared_pref_utility.dart';

class HomePage extends StatefulWidget {

  // Constructor with required parameter
  const HomePage({super.key, required this.db});

  final TaskQuillDB db;
  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {

  int? completedTasksLen;
  int? incompleteTasksLen;
  int? upcomingTasksLen;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    completedTasksLen = await widget.db.calculateCompletedTasksLen(await SharedPreferencesUtil.getUserId());
    incompleteTasksLen = await widget.db.calculateIncompleteTasksLen(await SharedPreferencesUtil.getUserId());
    upcomingTasksLen = await widget.db.calculateUpcomingTasksLen(await SharedPreferencesUtil.getUserId());

    setState(() {
      completedTasksLen = completedTasksLen;
      incompleteTasksLen = incompleteTasksLen;
      upcomingTasksLen = upcomingTasksLen;
    });
  }

  void calculateUpcomingTasksLen() async{
    upcomingTasksLen = await widget.db.calculateUpcomingTasksLen(await SharedPreferencesUtil.getUserId());
    setState(() {});
  }

  void calculateCompletedTasksLen() async{
    completedTasksLen = await widget.db.calculateCompletedTasksLen(await SharedPreferencesUtil.getUserId());
    setState(() {});
  }

  void calculateIncompleteTasksLen() async{
    incompleteTasksLen = await widget.db.calculateIncompleteTasksLen(await SharedPreferencesUtil.getUserId());
    setState(() {});
  }

  Future<List<Task>> _fetchUpcomingTasks() async {
    return await widget.db.fetchUpcomingTasksForUser(await SharedPreferencesUtil.getUserId());
  }

  Future<List<Task>> _fetchCompletedTasks() async {
    return await widget.db.fetchCompletedTasksForUser(await SharedPreferencesUtil.getUserId());
  }

  Future<List<Task>> _fetchIncompleteTasks() async {
    return await widget.db.fetchIncompleteTasksForUser(await SharedPreferencesUtil.getUserId());
  }

  Future<void> _updateTaskStatus(int taskId, bool? isCompleted) async {
    await widget.db.updateTaskStatus(taskId, isCompleted! ? 1 : 0);
    calculateCompletedTasksLen();
    calculateIncompleteTasksLen();
    calculateUpcomingTasksLen();
    setState(() {});
  }

  Future<void> _deleteIncompleteTask(int taskId) async {
    final userId = await SharedPreferencesUtil.getUserId();
    await widget.db.deleteCompletedTaskForUser(taskId, userId!);
    calculateIncompleteTasksLen();
  }

  Future<void> _deleteUpcomingTask(int taskId) async {
    final userId = await SharedPreferencesUtil.getUserId();
    await widget.db.deleteUpcomingTaskForUser(taskId, userId!);
    calculateUpcomingTasksLen();
  }

  Future<void> _deleteCompletedTask(int taskId) async {
    final userId = await SharedPreferencesUtil.getUserId();
    await widget.db.deleteIncompleteTaskForUser(taskId, userId!);
    calculateCompletedTasksLen();
  }

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

  Future<void> _showAddTaskDialog() async {
    final _titleController = TextEditingController();
    final _subtitleController = TextEditingController();
    final _descriptionController = TextEditingController();
    DateTime? _selectedDate;

    await showDialog<void>(
      context: context,
      builder: (context) {
        return Center( // Ensures the dialog is centered
          child: SingleChildScrollView(
            child: AlertDialog(
              title: const Text('Add Task'),
              content: Container(
                height: MediaQuery.of(context).size.height * 0.4, // Adjust height if needed
                width: MediaQuery.of(context).size.width * 0.8,  // Adjust width if needed
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(labelText: 'Title'),
                    ),
                    TextField(
                      controller: _subtitleController,
                      decoration: const InputDecoration(labelText: 'Subtitle'),
                    ),
                    TextField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(labelText: 'Description'),
                    ),
                    TextField(
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: _selectedDate == null ? 'Select Due Date' : _selectedDate!.toLocal().toString().split(' ')[0],
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () async {
                            final DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2101),
                            );
                            if (pickedDate != null && pickedDate != _selectedDate) {
                              setState(() {
                                _selectedDate = pickedDate;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    final title = _titleController.text;
                    final subtitle = _subtitleController.text;
                    final description = _descriptionController.text;

                    if (_selectedDate == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please select a due date')),
                      );
                      return;
                    }

                    Task newTask = Task(
                      title: title,
                      subtitle: subtitle,
                      description: description,
                      dueDate: _selectedDate!,
                      userId: await SharedPreferencesUtil.getUserId(),
                    );

                    await widget.db.insertTaskForUser(await SharedPreferencesUtil.getUserId(), newTask);
                    print("$newTask");
                    calculateIncompleteTasksLen();
                    calculateUpcomingTasksLen();
                    setState(() {}); // Refresh the UI to reflect the new task
                    Navigator.of(context).pop();
                  },
                  child: const Text('Add'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  Future<void> _showEditTaskDialog(Task task) async {
    final _titleController = TextEditingController(text: task.title);
    final _subtitleController = TextEditingController(text: task.subtitle);
    final _descriptionController = TextEditingController(text: task.description);
    DateTime? _selectedDate = task.dueDate;

    await showDialog<void>(
      context: context,
      builder: (context) {
        return Center(
          child: SingleChildScrollView(
            child: AlertDialog(
              title: const Text('Edit Task'),
              content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.4,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: _titleController,
                          decoration: const InputDecoration(labelText: 'Title'),
                        ),
                        TextField(
                          controller: _subtitleController,
                          decoration: const InputDecoration(labelText: 'Subtitle'),
                        ),
                        TextField(
                          controller: _descriptionController,
                          decoration: const InputDecoration(labelText: 'Description'),
                        ),
                        TextField(
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: _selectedDate == null
                                ? 'Select Due Date'
                                : _selectedDate!.toLocal().toString().split(' ')[0],
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.calendar_today),
                              onPressed: () async {
                                final DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: _selectedDate ?? DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2101),
                                );
                                if (pickedDate != null && pickedDate != _selectedDate) {
                                  setState(() {
                                    _selectedDate = pickedDate;
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    final title = _titleController.text;
                    final subtitle = _subtitleController.text;
                    final description = _descriptionController.text;

                    // Update the task with new values
                    Task updatedTask = Task(
                      id: task.id,
                      title: title,
                      subtitle: subtitle,
                      description: description,
                      userId: task.userId, // Assuming userId remains the same
                      isCompleted: task.isCompleted, // Preserve the completion status
                      dueDate: _selectedDate!, // Include the selected date
                    );

                    await widget.db.updateTaskForUser(updatedTask);
                    calculateUpcomingTasksLen();
                    calculateIncompleteTasksLen();
                    setState(() {}); // Refresh the UI to reflect the updated task
                    Navigator.of(context).pop();
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ),
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
          title: Text('TaskQuill'),
          toolbarHeight: 70,
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.timer, color: Colors.white),
            onPressed: () {
              // Handle menu button press
            },
          ),
          actions: [
            Builder(
              builder: (context) => IconButton(
                icon: Icon(Icons.account_circle, color: Colors.white, size: 28),
                highlightColor: Colors.orangeAccent,
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
              ),
            ),
          ],
        ),
        endDrawer: Builder(
          builder: (context) {
            // Calculate the width of the drawer as 0.5 of screen width
            final double drawerWidth = MediaQuery.of(context).size.width * 0.5;

            return Container(
              width: drawerWidth,
              child: Drawer(
                child: Column(
                  children: [
                    AppBar(
                      title: Text('Profile Options'),
                      automaticallyImplyLeading: false,
                      actions: [
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the drawer
                          },
                        ),
                      ],
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            ListTile(
                              leading: Icon(Icons.person),
                              title: Text('Check Profile'),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UserProfile(db: widget.db),
                                  ),
                                );
                              },
                            ),

                            ListTile(
                              leading: Icon(Icons.logout),
                              title: Text('Logout'),
                              onTap: () {
                                SharedPreferencesUtil.saveLoginStatus(false);
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => LoginPage(db: widget.db)),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),

        body: SafeArea(
          child: ListView.builder(
            itemCount: 1,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.05,
                      bottom: MediaQuery.of(context).size.height * 0.02,
                      top: MediaQuery.of(context).size.height * 0.03,
                    ),
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
                            right: MediaQuery.of(context).size.width * 0.05,
                          ),
                          child: OutlinedButton.icon(
                            onPressed: () {
                              _showAddTaskDialog();
                              //++incompleteTasksLen;
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                            ),
                            icon: const Icon(Icons.add),
                            label: ResponsiveText(
                              text: 'Add Task',
                              fontSize: 16,
                              color: Colors.white,
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.05,
                      right: MediaQuery.of(context).size.width * 0.05,
                      bottom: MediaQuery.of(context).size.height * 0.02,
                    ),
                    height: MediaQuery.of(context).size.height * 0.23,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.black,
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(bottom: 4.0),
                            child: Icon(
                              Icons.calendar_today_rounded,
                              size: 45,
                              color: Colors.black,
                            ),
                          ),
                          ResponsiveText(
                            text: incompleteTasksLen.toString(),
                            fontSize: 36,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          ResponsiveText(
                            text: 'Tasks due today',
                            fontSize: 20,
                            color: Colors.black,
                            textAlign: TextAlign.left,
                            fontWeight: FontWeight.w400,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.05,
                      right: MediaQuery.of(context).size.width * 0.05,
                      bottom: MediaQuery.of(context).size.height * 0.02,
                    ),
                    height: MediaQuery.of(context).size.height * 0.23,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.black,
                        width: 1,
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
                              size: 50,
                              color: Colors.black,
                            ),
                          ),
                          ResponsiveText(
                            text: upcomingTasksLen.toString(),
                            fontSize: 36,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          ResponsiveText(
                            text: 'Upcoming Tasks',
                            fontSize: 20,
                            color: Colors.black,
                            textAlign: TextAlign.left,
                            fontWeight: FontWeight.w400,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.05,
                      right: MediaQuery.of(context).size.width * 0.05,
                    ),
                    height: MediaQuery.of(context).size.height * 0.23,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.black,
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(bottom: 4.0),
                            child: Icon(
                              Icons.done,
                              size: 50,
                              color: Colors.black,
                            ),
                          ),
                          ResponsiveText(
                            text: completedTasksLen.toString(),
                            fontSize: 36,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          ResponsiveText(
                            text: 'Completed Tasks',
                            fontSize: 20,
                            color: Colors.black,
                            textAlign: TextAlign.left,
                            fontWeight: FontWeight.w400,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.06,
                      bottom: MediaQuery.of(context).size.height * 0.02,
                      top: MediaQuery.of(context).size.height * 0.04,
                    ),
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
                            left: MediaQuery.of(context).size.width * 0.6,
                          ),
                          child: const Icon(Icons.sort_rounded, size: 35),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      left: MediaQuery.of(context).size.height * 0.03,
                      bottom: MediaQuery.of(context).size.height * 0.02,
                      top: MediaQuery.of(context).size.height * 0.001,
                      right: MediaQuery.of(context).size.height * 0.03,
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.03, bottom: MediaQuery.of(context).size.height * 0.03, right: 15.0), // Adjust padding if needed
                          child: ResponsiveText(
                            text: 'Today',
                            fontSize: 30,
                            color: Colors.black,
                            textAlign: TextAlign.center,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 2, // Adjust the thickness of the line if needed
                            color: Colors.black, // Adjust the color of the line if needed
                          ),
                        ),
                      ],
                    ),
                  ),


                  FutureBuilder<List<Task>> (
                    future: _fetchIncompleteTasks(),
                    builder: (BuildContext context, AsyncSnapshot<List<Task>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: ResponsiveText(
                          text: 'No Tasks for Today',
                          fontSize: 24,
                          color: Colors.black,
                          textAlign: TextAlign.center,
                          fontWeight: FontWeight.w500,
                        ));
                      } else {
                        final tasks = snapshot.data!;
                        return Column(
                          children: tasks.map((task) => HomeTaskDisplay(
                            task: task,
                            onCheckboxChanged: (isChecked) {
                              _updateTaskStatus(task.id!, isChecked);
                              setState(() {});
                            },
                            onEditPressed: () {
                              _showEditTaskDialog(task);
                              setState(() {});// Show the edit dialog
                            },
                            onDeletePressed: () {
                              _deleteIncompleteTask(task.id!);
                              setState(() {});
                            },
                          )).toList(),
                        );
                      }
                    },
                  ),

                  Container(
                    margin: EdgeInsets.only(
                      left: MediaQuery.of(context).size.height * 0.03,
                      bottom: MediaQuery.of(context).size.height * 0.02,
                      top: MediaQuery.of(context).size.height * 0.001,
                      right: MediaQuery.of(context).size.height * 0.03,
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.03, bottom: MediaQuery.of(context).size.height * 0.03, right: 15.0), // Adjust padding if needed
                          child: ResponsiveText(
                            text: 'Upcoming',
                            fontSize: 30,
                            color: Colors.black,
                            textAlign: TextAlign.center,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 2, // Adjust the thickness of the line if needed
                            color: Colors.black, // Adjust the color of the line if needed
                          ),
                        ),
                      ],
                    ),
                  ),

                  FutureBuilder<List<Task>> (
                    future: _fetchUpcomingTasks(),
                    builder: (BuildContext context, AsyncSnapshot<List<Task>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: ResponsiveText(
                          text: 'No Upcoming Tasks',
                          fontSize: 24,
                          color: Colors.black,
                          textAlign: TextAlign.center,
                          fontWeight: FontWeight.w500,
                        ));
                      } else {
                        final tasks = snapshot.data!;
                        return Column(
                          children: tasks.map((task) => HomeTaskDisplay(
                            task: task,
                            onCheckboxChanged: (isChecked) {
                              _updateTaskStatus(task.id!, isChecked);
                              setState(() {});
                            },
                            onEditPressed: () {
                              _showEditTaskDialog(task); // Show the edit dialog
                              setState(() {});
                            },
                            onDeletePressed: () {
                              _deleteUpcomingTask(task.id!);
                              setState(() {});
                            },
                          )).toList(),
                        );
                      }
                    },
                  ),

                  Container(
                    margin: EdgeInsets.only(
                      left: MediaQuery.of(context).size.height * 0.03,
                      bottom: MediaQuery.of(context).size.height * 0.02,
                      top: MediaQuery.of(context).size.height * 0.001,
                      right: MediaQuery.of(context).size.height * 0.03,
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.03, bottom: MediaQuery.of(context).size.height * 0.03, right: 15.0), // Adjust padding if needed
                          child: ResponsiveText(
                            text: 'Completed',
                            fontSize: 30,
                            color: Colors.black,
                            textAlign: TextAlign.center,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 2, // Adjust the thickness of the line if needed
                            color: Colors.black, // Adjust the color of the line if needed
                          ),
                        ),
                      ],
                    ),
                  ),

                  FutureBuilder<List<Task>> (
                    future: _fetchCompletedTasks(),
                    builder: (BuildContext context, AsyncSnapshot<List<Task>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Container(
                          margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.03),
                          child: ResponsiveText(
                            text: 'No Completed Tasks',
                            fontSize: 24,
                            color: Colors.black,
                            textAlign: TextAlign.center,
                            fontWeight: FontWeight.w500,
                          ),
                        ));
                      } else {
                        final tasks = snapshot.data!;
                        return Column(
                          children: tasks.map((task) => HomeTaskDisplay(
                            task: task,
                            onCheckboxChanged: (isChecked) {
                            },
                            onEditPressed: () {
                            },
                            onDeletePressed: () {
                              _deleteCompletedTask(task.id!);
                              setState(() {});
                            },
                          )).toList(),
                        );
                      }
                    },
                  ),

                  Container(
                    margin: EdgeInsets.only(
                      left: MediaQuery.of(context).size.height * 0.03,
                      bottom: MediaQuery.of(context).size.height * 0.02,
                      top: MediaQuery.of(context).size.height * 0.02,
                      right: MediaQuery.of(context).size.height * 0.03,
                    ),
                    child: const Row(
                      children: [
                          Expanded(
                          child: Divider(
                            thickness: 5, // Adjust the thickness of the line if needed
                            color: Colors.black, // Adjust the color of the line if needed
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
