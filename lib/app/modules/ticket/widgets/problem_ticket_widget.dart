import 'package:flutter/material.dart';


Widget problemTicketWidget(dynamic entity) {
  //print(entity);
  if(entity.length>0){
  return Container(
    padding:  const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    child: Column(
        children: List.generate(entity.length, (index) {
      return const Column(
        children: [
          Text('IMPLEMENTAAAARRR')
        ],
      );
    })),
  );
}else{
  return const Text('Sem informacoes');
}

}
