import 'dart:convert';
import 'dart:io';


import 'package:app_glpi_ios/app/shared/models/user.dart';
import 'package:app_glpi_ios/app/shared/utils/firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../shared/utils/logger.dart';
import '../../shared/utils/storage.dart';

part 'profile_store.g.dart';

class ProfileStore = _ProfileStoreBase with _$ProfileStore;

abstract class _ProfileStoreBase with Store {
  @observable
  User? user;

  File? userProfileImage;

 late final SharedPreferences storage;

  instantiateSharedPreferences() async {
    storage = await SharedPreferences.getInstance();
  }

  @observable
  bool isLoadingImage = false;

  @action
  Future<void> pickImage(BuildContext context) async {
    try {
      await ImagePicker()
          .pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
      )
          .then((pickedFile) {
        if (pickedFile != null) {
          userProfileImage = File(pickedFile.path);
          _cropImage(context);
        }
      });
    } catch (e) {
      logger.e(e);
    }
  }

  @action
  Future<void> _cropImage(BuildContext context) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: userProfileImage!.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 50,
        maxWidth: 350,
        maxHeight: 350,
        // cropStyle: CropStyle.circle,
        compressFormat: ImageCompressFormat.jpg,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Editar Imagem',
            toolbarColor: Colors.blue,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
          IOSUiSettings(
            title: 'Editar Imagem',
          ),
        ]);
    if (croppedFile != null) {
      userProfileImage = File(croppedFile.path);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Imagem cortada'),
            content: Image.file(
              userProfileImage!,
              height: 200,
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Modular.to.pop();
                },
                child: Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  _uploadImage();
                  Modular.to.pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @action
  Future<void> _uploadImage() async {
    if (userProfileImage != null) {
      String fileName = user!.name;

      final usersRef = firebaseStorage.ref().child('users');

      try {
        isLoadingImage = true;

        await usersRef.child(fileName).putFile(userProfileImage!).then((p0) => {
              p0.ref.getDownloadURL().then((url) => {
                    user!.profileImage = url,
                    updateUserImageLocalStorage(),
                    updateUserFirestore(),
                  }),
            });
      } catch (e) {
        logger.e(e);
      } finally {
        isLoadingImage = false;
      }
    }
  }
  


  @action
  Future<void> updateUserFirestore() async {
    try {
      var userDoc = await db.collection('users').doc(user!.id.toString()).get();
      if (userDoc.exists) {
        await db.collection('users').doc(user!.id.toString()).update(
          {
            'profileImage': user!.profileImage,
          },
        );
      }
    } catch (e) {
      //print(e);
    }
  }

  Future<void> updateUserImageLocalStorage() async {
    await storage.setString( 'user', jsonEncode(user!.toJson()));
  }

}
