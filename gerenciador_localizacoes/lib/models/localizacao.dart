class Localizacao {
  final int? id;
  final double latitude;
  final double longitude;
  final double precisao;
  final String instante;

  Localizacao({
    this.id,
    required this.latitude,
    required this.longitude,
    required this.precisao,
    required this.instante,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'precisao': precisao,
      'instante': instante,
    };
  }

  factory Localizacao.fromMap(Map<String, dynamic> map) {
    return Localizacao(
      id: map['id'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      precisao: map['precisao'],
      instante: map['instante'],
    );
  }
}