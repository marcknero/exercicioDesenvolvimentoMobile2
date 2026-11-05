import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/repositorio_localizacoes.dart';
import '../models/localizacao.dart';

class TelaLocalizacoes extends StatefulWidget {
  const TelaLocalizacoes({super.key});

  @override
  State<TelaLocalizacoes> createState() => _TelaLocalizacoesState();
}

class _TelaLocalizacoesState extends State<TelaLocalizacoes> {
  final RepositorioLocalizacoes _repo = RepositorioLocalizacoes();
  late Future<List<Localizacao>> _futureLocalizacoes;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  void _carregarDados() {
    setState(() {
      _futureLocalizacoes = _repo.consultarUltimas100();
    });
  }

  void _confirmarLimpeza() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Limpar Histórico'),
        content: const Text('Operação permanente. Deseja limpar todo o histórico? Novos registros continuarão sendo salvos se a coleta estiver ativa.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _repo.limparHistorico();
              _carregarDados();
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Histórico limpo com sucesso!')));
            },
            child: const Text('Limpar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _carregarDados),
          IconButton(icon: const Icon(Icons.delete), onPressed: _confirmarLimpeza),
        ],
      ),
      body: FutureBuilder<List<Localizacao>>(
        future: _futureLocalizacoes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum registro encontrado.'));
          }

          final lista = snapshot.data!;
          return ListView.builder(
            itemCount: lista.length,
            itemBuilder: (context, index) {
              final item = lista[index];
              final dataLocal = DateTime.parse(item.instante).toLocal();
              final dataFormatada = DateFormat('dd/MM/yyyy HH:mm:ss').format(dataLocal);

              return ListTile(
                leading: const Icon(Icons.location_pin, color: Colors.red),
                title: Text('Lat: ${item.latitude.toStringAsFixed(6)}, Lng: ${item.longitude.toStringAsFixed(6)}'),
                subtitle: Text('Precisão: ${item.precisao.toStringAsFixed(1)}m\nData: $dataFormatada'),
                isThreeLine: true,
              );
            },
          );
        },
      ),
    );
  }
}