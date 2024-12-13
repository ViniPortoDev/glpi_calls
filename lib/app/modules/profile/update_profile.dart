import 'package:flutter/material.dart';

class UpdateProfilePage extends StatelessWidget {
  const UpdateProfilePage({super.key});

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Atualizar Perfil'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'UpdateProfilePage is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
