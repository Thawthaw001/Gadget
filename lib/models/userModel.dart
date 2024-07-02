class UserModel {
  final String uid;
  final String username;
  final String email;
  final String loginMethod;
  final DateTime? createdAt;
  final DateTime? lastLogin;
  UserModel(
      {required this.uid,
      required this.username,
      required this.email,
      required this.loginMethod,
      required this.createdAt,
      required this.lastLogin});
}
