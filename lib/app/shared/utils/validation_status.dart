
import 'package:flutter/material.dart';

Map<int, Map<String,dynamic>> validationStatus = {
  2: {
    'name': 'Esperando por uma validação',
    'color': Colors.yellow,
  },
  4: {
    'name': 'Recusado',
    'color': Colors.red,
  },
  3: {
    'name': 'Concedida',
    'color': Colors.green,
  },
};