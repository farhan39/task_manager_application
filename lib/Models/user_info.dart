class UserInfo {
  int? id;
  final String name;
  final String email;
  final String password;
  final int? age;
  final String? bio;
  final String? interests;

  UserInfo({required this.name, required this.email, required this.password, this.age, this.bio, this.interests});
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'age': age,
      'bio': bio,
      'interests': interests,
    };
  }
}