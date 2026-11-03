import 'package:flutter/material.dart';
import '../models/participante.dart';
import 'tela_resumo.dart';

class TelaCadastro extends StatefulWidget {
  const TelaCadastro({super.key});

  @override
  State<TelaCadastro> createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _nomeController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _cpfController = TextEditingController();

  // --- Validações ---

  String? _validarEmail(String? valor) {
    final email = valor?.trim() ?? '';
    if (email.isEmpty) {
      return 'Informe o e-mail.';
    }
    final formato = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (!formato.hasMatch(email)) {
      return 'Informe um e-mail válido.';
    }
    return null;
  }

  String? _validarNome(String? valor) {
    final nome = valor?.trim() ?? '';
    if (nome.isEmpty) {
      return 'Informe o nome.';
    }
    if (nome.length < 3) {
      return 'O nome deve ter pelo menos três caracteres.';
    }
    return null;
  }

  String? _validarTelefone(String? valor) {
    final telefone = valor?.trim() ?? '';
    if (telefone.isEmpty) {
      return 'Informe o telefone.';
    }
    // Formato esperado: DD-DDDDD-DDDD (ex: 12-99999-9999 ou 00-00000-0000)
    final formato = RegExp(r'^\d{2}-\d{5}-\d{4}$');
    if (!formato.hasMatch(telefone)) {
      return 'Informe um telefone válido no formato DD-DDDDD-DDDD.';
    }
    return null;
  }

  String? _validarCpf(String? valor) {
    final cpf = valor?.trim() ?? '';
    if (cpf.isEmpty) {
      return 'Informe o CPF.';
    }
    // Exatamente 11 dígitos numéricos
    final formato = RegExp(r'^\d{11}$');
    if (!formato.hasMatch(cpf)) {
      return 'O CPF deve conter exatamente 11 dígitos (apenas números).';
    }
    return null;
  }

  // --- Ações ---

  void _exibirDados() {
    final formularioValido = _formKey.currentState!.validate();
    if (!formularioValido) {
      return;
    }

    final participante = Participante(
      email: _emailController.text.trim(),
      nome: _nomeController.text.trim(),
      telefone: _telefoneController.text.trim(),
      cpf: _cpfController.text.trim(),
    );

    FocusScope.of(context).unfocus();

    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => TelaResumo(participante: participante),
      ),
    );
  }

  void _limpar() {
    _formKey.currentState!.reset();
    _emailController.clear();
    _nomeController.clear();
    _telefoneController.clear();
    _cpfController.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _nomeController.dispose();
    _telefoneController.dispose();
    _cpfController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de participante'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Informe os dados do participante.',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 24),

              // 1. E-mail
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  hintText: 'Ex.: ana@email.com',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autocorrect: false,
                validator: _validarEmail,
              ),
              const SizedBox(height: 16),

              // 2. Nome
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  hintText: 'Ex.: Ana Souza',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                validator: _validarNome,
              ),
              const SizedBox(height: 16),

              // 3. Telefone
              TextFormField(
                controller: _telefoneController,
                decoration: const InputDecoration(
                  labelText: 'Telefone',
                  hintText: 'DD-DDDDD-DDDD',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                validator: _validarTelefone,
              ),
              const SizedBox(height: 16),

              // 4. CPF
              TextFormField(
                controller: _cpfController,
                decoration: const InputDecoration(
                  labelText: 'CPF',
                  hintText: 'Apenas os 11 dígitos',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                validator: _validarCpf,
                onFieldSubmitted: (_) => _exibirDados(),
              ),
              const SizedBox(height: 24),

              // Botões
              ElevatedButton(
                onPressed: _exibirDados,
                child: const Text('Exibir dados'),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: _limpar,
                child: const Text('Limpar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}