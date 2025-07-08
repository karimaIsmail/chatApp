class UserAuthEntity {
  final String username;
  final String email;
  String? imagePath;

  UserAuthEntity({
    this.imagePath = "",
    required this.username,
    required this.email,
  });
}
