import 'package:flutter/material.dart';
import 'ponto_view.dart';
import 'historico_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PontoView())),
              child: const Text('Registrar Ponto'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                final user = null; // se usar auth, pegue FirebaseAuth.instance.currentUser
                if (user == null) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Faça login primeiro.')));
                  return;
                }
                // Navigator.push(context, MaterialPageRoute(builder: (_) => HistoricoView(uid: user.uid)));
              },
              child: const Text('Ver Histórico'),
            ),
          ],
        ),
      ),
    );
  }
}
