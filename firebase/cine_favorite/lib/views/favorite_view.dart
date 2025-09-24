import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login_view.dart';

class FavoriteView extends StatelessWidget {
  const FavoriteView({super.key});

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Meus Filmes Favoritos"),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Center(
        child: Text(
          "Bem-vindo, ${user?.email ?? 'Usuário'}!\n\nAqui ficarão seus filmes favoritos.",
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
