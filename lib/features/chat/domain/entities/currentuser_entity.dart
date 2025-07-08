class CurrentUserEntity {
  final String username;
  final String email;
  String? imagePath;

  CurrentUserEntity({
    this.imagePath = "",
    required this.username,
    required this.email,
  });
  CurrentUserEntity copyWith(String? image, String? name, String? email) {
    return CurrentUserEntity(
        username: name ?? username,
        email: email ?? this.email,
        imagePath: image ?? imagePath);
  }
}
