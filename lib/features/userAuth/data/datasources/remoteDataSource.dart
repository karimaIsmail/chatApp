import 'package:chatapp/core/databases/firebase/firebaseConsumer/firebase_Auth_data.dart';
import 'package:chatapp/features/userAuth/data/models/userAuth_model.dart';

// import '../../../../core/databases/fireBase/firebaseConsumer/userAuthData.dart';

class FirebaseAuthDataSource {
  final FirebaseAutData firebase;

  FirebaseAuthDataSource({required this.firebase});

  Future<UserAuthModel> login(
      {required String email,
      required String password,
      required username}) async {
    final response = await firebase.login(
        email: email, password: password, username: username);
    return UserAuthModel.fromJson(response);
  }

  Future<bool> signInWithGoogle() async {
    final response = await firebase.signInWithGoogle();
    return response;
  }

  bool verifyEmail() {
    return firebase.verifyEmail();
  }

  Future<bool> signUp({required String email, required String password}) async {
    var response = await firebase.signUp(email: email, password: password);
    return response;
  }

  Future resetPassword({required String email}) async {
    await firebase.resetPassword(email: email);
  }

  Future signOut() async {
    await firebase.signOut();
  }
}
