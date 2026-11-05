import 'package:geolocator/geolocator.dart';

class ServicoLocalizacao {
  Future<bool> verificarPermissoes() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return false;
    }

    if (permission == LocationPermission.deniedForever) return false;

    return true;
  }

  Stream<Position> obterStreamLocalizacao() {
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 0,
      timeLimit: Duration(seconds: 20),
    );
    return Geolocator.getPositionStream(locationSettings: locationSettings);
  }

  Future<void> abrirConfiguracoes() async {
    await Geolocator.openAppSettings();
  }
}