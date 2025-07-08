import 'dart:typed_data';

import 'package:chatapp/core/databases/firebase/firebaseConsumer/firebase_firestore_data.dart';
import 'package:chatapp/core/databases/imageData/image_bytes.dart';
import 'package:chatapp/features/userAuth/data/models/userAuth_model.dart';

class CurrentUserReoteDataSource {
  final Userdata userData;

  final ImageBytes _imageBytes = ImageBytes();
  CurrentUserReoteDataSource({required this.userData});

  Future<UserAuthModel> updateUserName({required String userName}) async {
    await userData.updateUsername(userName);
    // await firebaseAutData.updateImage(imageUrl);

    final rsponse = await userData.getCurrentUser();
    return UserAuthModel.fromJson(rsponse);
  }

  Future<UserAuthModel> updateImage({required String imageUrl}) async {
    await userData.updateImage(imageUrl);

    final rsponse = await userData.getCurrentUser();
    return UserAuthModel.fromJson(rsponse);
  }

  Future<Uint8List?> imageBytesConvert(String url) async {
    final response = await _imageBytes.imageBytes(url);
    return response;
  }
}
