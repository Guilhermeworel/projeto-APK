class User {
  final String username;
  String passwordHash;
  String? email;

  User({
    required this.username,
    required this.passwordHash,
    this.email,
  });
}
