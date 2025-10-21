import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class LocationService {
  /// Obtém a localização atual do usuário
  Future<Position> getCurrentLocation() async {
    // Verifica se o serviço de localização está ativado
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Serviço de localização desativado.');
    }

    // Verifica permissão
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Permissão de localização negada.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
          'Permissão de localização permanentemente negada. Ative nas configurações.');
    }

    // Retorna a posição atual
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  /// Calcula distância entre dois pontos (em metros)
  double calcularDistancia(
      double lat1, double lon1, double lat2, double lon2) {
    const Distance distance = Distance();
    final p1 = LatLng(lat1, lon1);
    final p2 = LatLng(lat2, lon2);
    return distance(p1, p2);
  }
}
