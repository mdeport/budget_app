class UserModel {
  final String email;
  final String password;
  String? uid;

  UserModel({required this.email, required this.password, this.uid});

  set setUid(String uid) {
    this.uid = uid;
  }

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'email': email,
        'password': password,
      };
}
