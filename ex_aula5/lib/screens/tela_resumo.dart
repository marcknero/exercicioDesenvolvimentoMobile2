import 'package:flutter/material.dart';
import '../models/participante.dart';

class TelaResumo extends StatelessWidget {
  final Participante participante;

  const TelaResumo({
    super.key,
    required this.participante,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resumo do cadastro'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Dados do participante',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Text('E-mail: ${participante.email}'),
            const SizedBox(height: 12),
            Text('Nome: ${participante.nome}'),
            const SizedBox(height: 12),
            Text('Telefone: ${participante.telefone}'),
            const SizedBox(height: 12),
            Text('CPF: ${participante.cpf}'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Voltar para editar'),
            ),
          ],
        ),
      ),
    );
  }
}