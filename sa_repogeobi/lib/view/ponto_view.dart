import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart'; // <-- Corrigido
import '../services/location_service.dart';
import '../services/biometrics_service.dart';
import '../services/permission_service.dart';
import '../services/firebase_service.dart';
import 'historico_view.dart';
import 'ponto_map.dart';

class PontoView extends StatefulWidget {
  const PontoView({super.key});

  @override
  State<PontoView> createState() => _PontoViewState();
}

class _PontoViewState extends State<PontoView> {
  final _locationService = LocationService();
  final _biometrics = BiometricsService();
  final _firebase = FirebaseService();

  LatLng? _currentPosition;
  String _status = "Aguardando ação...";
  bool _loading = false;

  Future<void> _registrarPonto() async {
    if (_loading) return;
    setState(() {
      _loading = true;
      _status = "Verificando permissões...";
    });

    final okPerms = await PermissionService.requestLocationPermission();
    if (!okPerms) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _status = "Permissão de localização necessária.";
      });
      return;
    }

    setState(() => _status = "Obtendo localização...");

    try {
      // <-- Corrigido: agora usa Position do Geolocator
      final Position pos = await _locationService
          .getCurrentLocation()
          .timeout(const Duration(seconds: 10));

      _currentPosition = LatLng(pos.latitude, pos.longitude);
    } on TimeoutException {
      _currentPosition = null;
    } catch (e) {
      _currentPosition = null;
    }

    if (_currentPosition == null) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _status = "Não foi possível obter a localização.";
      });
      return;
    }

    setState(() => _status = "Verificando perímetro...");

    final distancia = _locationService.calcularDistancia(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
      -23.562,
      -46.655,
    );

    if (distancia > 100) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _status =
            "Fora do perímetro da empresa! (${distancia.toStringAsFixed(1)} m)";
      });
      return;
    }

    setState(() => _status = "Autenticando biometria...");

    final autenticado = await _biometrics.autenticar();
    if (!autenticado) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _status = "Falha na autenticação biométrica.";
      });
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _status = "Usuário não autenticado.";
      });
      return;
    }

    try {
      await _firebase.savePonto(
        uid: user.uid,
        latitude: _currentPosition!.latitude,
        longitude: _currentPosition!.longitude,
        timestamp: DateTime.now(),
      );
      if (!mounted) return;
      setState(() {
        _loading = false;
        _status = "Ponto registrado com sucesso!";
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _status = "Erro ao salvar ponto: ${e.toString()}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Registrar Ponto'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Registrar'),
              Tab(text: 'Histórico'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Aba Registrar
            SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  if (_currentPosition != null)
                    SizedBox(
                      height: 300,
                      child: PontoMap(position: _currentPosition!),
                    )
                  else
                    const SizedBox(
                      height: 300,
                      child:
                          Center(child: Text("Localização não disponível")),
                    ),
                  const SizedBox(height: 16),
                  Text(_status, textAlign: TextAlign.center),
                  const SizedBox(height: 20),
                  if (_loading) const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _registrarPonto,
                    child: const Text('Bater Ponto'),
                  ),
                ],
              ),
            ),

            // Aba Histórico
            Builder(builder: (ctx) {
              if (user == null) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                            'Faça login para ver o histórico de pontos.'),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () => Navigator.pushReplacementNamed(
                              context, '/login'),
                          child: const Text('Ir para Login'),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return HistoricoView(uid: user.uid);
            }),
          ],
        ),
      ),
    );
  }
}
