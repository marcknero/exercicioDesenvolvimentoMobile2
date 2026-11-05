import 'dart:async';
import 'package:flutter/material.dart';
import '../services/servico_localizacao.dart';
import '../data/repositorio_localizacoes.dart';
import '../models/localizacao.dart';
import 'tela_localizacoes.dart';
import 'tela_mapa.dart';

class TelaColeta extends StatefulWidget {
  const TelaColeta({super.key});

  @override
  State<TelaColeta> createState() => _TelaColetaState();
}

class _TelaColetaState extends State<TelaColeta> {
  final ServicoLocalizacao _servicoLoc = ServicoLocalizacao();
  final RepositorioLocalizacoes _repoLoc = RepositorioLocalizacoes();
  
  StreamSubscription? _subscription;
  bool _coletando = false;
  String _statusMensagem = 'Coleta inativa';

  void _iniciarColeta() async {
    bool autorizado = await _servicoLoc.verificarPermissoes();
    if (!autorizado) {
      if (!mounted) return;
      setState(() => _statusMensagem = 'Permissão negada ou GPS desativado.');
      return;
    }

    if (_coletando) return;

    setState(() {
      _coletando = true;
      _statusMensagem = 'Coletando localizações...';
    });

    _subscription = _servicoLoc.obterStreamLocalizacao().listen((position) async {
      Localizacao novaLoc = Localizacao(
        latitude: position.latitude,
        longitude: position.longitude,
        precisao: position.accuracy,
        instante: position.timestamp.toIso8601String(),
      );
      await _repoLoc.inserir(novaLoc);
    }, onError: (error) {
      setState(() => _statusMensagem = 'Erro no stream: $error');
    });
  }

  void _pararColeta() {
    _subscription?.cancel();
    setState(() {
      _coletando = false;
      _statusMensagem = 'Coleta pausada.';
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Coleta de Localização')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_statusMensagem, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _coletando ? null : _iniciarColeta,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Iniciar Coleta'),
              ),
              ElevatedButton.icon(
                onPressed: !_coletando ? null : _pararColeta,
                icon: const Icon(Icons.stop),
                label: const Text('Parar Coleta'),
              ),
              ElevatedButton.icon(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TelaLocalizacoes())),
                icon: const Icon(Icons.list),
                label: const Text('Consultar Histórico'),
              ),
              ElevatedButton.icon(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TelaMapa())),
                icon: const Icon(Icons.map),
                label: const Text('Ver Mapa'),
              ),
              OutlinedButton.icon(
                onPressed: () => _servicoLoc.abrirConfiguracoes(),
                icon: const Icon(Icons.settings),
                label: const Text('Configurações de Permissão'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}