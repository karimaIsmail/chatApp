import 'dart:convert';

import 'package:chatapp/core/databases/fireBase/fireBaseKeys.dart';
import 'package:chatapp/features/userAuth/domain/entities/user_entitiy.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class UserAuthModel extends UserAuthEntity {
  final String category;
  // final String lastSeen;
  final bool onLine;

  UserAuthModel(
      {required this.category,
      required this.onLine,
      required super.username,
      required super.email,
      super.imagePath});

  factory UserAuthModel.fromJson(Map<String, dynamic> json) {
    return UserAuthModel(
      username: json[FirebaseKey.username],
      category: json[FirebaseKey.category],
      email: json[FirebaseKey.email],
      imagePath: json[FirebaseKey.imagepath],
      onLine: json[FirebaseKey.online],
      // lastSeen: DateFormat('yyyy-MM-dd  hh:mm a')
      //     .format(json[FirebaseKey.lastneen].toDate()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      FirebaseKey.username: username,
      FirebaseKey.email: email,
      FirebaseKey.category: category,
      FirebaseKey.username: username,
      FirebaseKey.imagepath: imagePath,
      // FirebaseKey.lastneen: Timestamp.fromDate(DateTime.parse(lastSeen)),
      FirebaseKey.online: onLine,
    };
  }
}
