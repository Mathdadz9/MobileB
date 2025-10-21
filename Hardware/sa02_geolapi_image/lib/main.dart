import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MaterialApp(
    home: GaleriaFotos(),
    debugShowCheckedModeBanner: false,
  ));
}

class GaleriaFotos extends StatefulWidget {
  const GaleriaFotos({super.key});

  @override
  State<GaleriaFotos> createState() => _GaleriaFotosState();
}

class _GaleriaFotosState extends State<GaleriaFotos> {
  final ImagePicker _picker = ImagePicker();
  List<Map<String, dynamic>> _fotos = []; // lista de fotos + infos

  // método para tirar foto e salvar com localização
  Future<void> _tirarFoto() async {
    final XFile? fotoTemporaria =
        await _picker.pickImage(source: ImageSource.camera);

    if (fotoTemporaria != null) {
      // pega posição atual
      Position pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // pega nome da cidade
      List<Placemark> placemarks =
          await placemarkFromCoordinates(pos.latitude, pos.longitude);
      String cidade = placemarks.isNotEmpty ? placemarks[0].locality ?? "Desconhecida" : "Desconhecida";

      // salva a imagem localmente na pasta do app
      final dir = await getApplicationDocumentsDirectory();
      final caminhoNovo =
          '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
      await File(fotoTemporaria.path).copy(caminhoNovo);

      // adiciona na lista
      setState(() {
        _fotos.add({
          'file': File(caminhoNovo),
          'data': DateTime.now(),
          'cidade': cidade,
        });
      });
    }
  }

  // pede permissão de localização
  Future<void> _pedirPermissaoLocalizacao() async {
    bool servicoHabilitado;
    LocationPermission permissao;

    servicoHabilitado = await Geolocator.isLocationServiceEnabled();
    if (!servicoHabilitado) return;

    permissao = await Geolocator.checkPermission();
    if (permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();
      if (permissao == LocationPermission.denied) {
        return;
      }
    }

    if (permissao == LocationPermission.deniedForever) {
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    _pedirPermissaoLocalizacao();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Galeria de Fotos com Localização"),
        backgroundColor: Colors.blueAccent,
      ),
      body: _fotos.isEmpty
          ? const Center(child: Text("Nenhuma foto tirada ainda."))
          : GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 imagens por linha
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: _fotos.length,
              itemBuilder: (context, index) {
                final foto = _fotos[index];
                return GestureDetector(
                  onTap: () {
                    // abrir detalhes da foto
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetalhesFoto(
                          imagem: foto['file'],
                          data: foto['data'],
                          cidade: foto['cidade'],
                        ),
                      ),
                    );
                  },
                  child: Hero(
                    tag: foto['file'].path,
                    child: Image.file(
                      foto['file'],
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _tirarFoto,
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

class DetalhesFoto extends StatelessWidget {
  final File imagem;
  final DateTime data;
  final String cidade;

  const DetalhesFoto({
    super.key,
    required this.imagem,
    required this.data,
    required this.cidade,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detalhes da Foto")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Hero(
            tag: imagem.path,
            child: Image.file(imagem, fit: BoxFit.cover, height: 400),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("📅 Data: ${data.toLocal()}"),
                const SizedBox(height: 10),
                Text("📍 Cidade: $cidade"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
