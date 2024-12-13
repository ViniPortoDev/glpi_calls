import 'package:app_glpi_ios/app/shared/models/orcamento.dart';
import 'package:app_glpi_ios/app/shared/utils/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';

import '../../shared/models/user.dart';
import '../../shared/utils/logger.dart';

part 'orcamento_store.g.dart';

class OrcamentoStore = OrcamentoStoreBase with _$OrcamentoStore;

abstract class OrcamentoStoreBase with Store {
  @observable
  bool isLoading = false;

  @observable
  bool isContabilUser = false;

  @observable
  List<String> notificationsIds = [];

  @observable
  ObservableList<Orcamento> orcamentoList = ObservableList<Orcamento>();

  @action
  Future<void> getOrcamentos(User user) async {
    isLoading = true;
    try {
      orcamentoList.clear();

      List<QueryDocumentSnapshot> querySnapshotDocs = [];

      if (user.type == 3 || user.type == 4) {
        var querySnapshot = await db.collection('orcamento').get();
        querySnapshotDocs = querySnapshot.docs;
      } else {
        // Consulta 1: Verifica se o usuário é o autor
        QuerySnapshot querySnapshotAutor = await db
            .collection('orcamento')
            .where('autor', isEqualTo: user.name)
            .get();

        // Consulta 2: Verifica se o usuário é um dos gerentes e o status é "Aguardando Aprovação"
        QuerySnapshot querySnapshotGerente = await db
            .collection('orcamento')
            .where('status', isEqualTo: 'Aguardando Aprovação')
            .where('gerentes', arrayContains: user.name)
            .get();

        //Consulta 3: Verifica se o usuário é um dos gerentes e o status é "Aguardando Entrega"
        QuerySnapshot querySnapshotEntrega = await db
            .collection('orcamento')
            .where('status', isEqualTo: 'Aguardando Entrega')
            .where('gerentes', arrayContains: user.name)
            .get();

        //Consulta 4: Verifica se o usuario é um contador
        var querySnapshot = await db.collection('contabil').get();
        List<Map<String, dynamic>> userContailList = [];
        for (var doc in querySnapshot.docs) {
          Map<String, dynamic> userContabilMap = doc.data();
          userContailList.add(userContabilMap);
        }
        isContabilUser = userContailList.any((userContabilMap) {
          return userContabilMap.values.any((value) {
            return value is String && value.contains(user.name);
          });
        });

        if (isContabilUser) {
          QuerySnapshot querySnapshotContador = await db
              .collection('orcamento')
              .where('status', isEqualTo: 'Aprovação Contábil')
              .get();
          querySnapshotDocs.addAll(querySnapshotContador.docs);
        }

        // Combina os resultados das duas consultas
        querySnapshotDocs.addAll(querySnapshotAutor.docs);
        querySnapshotDocs.addAll(querySnapshotEntrega.docs);
        querySnapshotDocs.addAll(querySnapshotGerente.docs);

        // Remove duplicados, se houver
        querySnapshotDocs = querySnapshotDocs.toSet().toList();
      }

      // Processa os resultados
      for (var doc in querySnapshotDocs) {
        var orcamentoMap = doc.data()
            as Map<String, dynamic>?; // Verifica se o valor não é nulo
        if (orcamentoMap != null) {
          var ref = doc.reference;
          Orcamento orcamento = Orcamento.fromMap(orcamentoMap, ref.id);
          orcamentoList.add(orcamento);

          logger.i(orcamentoMap.toString());
        }
      }

      // Ordena a lista pela data mais recente primeiro
      orcamentoList.sort((a, b) => b.data.compareTo(a.data));
    } catch (e) {
      logger.e('Erro ao buscar orçamentos: $e');
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> updateOrcamento(String documentId, String newStatus) async {
    try {
      isLoading = true;

      DocumentReference documentReference =
          FirebaseFirestore.instance.collection('orcamento').doc(documentId);

      await documentReference.update({'status': newStatus});
      isLoading = false;
    } catch (e) {
      logger.e(e);
      isLoading = false;
    }
  }

  Future<void> getNotificationsIds(String autor) async {
    notificationsIds.clear();
    try {
      List<QueryDocumentSnapshot> querySnapshotDocs = [];

      //Pegaos ids dos adms
      QuerySnapshot querySnapshotAdms = await db
          .collection('users')
          .where('glpiactiveprofile', whereIn: [3, 4, 10]).get();

      //Pega o id do autor
      QuerySnapshot querySnapshotAutor = await db
          .collection('users')
          .where('glpiname', isEqualTo: autor)
          .get();

      querySnapshotDocs.addAll(querySnapshotAdms.docs);
      querySnapshotDocs.addAll(querySnapshotAutor.docs);

      for (var doc in querySnapshotDocs) {
        var admsIdsMap = doc.data()
            as Map<String, dynamic>?; // Verifica se o valor não é nulo
        if (admsIdsMap != null) {
          notificationsIds.add(admsIdsMap['glpiID'].toString());
        }
      }
      notificationsIds = notificationsIds.toSet().toList();
    } catch (e) {
      logger.e(e);
    }
  }
}
