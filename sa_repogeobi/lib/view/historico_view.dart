import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class HistoricoView extends StatelessWidget {
  final String uid;
  const HistoricoView({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    final _firebase = FirebaseService();

    return Scaffold(
      appBar: AppBar(title: const Text("Histórico de Registros")),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firebase.listarRegistros(uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Nenhum registro encontrado"));
          }

          final docs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, i) {
              final data = docs[i].data() as Map<String, dynamic>;

              // trata timestamp salvo como Timestamp ou String
              DateTime dateTime;
              final raw = data['timestamp'];
              if (raw is Timestamp) {
                dateTime = raw.toDate().toLocal();
              } else if (raw is String) {
                dateTime = DateTime.tryParse(raw)?.toLocal() ?? DateTime.now();
              } else {
                dateTime = DateTime.now();
              }

              final formatted = DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
              final lat = data['latitude']?.toString() ?? '-';
              final lon = data['longitude']?.toString() ?? '-';

              return ListTile(
                leading: const Icon(Icons.access_time),
                title: Text(formatted),
                subtitle: Text("Lat: $lat, Long: $lon"),
              );
            },
          );
        },
      ),
    );
  }
}
