import 'package:app_glpi_ios/app/shared/utils/admin_token.dart';
import 'package:app_glpi_ios/app/shared/utils/custom_dio.dart';
import 'package:app_glpi_ios/app/shared/utils/firestore.dart';
import 'package:app_glpi_ios/app/shared/utils/logger.dart';
import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';
import '../../shared/models/user.dart';

part 'change_password_store.g.dart';

class ChangePasswordStore = ChangePasswordStoreBase with _$ChangePasswordStore;

abstract class ChangePasswordStoreBase with Store {
  @observable
  User? user;

  @observable
  bool isLoading = false;

  @action
  Future<bool> changePassword(String newPassword) async {
    isLoading = true;
    var adminToken = await getAdminToken();
    try {
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers['Session-Token'] = adminToken;
      Response response = await dio.put('/User/${user!.id}', data: {
        'input': {'password': newPassword, 'password2': newPassword}
      });
      killAdminSession(adminToken);
      if (response.statusCode == 200) {
        user!.passwordExpiresAt = DateTime.now().add(const Duration(days: 90));
        await updateFirebaseUser();
        isLoading = false;
        return true;
      }
      isLoading = false;
      return false;
    } on Exception catch (e) {
      isLoading = false;
      logger.e(e);
      return false;
    }
  }

  Future<void> updateFirebaseUser() async {
    try {
      var userDoc = await db.collection('users').doc(user!.id.toString()).get();
      if (userDoc.exists) {
        await userDoc.reference.update(
            {'passwordExpiresAt': user!.passwordExpiresAt!.toIso8601String()});
      }
    } catch (e) {
      logger.e('Error updating firebase user');
    }
  }
}
