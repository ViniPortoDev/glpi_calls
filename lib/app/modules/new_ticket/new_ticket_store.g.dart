// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'new_ticket_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$NewTicketStore on NewTicketStoreBase, Store {
  late final _$isLoadingAtom =
      Atom(name: 'NewTicketStoreBase.isLoading', context: context);

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

  late final _$categoriaSelecionadaAtom =
      Atom(name: 'NewTicketStoreBase.categoriaSelecionada', context: context);

  @override
  int? get categoriaSelecionada {
    _$categoriaSelecionadaAtom.reportRead();
    return super.categoriaSelecionada;
  }

  @override
  set categoriaSelecionada(int? value) {
    _$categoriaSelecionadaAtom.reportWrite(value, super.categoriaSelecionada,
        () {
      super.categoriaSelecionada = value;
    });
  }

  late final _$tipoSelecionadaAtom =
      Atom(name: 'NewTicketStoreBase.tipoSelecionada', context: context);

  @override
  int? get tipoSelecionada {
    _$tipoSelecionadaAtom.reportRead();
    return super.tipoSelecionada;
  }

  @override
  set tipoSelecionada(int? value) {
    _$tipoSelecionadaAtom.reportWrite(value, super.tipoSelecionada, () {
      super.tipoSelecionada = value;
    });
  }

  late final _$urgenciaSelecionadaAtom =
      Atom(name: 'NewTicketStoreBase.urgenciaSelecionada', context: context);

  @override
  int? get urgenciaSelecionada {
    _$urgenciaSelecionadaAtom.reportRead();
    return super.urgenciaSelecionada;
  }

  @override
  set urgenciaSelecionada(int? value) {
    _$urgenciaSelecionadaAtom.reportWrite(value, super.urgenciaSelecionada, () {
      super.urgenciaSelecionada = value;
    });
  }

  late final _$selectedFileAtom =
      Atom(name: 'NewTicketStoreBase.selectedFile', context: context);

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

  late final _$statusMessageAtom =
      Atom(name: 'NewTicketStoreBase.statusMessage', context: context);

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

  late final _$getDetailAsyncAction =
      AsyncAction('NewTicketStoreBase.getDetail', context: context);

  @override
  Future<void> getDetail() {
    return _$getDetailAsyncAction.run(() => super.getDetail());
  }

  late final _$createNewTicketAsyncAction =
      AsyncAction('NewTicketStoreBase.createNewTicket', context: context);

  @override
  Future<Either<String, bool>> createNewTicket(
      String title, String content, File? file, int entityId) {
    return _$createNewTicketAsyncAction
        .run(() => super.createNewTicket(title, content, file, entityId));
  }

  late final _$getTicketDetailAsyncAction =
      AsyncAction('NewTicketStoreBase.getTicketDetail', context: context);

  @override
  Future<dynamic> getTicketDetail(String url) {
    return _$getTicketDetailAsyncAction.run(() => super.getTicketDetail(url));
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
categoriaSelecionada: ${categoriaSelecionada},
tipoSelecionada: ${tipoSelecionada},
urgenciaSelecionada: ${urgenciaSelecionada},
selectedFile: ${selectedFile},
statusMessage: ${statusMessage}
    ''';
  }
}
