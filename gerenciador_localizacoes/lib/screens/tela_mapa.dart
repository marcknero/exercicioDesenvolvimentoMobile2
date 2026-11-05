import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../data/repositorio_localizacoes.dart';
import '../models/localizacao.dart';

class TelaMapa extends StatefulWidget {
  const TelaMapa({super.key});

  @override
  State<TelaMapa> createState() => _TelaMapaState();
}

class _TelaMapaState extends State<TelaMapa> {
  final RepositorioLocalizacoes _repo = RepositorioLocalizacoes();
  late Future<List<Localizacao>> _futureLocalizacoes;

  @override
  void initState() {
    super.initState();
    _atualizarMapa();
  }

  void _atualizarMapa() {
    setState(() {
      _futureLocalizacoes = _repo.consultarUltimas100();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa Interativo'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _atualizarMapa),
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
              return const Center(child: Text('Nenhuma posição salva.'));
            }

            final localizacoes = snapshot.data!;
            final ultima = localizacoes.first;
            
            final Set<Marker> marcadores = localizacoes.map((loc) {
              bool maisRecente = loc.id == ultima.id;
              return Marker(
                markerId: MarkerId(loc.id.toString()),
                position: LatLng(loc.latitude, loc.longitude),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  maisRecente ? BitmapDescriptor.hueRed : BitmapDescriptor.hueBlue,
                ),
              );
            }).toSet();

            return GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(ultima.latitude, ultima.longitude),
                zoom: 15,
              ),
              markers: marcadores,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            );
        },
      ),
    );
  }
}