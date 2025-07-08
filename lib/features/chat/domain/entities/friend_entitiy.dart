class FriendEntity {
  final String username;
  final String? lastMessage;
  final String category;
  final String lastSeen;

  final bool onLine;
  String? imagePath;

  FriendEntity({
    this.lastMessage,
    this.imagePath = "",
    required this.username,
    required this.category,
    required this.lastSeen,
    required this.onLine,
  });
}
