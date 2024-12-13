// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'orcamento_form_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$OrcamentoFormStore on OrcamentoFormStoreBase, Store {
  late final _$isLoadingAtom =
      Atom(name: 'OrcamentoFormStoreBase.isLoading', context: context);

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

  late final _$isImageLoadingAtom =
      Atom(name: 'OrcamentoFormStoreBase.isImageLoading', context: context);

  @override
  bool get isImageLoading {
    _$isImageLoadingAtom.reportRead();
    return super.isImageLoading;
  }

  @override
  set isImageLoading(bool value) {
    _$isImageLoadingAtom.reportWrite(value, super.isImageLoading, () {
      super.isImageLoading = value;
    });
  }

  late final _$sendLoadingAtom =
      Atom(name: 'OrcamentoFormStoreBase.sendLoading', context: context);

  @override
  bool get sendLoading {
    _$sendLoadingAtom.reportRead();
    return super.sendLoading;
  }

  @override
  set sendLoading(bool value) {
    _$sendLoadingAtom.reportWrite(value, super.sendLoading, () {
      super.sendLoading = value;
    });
  }

  late final _$equipLoadingAtom =
      Atom(name: 'OrcamentoFormStoreBase.equipLoading', context: context);

  @override
  bool get equipLoading {
    _$equipLoadingAtom.reportRead();
    return super.equipLoading;
  }

  @override
  set equipLoading(bool value) {
    _$equipLoadingAtom.reportWrite(value, super.equipLoading, () {
      super.equipLoading = value;
    });
  }

  late final _$isOutroEquipVisibleAtom = Atom(
      name: 'OrcamentoFormStoreBase.isOutroEquipVisible', context: context);

  @override
  bool get isOutroEquipVisible {
    _$isOutroEquipVisibleAtom.reportRead();
    return super.isOutroEquipVisible;
  }

  @override
  set isOutroEquipVisible(bool value) {
    _$isOutroEquipVisibleAtom.reportWrite(value, super.isOutroEquipVisible, () {
      super.isOutroEquipVisible = value;
    });
  }

  late final _$isVisibleCaixaAtom =
      Atom(name: 'OrcamentoFormStoreBase.isVisibleCaixa', context: context);

  @override
  bool get isVisibleCaixa {
    _$isVisibleCaixaAtom.reportRead();
    return super.isVisibleCaixa;
  }

  @override
  set isVisibleCaixa(bool value) {
    _$isVisibleCaixaAtom.reportWrite(value, super.isVisibleCaixa, () {
      super.isVisibleCaixa = value;
    });
  }

  late final _$locationsAtom =
      Atom(name: 'OrcamentoFormStoreBase.locations', context: context);

  @override
  List<Location> get locations {
    _$locationsAtom.reportRead();
    return super.locations;
  }

  @override
  set locations(List<Location> value) {
    _$locationsAtom.reportWrite(value, super.locations, () {
      super.locations = value;
    });
  }

  late final _$filiaisNameAtom =
      Atom(name: 'OrcamentoFormStoreBase.filiaisName', context: context);

  @override
  List<String> get filiaisName {
    _$filiaisNameAtom.reportRead();
    return super.filiaisName;
  }

  @override
  set filiaisName(List<String> value) {
    _$filiaisNameAtom.reportWrite(value, super.filiaisName, () {
      super.filiaisName = value;
    });
  }

  late final _$selectedFilialNameAtom =
      Atom(name: 'OrcamentoFormStoreBase.selectedFilialName', context: context);

  @override
  String? get selectedFilialName {
    _$selectedFilialNameAtom.reportRead();
    return super.selectedFilialName;
  }

  @override
  set selectedFilialName(String? value) {
    _$selectedFilialNameAtom.reportWrite(value, super.selectedFilialName, () {
      super.selectedFilialName = value;
    });
  }

  late final _$selectedLocationObjectAtom = Atom(
      name: 'OrcamentoFormStoreBase.selectedLocationObject', context: context);

  @override
  Location? get selectedLocationObject {
    _$selectedLocationObjectAtom.reportRead();
    return super.selectedLocationObject;
  }

  @override
  set selectedLocationObject(Location? value) {
    _$selectedLocationObjectAtom
        .reportWrite(value, super.selectedLocationObject, () {
      super.selectedLocationObject = value;
    });
  }

  late final _$imagemOrcamentoAtom =
      Atom(name: 'OrcamentoFormStoreBase.imagemOrcamento', context: context);

  @override
  File? get imagemOrcamento {
    _$imagemOrcamentoAtom.reportRead();
    return super.imagemOrcamento;
  }

  @override
  set imagemOrcamento(File? value) {
    _$imagemOrcamentoAtom.reportWrite(value, super.imagemOrcamento, () {
      super.imagemOrcamento = value;
    });
  }

  late final _$urlImageAtom =
      Atom(name: 'OrcamentoFormStoreBase.urlImage', context: context);

  @override
  String? get urlImage {
    _$urlImageAtom.reportRead();
    return super.urlImage;
  }

  @override
  set urlImage(String? value) {
    _$urlImageAtom.reportWrite(value, super.urlImage, () {
      super.urlImage = value;
    });
  }

  late final _$selectedSectorAtom =
      Atom(name: 'OrcamentoFormStoreBase.selectedSector', context: context);

  @override
  String? get selectedSector {
    _$selectedSectorAtom.reportRead();
    return super.selectedSector;
  }

  @override
  set selectedSector(String? value) {
    _$selectedSectorAtom.reportWrite(value, super.selectedSector, () {
      super.selectedSector = value;
    });
  }

  late final _$sectorAtom =
      Atom(name: 'OrcamentoFormStoreBase.sector', context: context);

  @override
  List<String> get sector {
    _$sectorAtom.reportRead();
    return super.sector;
  }

  @override
  set sector(List<String> value) {
    _$sectorAtom.reportWrite(value, super.sector, () {
      super.sector = value;
    });
  }

  late final _$selectedEquipAtom =
      Atom(name: 'OrcamentoFormStoreBase.selectedEquip', context: context);

  @override
  String? get selectedEquip {
    _$selectedEquipAtom.reportRead();
    return super.selectedEquip;
  }

  @override
  set selectedEquip(String? value) {
    _$selectedEquipAtom.reportWrite(value, super.selectedEquip, () {
      super.selectedEquip = value;
    });
  }

  late final _$equipAtom =
      Atom(name: 'OrcamentoFormStoreBase.equip', context: context);

  @override
  List<String> get equip {
    _$equipAtom.reportRead();
    return super.equip;
  }

  @override
  set equip(List<String> value) {
    _$equipAtom.reportWrite(value, super.equip, () {
      super.equip = value;
    });
  }

  late final _$getTicketDetailAsyncAction =
      AsyncAction('OrcamentoFormStoreBase.getTicketDetail', context: context);

  @override
  Future<dynamic> getTicketDetail() {
    return _$getTicketDetailAsyncAction.run(() => super.getTicketDetail());
  }

  late final _$pickFileAsyncAction =
      AsyncAction('OrcamentoFormStoreBase.pickFile', context: context);

  @override
  Future<void> pickFile() {
    return _$pickFileAsyncAction.run(() => super.pickFile());
  }

  late final _$pickImageAsyncAction =
      AsyncAction('OrcamentoFormStoreBase.pickImage', context: context);

  @override
  Future<void> pickImage() {
    return _$pickImageAsyncAction.run(() => super.pickImage());
  }

  late final _$uploadImageAsyncAction =
      AsyncAction('OrcamentoFormStoreBase.uploadImage', context: context);

  @override
  Future<void> uploadImage() {
    return _$uploadImageAsyncAction.run(() => super.uploadImage());
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
isImageLoading: ${isImageLoading},
sendLoading: ${sendLoading},
equipLoading: ${equipLoading},
isOutroEquipVisible: ${isOutroEquipVisible},
isVisibleCaixa: ${isVisibleCaixa},
locations: ${locations},
filiaisName: ${filiaisName},
selectedFilialName: ${selectedFilialName},
selectedLocationObject: ${selectedLocationObject},
imagemOrcamento: ${imagemOrcamento},
urlImage: ${urlImage},
selectedSector: ${selectedSector},
sector: ${sector},
selectedEquip: ${selectedEquip},
equip: ${equip}
    ''';
  }
}
