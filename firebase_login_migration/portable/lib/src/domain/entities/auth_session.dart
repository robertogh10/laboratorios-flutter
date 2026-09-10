class AuthSession {
  const AuthSession({
    required this.uid,
    required this.email,
    required this.isAdmin,
  });

  final String uid;
  final String email;
  final bool isAdmin;
}
