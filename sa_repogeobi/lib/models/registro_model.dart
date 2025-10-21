class RegistroModel {
  final String data;
  final String hora;
  final double latitude;
  final double longitude;

  RegistroModel({
    required this.data,
    required this.hora,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toMap() {
    return {
      'data': data,
      'hora': hora,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
