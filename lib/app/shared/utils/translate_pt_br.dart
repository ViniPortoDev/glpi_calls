class TranslatePtBr {
  String text;
  TranslatePtBr({required this.text});

  String get translate {
    switch (text) {
      case 'Location':
        return 'Localização';
      case 'Document_Item':
        return 'Arquivos';
      case 'Ticket':
        return 'Chamado';
      case 'Ticket_Item':
        return 'Chamados';
      case 'Ticket_Status':
        return 'Status';
      case 'Ticket_Priority':
        return 'Prioridade';
      case 'Ticket_Type':
        return 'Tipo';
      case 'Ticket_Source':
        return 'Origem';
      case 'Ticket_Queue':
        return 'Fila';
      case 'Ticket_Lock': 
        return 'Bloqueado';
      case 'Ticket_Lock_Yes':
        return 'Sim';
      case 'Ticket_Lock_No':
        return 'Não';
      case 'TicketTask':
        return 'Tarefas';
      case 'TicketTask_Item':
        return 'Tarefa';
      case 'TicketValidation':
        return 'Validações';
      case 'TicketValidation_Item':
        return 'Validação';
      case 'TicketCost':
        return 'Custos';
      case 'Problem_Ticket':
        return 'Problemas';
      case 'Change_Ticket':
        return 'Alterações';
      case 'Item_Ticket':
        return 'Itens';
      case 'ITILSolution':
        return 'Soluções';
      case 'ITILFollowup':
        return 'Mensagens';
      default:
        return text;
    }
  }
}
