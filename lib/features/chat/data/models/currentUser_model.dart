import 'package:chatapp/core/databases/fireBase/fireBaseKeys.dart';
import 'package:chatapp/features/chat/domain/entities/currentuser_entity.dart';

class CurrentUserModel extends CurrentUserEntity {
  CurrentUserModel({
    required super.username,
    required super.email,
    super.imagePath,
  });

  factory CurrentUserModel.fromJson(
    Map<String, dynamic> friend,
  ) {
    return CurrentUserModel(
      username: friend[FirebaseKey.username],
      email: friend[FirebaseKey.email],
      imagePath: friend[FirebaseKey.imagepath],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      FirebaseKey.username: username,
      FirebaseKey.email: email,
      FirebaseKey.username: username,
      FirebaseKey.imagepath: imagePath,
    };
  }
}
