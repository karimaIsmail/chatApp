import 'package:chatapp/core/databases/fireBase/fireBaseKeys.dart';
import 'package:chatapp/core/errors/expentions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAutData {
  UserCredential? credential;
  final auth = FirebaseAuth.instance;
  Future signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      try {
        await FirebaseAuth.instance.signInWithCredential(credential);
        return true;
      } on FirebaseException catch (e) {
        handleFirebaseException(e);
      } on PlatformException catch (e) {
        handleFirebaseException(e);
      }
    }
  }

  Future login(
      {required String email,
      required String password,
      required String username}) async {
    try {
      credential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      CollectionReference usersInfo =
          FirebaseFirestore.instance.collection(FirebaseKey.usersinfo);
      //check if there is login user

      if (auth.currentUser != null) {
        DocumentReference userDocRef = usersInfo.doc(auth.currentUser!.uid);
        DocumentSnapshot userDoc = await userDocRef.get();
        //check if Current user exists in database

        if (!userDoc.exists) {
          await _addNewUser(username: username, usersInfo: usersInfo);
          userDoc = await userDocRef.get();
        }

        return userDoc.data() as Map<String, dynamic>;
      }
    } on FirebaseException catch (e) {
      handleFirebaseException(e);
    } on PlatformException catch (e) {
      handleFirebaseException(e);
    }
  }

  Future _addNewUser(
      {required String username,
      required CollectionReference usersInfo}) async {
    //add user info
    await usersInfo.doc(auth.currentUser!.uid).set({
      FirebaseKey.email: auth.currentUser!.email,
      FirebaseKey.username: username,
      FirebaseKey.id: auth.currentUser!.uid,
      FirebaseKey.category: "normal",
      FirebaseKey.imagepath: "",
      FirebaseKey.online: false,
      FirebaseKey.lastneen: DateTime.now().toIso8601String(),
    });
  }

  verifyEmail() {
    return credential != null ? credential!.user!.emailVerified : false;
  }

  Future signUp({required String email, required String password}) async {
    try {
      credential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      auth.currentUser!.sendEmailVerification();
      return true;
    } on FirebaseException catch (e) {
      handleFirebaseException(e);
    } on PlatformException catch (e) {
      handleFirebaseException(e);
    }
  }

  Future resetPassword({required String email}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseException catch (e) {
      handleFirebaseException(e);
    } on PlatformException catch (e) {
      handleFirebaseException(e);
    }
  }

  Future signOut() async {
    try {
      GoogleSignIn googleSignIn = GoogleSignIn();
      googleSignIn.disconnect();

      await FirebaseAuth.instance.signOut();
      return true;
    } on FirebaseException catch (e) {
      handleFirebaseException(e);
    } on PlatformException catch (e) {
      handleFirebaseException(e);
    }
  }
}
