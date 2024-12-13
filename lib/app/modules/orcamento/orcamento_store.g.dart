// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'orcamento_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$OrcamentoStore on OrcamentoStoreBase, Store {
  late final _$isLoadingAtom =
      Atom(name: 'OrcamentoStoreBase.isLoading', context: context);

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

  late final _$isContabilUserAtom =
      Atom(name: 'OrcamentoStoreBase.isContabilUser', context: context);

  @override
  bool get isContabilUser {
    _$isContabilUserAtom.reportRead();
    return super.isContabilUser;
  }

  @override
  set isContabilUser(bool value) {
    _$isContabilUserAtom.reportWrite(value, super.isContabilUser, () {
      super.isContabilUser = value;
    });
  }

  late final _$notificationsIdsAtom =
      Atom(name: 'OrcamentoStoreBase.notificationsIds', context: context);

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

  late final _$orcamentoListAtom =
      Atom(name: 'OrcamentoStoreBase.orcamentoList', context: context);

  @override
  ObservableList<Orcamento> get orcamentoList {
    _$orcamentoListAtom.reportRead();
    return super.orcamentoList;
  }

  @override
  set orcamentoList(ObservableList<Orcamento> value) {
    _$orcamentoListAtom.reportWrite(value, super.orcamentoList, () {
      super.orcamentoList = value;
    });
  }

  late final _$getOrcamentosAsyncAction =
      AsyncAction('OrcamentoStoreBase.getOrcamentos', context: context);

  @override
  Future<void> getOrcamentos(User user) {
    return _$getOrcamentosAsyncAction.run(() => super.getOrcamentos(user));
  }

  late final _$updateOrcamentoAsyncAction =
      AsyncAction('OrcamentoStoreBase.updateOrcamento', context: context);

  @override
  Future<void> updateOrcamento(String documentId, String newStatus) {
    return _$updateOrcamentoAsyncAction
        .run(() => super.updateOrcamento(documentId, newStatus));
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
isContabilUser: ${isContabilUser},
notificationsIds: ${notificationsIds},
orcamentoList: ${orcamentoList}
    ''';
  }
}
