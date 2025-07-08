import 'package:chatapp/core/databases/fireBase/fireBaseKeys.dart';
import 'package:chatapp/core/errors/expentions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class FirebaseFirestoreData {
  final auth = FirebaseAuth.instance;

  Future getCurrentUser() async {
    try {
      CollectionReference usersInfo =
          FirebaseFirestore.instance.collection(FirebaseKey.usersinfo);
      //check if there is login user

      if (auth.currentUser != null) {
        DocumentReference userDocRef = usersInfo.doc(auth.currentUser!.uid);
        DocumentSnapshot userDoc = await userDocRef.get();

        return await userDocRef.get() as Map<String, dynamic>;
      }
    } on FirebaseException catch (e) {
      handleFirebaseException(e);
    } on PlatformException catch (e) {
      handleFirebaseException(e);
    }
  }

  Future<void> updateUsername(String userName) async {
    try {
      await FirebaseFirestore.instance
          .collection(FirebaseKey.usersinfo)
          .doc(auth.currentUser!.uid)
          .update({
        FirebaseKey.username: userName,
      });
    } on FirebaseException catch (e) {
      handleFirebaseException(e);
    } on PlatformException catch (e) {
      handleFirebaseException(e);
    }
  }

  Future<void> updatUserImage(String ImageUrl) async {
    try {
      // await FirebaseFirestore.instance
      await FirebaseFirestore.instance
          .collection(FirebaseKey.usersinfo)
          .doc(auth.currentUser!.uid)
          .update({
        FirebaseKey.imagepath: ImageUrl,
      });
    } on FirebaseException catch (e) {
      handleFirebaseException(e);
    } on PlatformException catch (e) {
      handleFirebaseException(e);
    }
  }
  
}
