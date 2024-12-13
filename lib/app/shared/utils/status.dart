import 'package:flutter/material.dart';

Map<int, Map<String, dynamic>> status = {
  1: {
    'name': 'Novo',
    'color': const Color(0xff88d2ff),
  },
  2: {
    'name': 'Processando (atribuido)',
    'color': const Color(0xffffc107),
  },
  3: {
    'name': 'Processando (planejado)',
    'color': Colors.black,
  },
  4: {
    'name': 'Pendente',
    'color': Colors.yellow,
  },
  5: {
    'name': 'Solucionado',
    'color': const Color(0xff00FF7F),
  },
  6: {
    'name': 'Fechado',
    'color': Colors.grey,
  },
  /* 
  1: 'Novo',
  2: 'Processando (atribuido)',
  3: 'Processando (planejado)', 
  4: 'Pendente', 
  5: 'Solucionado',
  6: 'Fechado', 
  
  case 1:
      return "#88d2ff";
    case 2:
      return "#ffc107";
    case 3:
      return "#6298d5";
    case 4:
      return "#ffcb7d";
    case 5:
      return "#00FF7F";
    default:
      return "#000000";

  */
};
