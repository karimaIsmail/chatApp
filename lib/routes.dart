import 'package:chatapp/core/constants/routesNames.dart';
import 'package:chatapp/features/chat/presentation/screens/editUserData.dart';
import 'package:chatapp/features/chat/presentation/screens/friendsList.dart';
// import 'package:chatapp/features/friends/presentation/screens/friendsList.dart';
import 'package:chatapp/features/userAuth/presentation/screens/login_Signup.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

class AppPages {
  static final pages = [
    GetPage(name: AppRouts.signupLoginPage, page: () => LoginSignUp()),
    GetPage(name: AppRouts.friendsListPage, page: () => FriendsList()),
    GetPage(name: AppRouts.editUPage, page: () => EditUserData()),
  ];
}
