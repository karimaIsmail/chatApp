import 'dart:convert';

import 'package:chatapp/core/databases/cache/cache_helper.dart';
import 'package:chatapp/core/errors/expentions.dart';
import 'package:chatapp/features/userAuth/data/models/userAuth_model.dart';

class CurrentUserLocalDataSource {
  final CacheHelper cache;
  final String key = "CachedUser";
  CurrentUserLocalDataSource({required this.cache});

  cacheUser(UserAuthModel? userToCache) {
    if (userToCache != null) {
      cache.saveData(
        key: key,
        value: json.encode(
          userToCache.toJson(),
        ),
      );
    } else {
      throw CacheExeption(message: "No Internet Connection");
    }
  }

  Future<UserAuthModel> getUser() {
    final jsonString = cache.getDataString(key: key);

    if (jsonString != null) {
      return Future.value(UserAuthModel.fromJson(json.decode(jsonString)));
    } else {
      throw CacheExeption(message: "No Internet Connection");
    }
  }
}
