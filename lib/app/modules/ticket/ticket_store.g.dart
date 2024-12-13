// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$TicketStore on TicketStoreBase, Store {
  late final _$techListAtom =
      Atom(name: 'TicketStoreBase.techList', context: context);

  @override
  List<dynamic> get techList {
    _$techListAtom.reportRead();
    return super.techList;
  }

  @override
  set techList(List<dynamic> value) {
    _$techListAtom.reportWrite(value, super.techList, () {
      super.techList = value;
    });
  }

  late final _$selectedTechnicianAtom =
      Atom(name: 'TicketStoreBase.selectedTechnician', context: context);

  @override
  int get selectedTechnician {
    _$selectedTechnicianAtom.reportRead();
    return super.selectedTechnician;
  }

  @override
  set selectedTechnician(int value) {
    _$selectedTechnicianAtom.reportWrite(value, super.selectedTechnician, () {
      super.selectedTechnician = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: 'TicketStoreBase.isLoading', context: context);

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

  late final _$isSolucionarLoadingAtom =
      Atom(name: 'TicketStoreBase.isSolucionarLoading', context: context);

  @override
  bool get isSolucionarLoading {
    _$isSolucionarLoadingAtom.reportRead();
    return super.isSolucionarLoading;
  }

  @override
  set isSolucionarLoading(bool value) {
    _$isSolucionarLoadingAtom.reportWrite(value, super.isSolucionarLoading, () {
      super.isSolucionarLoading = value;
    });
  }

  late final _$isAtribuirLoadingAtom =
      Atom(name: 'TicketStoreBase.isAtribuirLoading', context: context);

  @override
  bool get isAtribuirLoading {
    _$isAtribuirLoadingAtom.reportRead();
    return super.isAtribuirLoading;
  }

  @override
  set isAtribuirLoading(bool value) {
    _$isAtribuirLoadingAtom.reportWrite(value, super.isAtribuirLoading, () {
      super.isAtribuirLoading = value;
    });
  }

  late final _$isLoadingDetailsAtom =
      Atom(name: 'TicketStoreBase.isLoadingDetails', context: context);

  @override
  bool get isLoadingDetails {
    _$isLoadingDetailsAtom.reportRead();
    return super.isLoadingDetails;
  }

  @override
  set isLoadingDetails(bool value) {
    _$isLoadingDetailsAtom.reportWrite(value, super.isLoadingDetails, () {
      super.isLoadingDetails = value;
    });
  }

  late final _$isTileLoadingAtom =
      Atom(name: 'TicketStoreBase.isTileLoading', context: context);

  @override
  bool get isTileLoading {
    _$isTileLoadingAtom.reportRead();
    return super.isTileLoading;
  }

  @override
  set isTileLoading(bool value) {
    _$isTileLoadingAtom.reportWrite(value, super.isTileLoading, () {
      super.isTileLoading = value;
    });
  }

  late final _$ticketAtom =
      Atom(name: 'TicketStoreBase.ticket', context: context);

  @override
  Ticket? get ticket {
    _$ticketAtom.reportRead();
    return super.ticket;
  }

  @override
  set ticket(Ticket? value) {
    _$ticketAtom.reportWrite(value, super.ticket, () {
      super.ticket = value;
    });
  }

  late final _$documentListAtom =
      Atom(name: 'TicketStoreBase.documentList', context: context);

  @override
  ObservableList<Document> get documentList {
    _$documentListAtom.reportRead();
    return super.documentList;
  }

  @override
  set documentList(ObservableList<Document> value) {
    _$documentListAtom.reportWrite(value, super.documentList, () {
      super.documentList = value;
    });
  }

  late final _$ticketDetailsAtom =
      Atom(name: 'TicketStoreBase.ticketDetails', context: context);

  @override
  ObservableList<dynamic> get ticketDetails {
    _$ticketDetailsAtom.reportRead();
    return super.ticketDetails;
  }

  @override
  set ticketDetails(ObservableList<dynamic> value) {
    _$ticketDetailsAtom.reportWrite(value, super.ticketDetails, () {
      super.ticketDetails = value;
    });
  }

  late final _$showDateFieldsAtom =
      Atom(name: 'TicketStoreBase.showDateFields', context: context);

  @override
  bool get showDateFields {
    _$showDateFieldsAtom.reportRead();
    return super.showDateFields;
  }

  @override
  set showDateFields(bool value) {
    _$showDateFieldsAtom.reportWrite(value, super.showDateFields, () {
      super.showDateFields = value;
    });
  }

  late final _$loadingMessageAtom =
      Atom(name: 'TicketStoreBase.loadingMessage', context: context);

  @override
  String get loadingMessage {
    _$loadingMessageAtom.reportRead();
    return super.loadingMessage;
  }

  @override
  set loadingMessage(String value) {
    _$loadingMessageAtom.reportWrite(value, super.loadingMessage, () {
      super.loadingMessage = value;
    });
  }

  late final _$dialogLoadingAtom =
      Atom(name: 'TicketStoreBase.dialogLoading', context: context);

  @override
  bool get dialogLoading {
    _$dialogLoadingAtom.reportRead();
    return super.dialogLoading;
  }

  @override
  set dialogLoading(bool value) {
    _$dialogLoadingAtom.reportWrite(value, super.dialogLoading, () {
      super.dialogLoading = value;
    });
  }

  late final _$getTicketDetailsAsyncAction =
      AsyncAction('TicketStoreBase.getTicketDetails', context: context);

  @override
  Future<void> getTicketDetails() {
    return _$getTicketDetailsAsyncAction.run(() => super.getTicketDetails());
  }

  late final _$getTicketDetailAsyncAction =
      AsyncAction('TicketStoreBase.getTicketDetail', context: context);

  @override
  Future<bool> getTicketDetail(int index, String url) {
    return _$getTicketDetailAsyncAction
        .run(() => super.getTicketDetail(index, url));
  }

  late final _$getDetailsAsyncAction =
      AsyncAction('TicketStoreBase.getDetails', context: context);

  @override
  Future<dynamic> getDetails(String url) {
    return _$getDetailsAsyncAction.run(() => super.getDetails(url));
  }

  late final _$validacaoTicketWithCommentAsyncAction = AsyncAction(
      'TicketStoreBase.validacaoTicketWithComment',
      context: context);

  @override
  Future<bool> validacaoTicketWithComment(int ticketId, String comment) {
    return _$validacaoTicketWithCommentAsyncAction
        .run(() => super.validacaoTicketWithComment(ticketId, comment));
  }

  late final _$addFollowupAsyncAction =
      AsyncAction('TicketStoreBase.addFollowup', context: context);

  @override
  Future<bool> addFollowup(int ticketId, String comment) {
    return _$addFollowupAsyncAction
        .run(() => super.addFollowup(ticketId, comment));
  }

  late final _$respondSolutionAsyncAction =
      AsyncAction('TicketStoreBase.respondSolution', context: context);

  @override
  Future<bool> respondSolution(int solutionId, int ticketId, bool approved) {
    return _$respondSolutionAsyncAction
        .run(() => super.respondSolution(solutionId, ticketId, approved));
  }

  late final _$editTicketTaskAsyncAction =
      AsyncAction('TicketStoreBase.editTicketTask', context: context);

  @override
  Future<bool> editTicketTask(int ticketId, int taskId, bool done) {
    return _$editTicketTaskAsyncAction
        .run(() => super.editTicketTask(ticketId, taskId, done));
  }

  late final _$creatTaskAsyncAction =
      AsyncAction('TicketStoreBase.creatTask', context: context);

  @override
  Future<bool> creatTask(
      int ticketId, String comment, String dateInicio, String dateFinal) {
    return _$creatTaskAsyncAction
        .run(() => super.creatTask(ticketId, comment, dateInicio, dateFinal));
  }

  late final _$closeTicketAsyncAction =
      AsyncAction('TicketStoreBase.closeTicket', context: context);

  @override
  Future<bool> closeTicket(int ticketId) {
    return _$closeTicketAsyncAction.run(() => super.closeTicket(ticketId));
  }

  late final _$backTicketAsyncAction =
      AsyncAction('TicketStoreBase.backTicket', context: context);

  @override
  Future<bool> backTicket(int ticketId) {
    return _$backTicketAsyncAction.run(() => super.backTicket(ticketId));
  }

  late final _$getAllTechniciansAsyncAction =
      AsyncAction('TicketStoreBase.getAllTechnicians', context: context);

  @override
  Future<bool> getAllTechnicians(
      {bool isAtribuir = false,
      bool isEscalar = false,
      bool isEngenharia = false,
      bool isAdm = false}) {
    return _$getAllTechniciansAsyncAction.run(() => super.getAllTechnicians(
        isAtribuir: isAtribuir,
        isEscalar: isEscalar,
        isEngenharia: isEngenharia,
        isAdm: isAdm));
  }

  late final _$assignTechAsyncAction =
      AsyncAction('TicketStoreBase.assignTech', context: context);

  @override
  Future<bool> assignTech(int ticketId, int techId) {
    return _$assignTechAsyncAction
        .run(() => super.assignTech(ticketId, techId));
  }

  late final _$changeTechnicianAsyncAction =
      AsyncAction('TicketStoreBase.changeTechnician', context: context);

  @override
  Future<bool> changeTechnician(int ticketId, int techId) {
    return _$changeTechnicianAsyncAction
        .run(() => super.changeTechnician(ticketId, techId));
  }

  @override
  String toString() {
    return '''
techList: ${techList},
selectedTechnician: ${selectedTechnician},
isLoading: ${isLoading},
isSolucionarLoading: ${isSolucionarLoading},
isAtribuirLoading: ${isAtribuirLoading},
isLoadingDetails: ${isLoadingDetails},
isTileLoading: ${isTileLoading},
ticket: ${ticket},
documentList: ${documentList},
ticketDetails: ${ticketDetails},
showDateFields: ${showDateFields},
loadingMessage: ${loadingMessage},
dialogLoading: ${dialogLoading}
    ''';
  }
}
