import 'package:chatapp/core/databases/fireBase/fireBaseKeys.dart';
import 'package:chatapp/features/chat/domain/entities/friend_entitiy.dart';

class FriendModel extends FriendEntity {
  final String email;

  FriendModel({
    required super.category,
    required super.lastSeen,
    required super.onLine,
    required super.username,
    required this.email,
    super.imagePath,
    super.lastMessage,
  });

  factory FriendModel.fromJson(
    Map<String, dynamic> friend,
  ) {
    return FriendModel(
      username: friend[FirebaseKey.username],
      category: friend[FirebaseKey.category],
      email: friend[FirebaseKey.email],
      imagePath: friend[FirebaseKey.imagepath],
      onLine: friend[FirebaseKey.online],
      lastSeen: friend[FirebaseKey.lastneen],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      FirebaseKey.username: username,
      FirebaseKey.email: email,
      FirebaseKey.category: category,
      FirebaseKey.username: username,
      FirebaseKey.imagepath: imagePath,
      FirebaseKey.lastneen: lastSeen,
      FirebaseKey.online: onLine,
    };
  }
}
