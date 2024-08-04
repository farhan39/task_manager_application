import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_quill/Models/user_info.dart';
import 'package:task_quill/custom_widgets/responsive_fontSize.dart';
import 'package:task_quill/database/task_quillDB.dart';
import 'package:task_quill/shared_pref_utility.dart';

class UserProfile extends StatefulWidget {
  final TaskQuillDB db;

  UserProfile({required this.db});

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  Uint8List? _profileImage;
  UserInfo? _userInfo;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
    _loadUserInfo();
  }

  Future<void> _loadProfileImage() async {
    int? userId = await SharedPreferencesUtil.getUserId();
    final imageBytes = await widget.db.getUserProfileImage(userId);
    if (imageBytes != null) {
      setState(() {
        _profileImage = imageBytes;
      });
    }
  }

  Future<void> _loadUserInfo() async {
    int? userId = await SharedPreferencesUtil.getUserId();
    final userInfo = await widget.db.getUserInfo(userId);
    setState(() {
      _userInfo = userInfo;
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _profileImage = bytes;
      });
      int? userId = await SharedPreferencesUtil.getUserId();
      await widget.db.saveUserProfileImage(userId, bytes);
    }
  }

  Future<void> _showEditUserDialog() async {
    final _nameController = TextEditingController(text: _userInfo?.name);
    final _bioController = TextEditingController(text: _userInfo?.bio);
    final _emailController = TextEditingController(text: _userInfo?.email);
    final _passwordController = TextEditingController(text: _userInfo?.password);
    final _interestsController = TextEditingController(text: _userInfo?.interests);

    await showDialog<void>(
      context: context,
      builder: (context) {
        return Center(
          child: SingleChildScrollView(
            child: AlertDialog(
              title: const Text('Edit User Details'),
              content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.6,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: _nameController,
                          decoration: const InputDecoration(labelText: 'Name'),
                        ),
                        TextField(
                          controller: _bioController,
                          decoration: const InputDecoration(labelText: 'Bio'),
                        ),
                        TextField(
                          controller: _emailController,
                          decoration: const InputDecoration(labelText: 'Email'),
                        ),
                        TextField(
                          controller: _passwordController,
                          decoration: const InputDecoration(labelText: 'Password'),
                          obscureText: true,
                        ),
                        TextField(
                          controller: _interestsController,
                          decoration: const InputDecoration(labelText: 'Interests'),
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
                    final updatedUserInfo = UserInfo(
                      id: _userInfo?.id,
                      name: _nameController.text.isEmpty ? 'Not Added Yet' : _nameController.text,
                      email: _emailController.text.isEmpty ? 'Not Added Yet' : _emailController.text,
                      password: _passwordController.text.isEmpty ? 'Not Added Yet' : _passwordController.text,
                      age: _userInfo?.age,
                      bio: _bioController.text.isEmpty ? 'Not Added Yet' : _bioController.text,
                      interests: _interestsController.text.isEmpty ? 'Not Added Yet' : _interestsController.text,
                      tasks: _userInfo?.tasks ?? [],
                    );

                    await widget.db.updateUserInfo(updatedUserInfo);
                    _loadUserInfo();
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        toolbarHeight: MediaQuery.of(context).size.height * 0.07,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () {
            Navigator.of(context).maybePop();
          },
        ),
        title: ResponsiveText(
          text: 'Profile',
          fontSize: 26,
          color: Colors.white,
          textAlign: TextAlign.left,
          fontWeight: FontWeight.w400,
        ),
      ),
      body: ListView.builder(
        itemCount: 1,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                margin: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.02,
                  horizontal: MediaQuery.of(context).size.width * 0.02,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.02),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.07),
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundImage: _profileImage != null
                                  ? MemoryImage(_profileImage!)
                                  : const AssetImage('assets/images/insertImage.jpg') as ImageProvider,
                            ),
                            Positioned(
                              top: MediaQuery.of(context).size.height * 0.11,
                              bottom: 0,
                              child: IconButton(
                                icon: const Icon(Icons.camera_alt, color: Colors.white),
                                onPressed: _pickImage,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ResponsiveText(
                              text: _userInfo?.name ?? 'Not Added Yet',
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: ResponsiveText(
                                text: _userInfo?.bio ?? 'Not Added Yet',
                                fontSize: 20,
                                color: Colors.white70,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.01,
                  bottom: MediaQuery.of(context).size.height * 0.02,
                  right: MediaQuery.of(context).size.width * 0.02,
                  left: MediaQuery.of(context).size.width * 0.02,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * 0.02,
                    horizontal: MediaQuery.of(context).size.width * 0.07,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.83,
                        child: ResponsiveText(
                          text: 'Contact Information',
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.83,
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.03),
                              child: Icon(Icons.email, color: Colors.white),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: ResponsiveText(
                                text: _userInfo?.email ?? 'Not Added Yet',
                                fontSize: 20,
                                color: Colors.white70,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.83,
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.03),
                              child: Icon(Icons.password_rounded, color: Colors.white),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: ResponsiveText(
                                text: _userInfo?.password ?? 'Not Added Yet',
                                fontSize: 20,
                                color: Colors.white70,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.83,
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.03),
                              child: Icon(Icons.interests, color: Colors.white),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: ResponsiveText(
                                text: _userInfo?.interests ?? 'Not Added Yet',
                                fontSize: 20,
                                color: Colors.white70,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.07,
                  ),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: OutlinedButton(
                      onPressed: _showEditUserDialog,
                      child: ResponsiveText(
                        text: 'Edit Details',
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.height * 0.015,
                          horizontal: MediaQuery.of(context).size.width * 0.05,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
