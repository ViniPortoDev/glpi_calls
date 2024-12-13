import 'package:flutter/material.dart';

Color getStatusColor(String status) {
  switch (status) {
    case 'Novo':
      return const Color(0xFF2196F3); // Azul (mais claro para um contraste suave)
    case 'Cancelado':
      return const Color(0xFFD32F2F); // Vermelho (mais intenso para um status de cancelamento)
    case 'Aguardando Cotação':
      return const Color(0xFFFFA000); // Laranja (mais vibrante para chamar atenção)
    case 'Aguardando Aprovação':
      return const Color(0xFF388E3C); // Verde escuro (representando algo pendente, mas positivo)
    case 'Aprovação Contábil':
      return const Color(0xFF6D4C41); // Marrom (uma cor neutra e formal para a aprovação contábil)
    case 'Aguardando Faturamento':
      return const Color(0xFF00796B); // Teal escuro (diferenciando-se claramente das outras etapas)
    case 'Aguardando Entrega':
      return const Color(0xFF004D40); // Verde escuro (simbolizando progresso)
    case 'Concluído':
      return const Color(0xFF4CAF50); // Verde claro (indicando finalização e sucesso)
    default:
      return Colors.grey; // Cinza (para estados desconhecidos ou neutros)
  }
}

