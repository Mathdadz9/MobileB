import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class PontoMap extends StatelessWidget {
  final LatLng position;
  const PontoMap({super.key, required this.position});

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: MapController(), 
      options: MapOptions(
        initialCenter: position, 
        initialZoom: 16.0,       
        maxZoom: 18.0,
        minZoom: 3.0,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
          subdomains: const ['a', 'b', 'c'],
        ),
        MarkerLayer(
          markers: [
           Marker(
          point: LatLng(-23.55, -46.63),
          child: const Icon(Icons.location_on),

              
            ),
          ],
        ),
      ],
    );
  }
}
