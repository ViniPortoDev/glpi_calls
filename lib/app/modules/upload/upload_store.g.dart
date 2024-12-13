// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$UploadStore on UploadStoreBase, Store {
  late final _$sessionTokenAtom =
      Atom(name: 'UploadStoreBase.sessionToken', context: context);

  @override
  String get sessionToken {
    _$sessionTokenAtom.reportRead();
    return super.sessionToken;
  }

  @override
  set sessionToken(String value) {
    _$sessionTokenAtom.reportWrite(value, super.sessionToken, () {
      super.sessionToken = value;
    });
  }

  late final _$selectedFileAtom =
      Atom(name: 'UploadStoreBase.selectedFile', context: context);

  @override
  File? get selectedFile {
    _$selectedFileAtom.reportRead();
    return super.selectedFile;
  }

  @override
  set selectedFile(File? value) {
    _$selectedFileAtom.reportWrite(value, super.selectedFile, () {
      super.selectedFile = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: 'UploadStoreBase.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$uploadTicketAsyncAction =
      AsyncAction('UploadStoreBase.uploadTicket', context: context);

  @override
  Future<bool> uploadTicket(int ticketId, File? file) {
    return _$uploadTicketAsyncAction
        .run(() => super.uploadTicket(ticketId, file));
  }

  @override
  String toString() {
    return '''
sessionToken: ${sessionToken},
selectedFile: ${selectedFile},
isLoading: ${isLoading}
    ''';
  }
}
