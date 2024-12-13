// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receipt_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ReceiptStore on ReceiptStoreBase, Store {
  late final _$isLoadingAtom =
      Atom(name: 'ReceiptStoreBase.isLoading', context: context);

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

  late final _$finishLoadingAtom =
      Atom(name: 'ReceiptStoreBase.finishLoading', context: context);

  @override
  bool get finishLoading {
    _$finishLoadingAtom.reportRead();
    return super.finishLoading;
  }

  @override
  set finishLoading(bool value) {
    _$finishLoadingAtom.reportWrite(value, super.finishLoading, () {
      super.finishLoading = value;
    });
  }

  late final _$selectedNFAtom =
      Atom(name: 'ReceiptStoreBase.selectedNF', context: context);

  @override
  File? get selectedNF {
    _$selectedNFAtom.reportRead();
    return super.selectedNF;
  }

  @override
  set selectedNF(File? value) {
    _$selectedNFAtom.reportWrite(value, super.selectedNF, () {
      super.selectedNF = value;
    });
  }

  late final _$selectedBoletoAtom =
      Atom(name: 'ReceiptStoreBase.selectedBoleto', context: context);

  @override
  File? get selectedBoleto {
    _$selectedBoletoAtom.reportRead();
    return super.selectedBoleto;
  }

  @override
  set selectedBoleto(File? value) {
    _$selectedBoletoAtom.reportWrite(value, super.selectedBoleto, () {
      super.selectedBoleto = value;
    });
  }

  late final _$selectedFileAtom =
      Atom(name: 'ReceiptStoreBase.selectedFile', context: context);

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

  late final _$notificationsIdsAtom =
      Atom(name: 'ReceiptStoreBase.notificationsIds', context: context);

  @override
  List<String> get notificationsIds {
    _$notificationsIdsAtom.reportRead();
    return super.notificationsIds;
  }

  @override
  set notificationsIds(List<String> value) {
    _$notificationsIdsAtom.reportWrite(value, super.notificationsIds, () {
      super.notificationsIds = value;
    });
  }

  late final _$userContailListIdsAtom =
      Atom(name: 'ReceiptStoreBase.userContailListIds', context: context);

  @override
  List<String> get userContailListIds {
    _$userContailListIdsAtom.reportRead();
    return super.userContailListIds;
  }

  @override
  set userContailListIds(List<String> value) {
    _$userContailListIdsAtom.reportWrite(value, super.userContailListIds, () {
      super.userContailListIds = value;
    });
  }

  late final _$pickImageAsyncAction =
      AsyncAction('ReceiptStoreBase.pickImage', context: context);

  @override
  Future<void> pickImage() {
    return _$pickImageAsyncAction.run(() => super.pickImage());
  }

  late final _$updateOrcamentoAsyncAction =
      AsyncAction('ReceiptStoreBase.updateOrcamento', context: context);

  @override
  Future<void> updateOrcamento(String documentId, String newStatus) {
    return _$updateOrcamentoAsyncAction
        .run(() => super.updateOrcamento(documentId, newStatus));
  }

  late final _$uploadDocsAsyncAction =
      AsyncAction('ReceiptStoreBase.uploadDocs', context: context);

  @override
  Future<void> uploadDocs(Orcamento orcamento) {
    return _$uploadDocsAsyncAction.run(() => super.uploadDocs(orcamento));
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
finishLoading: ${finishLoading},
selectedNF: ${selectedNF},
selectedBoleto: ${selectedBoleto},
selectedFile: ${selectedFile},
notificationsIds: ${notificationsIds},
userContailListIds: ${userContailListIds}
    ''';
  }
}
