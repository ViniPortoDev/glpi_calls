// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$HomeStore on HomeStoreBase, Store {
  late final _$ticketIdsAtom =
      Atom(name: 'HomeStoreBase.ticketIds', context: context);

  @override
  List<dynamic> get ticketIds {
    _$ticketIdsAtom.reportRead();
    return super.ticketIds;
  }

  @override
  set ticketIds(List<dynamic> value) {
    _$ticketIdsAtom.reportWrite(value, super.ticketIds, () {
      super.ticketIds = value;
    });
  }

  late final _$userAtom = Atom(name: 'HomeStoreBase.user', context: context);

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

  late final _$qtdTicketsAtom =
      Atom(name: 'HomeStoreBase.qtdTickets', context: context);

  @override
  int get qtdTickets {
    _$qtdTicketsAtom.reportRead();
    return super.qtdTickets;
  }

  @override
  set qtdTickets(int value) {
    _$qtdTicketsAtom.reportWrite(value, super.qtdTickets, () {
      super.qtdTickets = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: 'HomeStoreBase.isLoading', context: context);

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

  late final _$ticketMapAtom =
      Atom(name: 'HomeStoreBase.ticketMap', context: context);

  @override
  ObservableList<Map<int, List<Ticket>>> get ticketMap {
    _$ticketMapAtom.reportRead();
    return super.ticketMap;
  }

  @override
  set ticketMap(ObservableList<Map<int, List<Ticket>>> value) {
    _$ticketMapAtom.reportWrite(value, super.ticketMap, () {
      super.ticketMap = value;
    });
  }

  late final _$statusMessageAtom =
      Atom(name: 'HomeStoreBase.statusMessage', context: context);

  @override
  String get statusMessage {
    _$statusMessageAtom.reportRead();
    return super.statusMessage;
  }

  @override
  set statusMessage(String value) {
    _$statusMessageAtom.reportWrite(value, super.statusMessage, () {
      super.statusMessage = value;
    });
  }

  late final _$getIdsAsyncAction =
      AsyncAction('HomeStoreBase.getIds', context: context);

  @override
  Future<void> getIds() {
    return _$getIdsAsyncAction.run(() => super.getIds());
  }

  late final _$getTicketsAsyncAction =
      AsyncAction('HomeStoreBase.getTickets', context: context);

  @override
  Future<void> getTickets() {
    return _$getTicketsAsyncAction.run(() => super.getTickets());
  }

  late final _$getTickets2AsyncAction =
      AsyncAction('HomeStoreBase.getTickets2', context: context);

  @override
  Future<void> getTickets2() {
    return _$getTickets2AsyncAction.run(() => super.getTickets2());
  }

  late final _$setFirestoreUserAsyncAction =
      AsyncAction('HomeStoreBase.setFirestoreUser', context: context);

  @override
  Future<bool> setFirestoreUser(User user) {
    return _$setFirestoreUserAsyncAction
        .run(() => super.setFirestoreUser(user));
  }

  late final _$HomeStoreBaseActionController =
      ActionController(name: 'HomeStoreBase', context: context);

  @override
  Future<void> getTicketsByUser() {
    final _$actionInfo = _$HomeStoreBaseActionController.startAction(
        name: 'HomeStoreBase.getTicketsByUser');
    try {
      return super.getTicketsByUser();
    } finally {
      _$HomeStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
ticketIds: ${ticketIds},
user: ${user},
qtdTickets: ${qtdTickets},
isLoading: ${isLoading},
ticketMap: ${ticketMap},
statusMessage: ${statusMessage}
    ''';
  }
}
