import 'package:flutter/material.dart';
import 'package:timelines/timelines.dart';

class HorizontalStatusTimelineWidget extends StatelessWidget {
  final double? height;
  final double? width;
  final String currentStatus;
  final String? updatedBy;
  final String? updatedAt;

  HorizontalStatusTimelineWidget({
    super.key,
    this.height,
    this.width,
    required this.currentStatus,
    this.updatedBy,
    this.updatedAt,
  });

  final List<String> statusList = [
    'Novo',
    'Aguardando Cotação',
    'Aguardando Aprovação',
    'Aprovação Contábil',
    'Aguardando Faturamento',
    'Aguardando Entrega',
    'Concluído',
    'Cancelado', // Adicionado o status 'Cancelado'
  ];

  @override
  Widget build(BuildContext context) {
    final double availableWidth = width ?? MediaQuery.of(context).size.width;

    return SizedBox(
      height: height ?? 100, // Ajuste a altura para caber na tela
      width: availableWidth,
      child: Timeline.tileBuilder(
        theme: TimelineThemeData(
          direction: Axis.horizontal,
          connectorTheme: const ConnectorThemeData(
            space: 2.0,
            thickness: 5.0,
          ),
        ),
        builder: TimelineTileBuilder.connected(
          connectionDirection: ConnectionDirection.before,
          itemCount: statusList.length,
          contentsBuilder: (context, index) {
            final status = statusList[index];
            return Padding(
              padding: const EdgeInsets.only(
                top: 8,
                left: 8,
                right: 8,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    status,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: index < _currentStep(currentStatus)
                          ? Colors.green
                          : (index == _currentStep(currentStatus)
                              ? Colors.green
                              : Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (status == currentStatus && updatedBy != null)
                    Text('Autor: $updatedBy', style: const TextStyle(fontSize: 10)),
                  if (status == currentStatus && updatedAt != null)
                    Text('Data: $updatedAt', style: const TextStyle(fontSize: 10)),
                ],
              ),
            );
          },
          indicatorBuilder: (_, index) {
            return DotIndicator(
              size: 20.0,
              color: index < _currentStep(currentStatus)
                  ? Colors.green
                  : (index == _currentStep(currentStatus)
                      ? Colors.green
                      : Colors.grey),
              child: Icon(
                index < _currentStep(currentStatus)
                    ? Icons.check
                    : (index == _currentStep(currentStatus)
                        ? currentStatus == 'Novo' ||
                                currentStatus == 'Concluído' ||
                                currentStatus == 'Cancelado' // Inclui Cancelado
                            ? Icons.check
                            : Icons.pending
                        : Icons.check),
                color: Colors.white,
                size: 12.0,
              ),
            );
          },
          connectorBuilder: (_, index, type) {
            return SolidLineConnector(
              color: index <= _currentStep(currentStatus)
                  ? Colors.green
                  : Colors.grey,
            );
          },
        ),
      ),
    );
  }

  int _getStep(String status) {
    return statusList.indexOf(status);
  }

  int _currentStep(String status) {
    return _getStep(status);
  }
}
