import 'package:chatapp/core/constants/routesNames.dart';
import 'package:chatapp/core/databases/cache/cache_helper.dart';
import 'package:chatapp/core/localization/local.dart';
import 'package:chatapp/core/localization/localController.dart';
import 'package:chatapp/features/userAuth/presentation/cubit/user_auth_cubit_cubit.dart';
import 'package:chatapp/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

// import 'package:intl/date_symbol_data_file.dart';

import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  CacheHelper().init();

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (context) => UserAuthCubit()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Get.put(MylocalController());

    return ScreenUtilInit(
        designSize: Size(375, 812),
        builder: (context, child) {
          return MultiProvider(
              providers: [
                ChangeNotifierProvider(
                  create: (_) => Model(),
                ),
                ChangeNotifierProvider(
                  create: (_) => UsersFilter(),
                )
              ],
              child: GetMaterialApp(
                debugShowCheckedModeBanner: false,
                initialRoute: FirebaseAuth.instance.currentUser != null &&
                        FirebaseAuth.instance.currentUser!.emailVerified
                    ? AppRouts.friendsListPage
                    : AppRouts.signupLoginPage,
                getPages: AppPages.pages,

                //locale: Get.deviceLocale,
                locale: Locale('en'),
                translations: MyLocal(),
              ));
        });
  }
}

class Model extends ChangeNotifier {
  String _category = '';
  String _userInfoId = '';
  String _username = '';
  String _currentUsername = '';
  String _currentUserEmail = '';
  int _pageNumber = 0;
  bool _imageChoosen = false;
  bool _showBottomSheet = false;

  String _imagePath = 'assets/defaultImage.jpg';
  // String? _imagePathcloud = '';

  String _language = '22'.tr;
  Uint8List? _netImage;
  String _selectedUsernetImage = '';

  Color _mainColor = Color.fromARGB(197, 121, 73, 194);

  Color _messageColor = Color.fromARGB(218, 238, 216, 251);
  bool _imageChanged = false;
  String _lastSeen = '';
  bool _online = false;
  bool _isChatListPage = true;

  get Category => _category;

  final List<Map<String, dynamic>> _messageContent = [];
  get PageNumber => _pageNumber;

  get UserInfoId => _userInfoId;
  get ImagePath => _imagePath;
  get ImageChanged => _imageChanged;
  get Username => _username;
  get CurrentUserEmail => _currentUserEmail;
  get CurrentUsername => _currentUsername;
  get MainColor => _mainColor;
  get MessageColor => _messageColor;
  get ImageChoosen => _imageChoosen;
  get ShowBottomSheet => _showBottomSheet;
  get Language => _language;

  get NetImage => _netImage;
  get SelectedUsernetImage => _selectedUsernetImage;
  get MessageContent => _messageContent;
  get LastSeen => _lastSeen;
  get Online => _online;
  get IsChatListPage => _isChatListPage;
  void Setcategory(String val) {
    _category = val;
    notifyListeners();
  }

  void UserInfoID(val) {
    _userInfoId = val;
    notifyListeners();
  }

  void SetUsername(val) {
    _username = val;
    // notifyListeners();
  }

  void SetImagePath(String val) {
    _imagePath = val;
    notifyListeners();
  }

  void SetSelectedUsernetImage(val) {
    _selectedUsernetImage = val;
    notifyListeners();
  }

  void SetUCurrentsername(val) {
    _currentUsername = val;
    notifyListeners();
  }

  void SetCurrentUserEmail(val) {
    _currentUserEmail = val;
    notifyListeners();
  }

  void SetMainColor(val) {
    _mainColor = val;
    notifyListeners();
  }

  void SetMessageColor(val) {
    _messageColor = val;
    notifyListeners();
  }

  void SetImageChoosen(val) {
    _imageChoosen = val;
    notifyListeners();
  }

  void SetPageNumber(val) {
    _pageNumber = val;
    notifyListeners();
  }

  void SetShowBottomSheet(val) {
    _showBottomSheet = val;
    notifyListeners();
  }

  void SetSLanguage(val) {
    _language = val;
    notifyListeners();
  }

  void SetNetImage(val) {
    _netImage = val;
    notifyListeners();
  }

  void SetImageChanged(val) {
    _imageChanged = val;
    notifyListeners();
  }

  void SetUserStatus(val) {
    _online = val;
    notifyListeners();
  }

  void SetLastSeen(val) {
    _lastSeen = val;
    notifyListeners();
  }

  void AddToMessages(String content, bool IsImage) {
    _messageContent.add({"content": content, "isimage": IsImage});
    notifyListeners();
  }

  void RemoveFromMessages(val) {
    _messageContent.remove(val);

    notifyListeners();
  }

  void clearMessageContents() {
    _messageContent.clear();
    notifyListeners();
  }

  void SetIsChatListPage(val) {
    _isChatListPage = val;
    notifyListeners();
  }
}

class UsersFilter extends ChangeNotifier {
  String _fiterText = '';

  get FilterText => _fiterText;

  void SetFilterText(val) {
    _fiterText = val;
    notifyListeners();
  }
}
