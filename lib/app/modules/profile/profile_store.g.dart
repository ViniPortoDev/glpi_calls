// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ProfileStore on _ProfileStoreBase, Store {
  late final _$userAtom =
      Atom(name: '_ProfileStoreBase.user', context: context);

  @override
  User? get user {
    _$userAtom.reportRead();
    return super.user;
  }

  @override
  set user(User? value) {
    _$userAtom.reportWrite(value, super.user, () {
      super.user = value;
    });
  }

  late final _$isLoadingImageAtom =
      Atom(name: '_ProfileStoreBase.isLoadingImage', context: context);

  @override
  bool get isLoadingImage {
    _$isLoadingImageAtom.reportRead();
    return super.isLoadingImage;
  }

  @override
  set isLoadingImage(bool value) {
    _$isLoadingImageAtom.reportWrite(value, super.isLoadingImage, () {
      super.isLoadingImage = value;
    });
  }

  late final _$pickImageAsyncAction =
      AsyncAction('_ProfileStoreBase.pickImage', context: context);

  @override
  Future<void> pickImage(BuildContext context) {
    return _$pickImageAsyncAction.run(() => super.pickImage(context));
  }

  late final _$_cropImageAsyncAction =
      AsyncAction('_ProfileStoreBase._cropImage', context: context);

  @override
  Future<void> _cropImage(BuildContext context) {
    return _$_cropImageAsyncAction.run(() => super._cropImage(context));
  }

  late final _$_uploadImageAsyncAction =
      AsyncAction('_ProfileStoreBase._uploadImage', context: context);

  @override
  Future<void> _uploadImage() {
    return _$_uploadImageAsyncAction.run(() => super._uploadImage());
  }

  late final _$updateUserFirestoreAsyncAction =
      AsyncAction('_ProfileStoreBase.updateUserFirestore', context: context);

  @override
  Future<void> updateUserFirestore() {
    return _$updateUserFirestoreAsyncAction
        .run(() => super.updateUserFirestore());
  }

  @override
  String toString() {
    return '''
user: ${user},
isLoadingImage: ${isLoadingImage}
    ''';
  }
}
