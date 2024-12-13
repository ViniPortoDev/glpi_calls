// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Orcamento {
  final String id;
  final String autor;
  final DateTime data;
  final String filial;
  final String setor;
  final String equipamento;
  final String caixa;
  final String patrimonio;
  final int quantidade;
  final String observacao;
  String status;
  String imageUrl;
  final List<String> gerentes;
  final List<Map<String, dynamic>> gerentesInfo;
  final String? editor;
  final DateTime? dataEdicao;

  Orcamento({
    required this.id,
    required this.autor,
    required this.data,
    required this.filial,
    required this.setor,
    required this.equipamento,
    required this.caixa,
    required this.patrimonio,
    required this.quantidade,
    required this.observacao,
    required this.status,
    required this.imageUrl,
    required this.gerentes,
    required this.gerentesInfo,
    this.editor,
    this.dataEdicao,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'autor': autor,
      'data': data,
      'filial': filial,
      'setor': setor,
      'equipamento': equipamento,
      'caixa': caixa,
      'patrimonio': patrimonio,
      'quantidade': quantidade,
      'observacao': observacao,
      'status': status,
      'imageUrl': imageUrl,
      'gerentes': gerentes,
      'gerentes_info': gerentesInfo,
      'editor': editor,
      'data_edicao': dataEdicao,
    };
  }

  factory Orcamento.fromMap(Map<String, dynamic> map, String id) {
    final data = map['data'] as Timestamp;
    Timestamp? dataEdicao = map['data_edicao'];

    return Orcamento(
      id: id,
      autor: map['autor'] ?? '',
      data: data.toDate(),
      filial: map['filial'] ?? '',
      setor: map['setor'] ?? '',
      equipamento: map['equipamento'] ?? '',
      caixa: map['caixa'] ?? '',
      patrimonio: map['patrimonio'] ?? '',
      quantidade: map['quantidade'] ?? 0,
      observacao: map['observacao'] ?? '',
      status: map['status'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      gerentes: List<String>.from((map['gerentes'] ?? [] as List<String>)),
      gerentesInfo: List<Map<String, dynamic>>.from(
          (map['gerentes_info'] as List<dynamic>)
              .map<Map<String, dynamic>>((x) => x)),
      editor: map['editor'],
      dataEdicao: dataEdicao?.toDate(),
    );
  }

  String toJson() => json.encode(toMap());
}
