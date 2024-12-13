import 'dart:convert';
import 'package:app_glpi_ios/app/modules/login/errors/credentials_failure.dart';
import 'package:app_glpi_ios/app/modules/login/errors/login_failure.dart';
import 'package:app_glpi_ios/app/shared/errors/failure.dart';
import 'package:app_glpi_ios/app/shared/models/profile.dart';
import 'package:app_glpi_ios/app/shared/models/user.dart';
import 'package:app_glpi_ios/app/shared/utils/custom_dio.dart';
import 'package:app_glpi_ios/app/shared/utils/firestore.dart';
import 'package:app_glpi_ios/app/shared/utils/logger.dart';
import 'package:dartz/dartz.dart';
//import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobx/mobx.dart';
import 'package:dio/dio.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'login_store.g.dart';

class LoginStore = LoginStoreBase with _$LoginStore;

abstract class LoginStoreBase with Store {
  @observable
  bool isLoading = false;

  @observable
  bool isLoggedIn = false;

  @observable
  bool isPasswordVisible = false;

  @observable
  String userBasicAuth = '';

  @observable
  User? user;

  late final SharedPreferences storage;

/*   Future<void> checkUser() async {
    var userString = await storage.read(key: 'user');
    if (userString != null) {
      user = User.fromJson2(jsonDecode(userString));
      Modular.to.pushReplacementNamed('/home', arguments: [user]);
    }
  } */

  @action
  Future<Either<Failure, String>> login(
      String username, String password) async {
    try {
      isLoading = true;

      String basicAuth =
          'Basic ${{base64Encode(utf8.encode('$username:$password'))}}';
      //print(basicAuth);
      userBasicAuth = basicAuth;
      dio.options.headers['Authorization'] = basicAuth;
      dio.options.headers['Content-Type'] = 'application/json';
      var response = await dio.post(
        '/initSession',
        queryParameters: {'get_full_session': 'true'},
      );
      //print(response.data);
      if (response.statusCode == 200) {
        user = User.fromJson(response.data['session']);
        // user!.isAprovadorContabil = await getContabilBool(user);
        user!.userBasicAuth = userBasicAuth;
        user!.sessionToken = response.data['session_token'];
        bool validPassword = await checkPasswordExpiration();
        if (!validPassword) {
          isLoading = false;
          return Left(CredentialsExpiredFailure());
        }
        dio.options.headers['Session-Token'] = response.data['session_token'];
        dio.options.headers['Authorization'] = null;
        await getMyProfiles(response.data['session']['glpiprofiles']);
        await storage.setString('user', jsonEncode(user!.toJson()));
        OneSignal.login(user!.id.toString());

        // if (user!.profiles!.where((element) => element.id == 6).isNotEmpty) {
        //   getCurrentLocation();
        // }
        setFirestoreUser(user!);
        storage.setString('password', password);
        isLoading = false;
        return Right(user!.sessionToken!);
      } else {
        isLoading = false;
        return Left(LoginFailure('Erro ao fazer login'));
      }
    } on DioException catch (e) {
      //print(e);
      isLoading = false;
      if (e.response != null && e.response!.statusCode == 401) {
        return Left(CredentialsFailure());
      } else {
        return Left(LoginFailure('Erro ao fazer login'));
      }
    } on Exception catch (e) {
      logger.e(e);
      isLoading = false;
      return Left(LoginFailure('Erro ao fazer login'));
    }
  }

  @action
  Future<bool> setFirestoreUser(User user) async {
    try {
      //print(user.toJson());

      var userData = user.toJson();
      var userDoc = await db.collection('users').doc(user.id.toString()).get();
      if (userDoc.exists) {
        await db.collection('users').doc(user.id.toString()).update(
          {
            'sessionToken': user.sessionToken,
            'glpiactiveprofile': user.type,
            'profiles': user.profiles!.map((x) => x.toJson()).toList(),
          },
        );
      } else {
        await db.collection('users').doc(user.id.toString()).set(userData);
      }
      return true;
    } catch (e) {
      //print(e);
      return false;
    }
  }

  Future<void> getMyProfiles(Map<String, dynamic> profileList) async {
    logger.i('getMyProfiles');
    logger.i(profileList);
    profileList.forEach((key, value) {
      logger.i(value);
      Profile myProfile = Profile.fromJson(value, int.parse(key));
      if (user!.profiles == null) {
        user!.profiles = [];
      }
      user!.profiles!.add(myProfile);
    });
  }

  Future<bool> checkPasswordExpiration() async {
    try {
      var userData =
          await db.collection('users').doc(user!.id.toString()).get();

      if (userData.exists) {
        updateUser(userData.data()!);
        if (userData.data()!['passwordExpiresAt'] == null ||
            userData.data()!['passwordExpiresAt'] == '') {
          return false;
        } else {
          user!.passwordExpiresAt =
              DateTime.parse(userData.data()!['passwordExpiresAt']);
          if (user!.passwordExpiresAt!.isBefore(DateTime.now())) {
            return false;
          } else {
            return true;
          }
        }
      }
      return true;
    } catch (e) {
      logger.e('Error checking password expiration');
      logger.e(e);
      return true;
    }
  }

  updateUser(userData) {
    var newUser = User.fromFirebaseData(userData);
    user!.profileImage = newUser.profileImage;
  }
  // Future<bool> getContabilBool (User user) async {
  //  DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await db.collection('user').doc(user.id.toString()).get();

  // }

  Future<void> instantiateSharedPreferences() async {
    storage = await SharedPreferences.getInstance();
  }
}
