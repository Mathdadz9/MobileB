import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firebase_service.dart';
import 'ponto_view.dart';
import 'registro_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});
  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _firebase = FirebaseService();
  String _status = '';

  Future<void> _login() async {
    setState(() => _status = 'Autenticando...');
    try {
      await _firebase.signIn(_emailCtrl.text.trim(), _passCtrl.text);
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        setState(() => _status = 'Usuário não encontrado após login.');
        return;
      }

      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Permissões e Procedimento'),
          content: const Text(
            'O app precisa de permissão de localização e autenticação biométrica '
            'para registrar o ponto. Na próxima tela você poderá bater o ponto (biometria) '
            'ou registrar manualmente (teste).'
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Entendi')),
          ],
        ),
      );

      if (!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const PontoView()));
    } catch (e) {
      setState(() => _status = 'Erro ao autenticar: ${e.toString()}');
    }
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: const Text('Login')),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _emailCtrl,
            decoration: const InputDecoration(labelText: 'NIF / Email'),
            keyboardType: TextInputType.emailAddress,
          ),
          TextField(
            controller: _passCtrl,
            decoration: const InputDecoration(labelText: 'Senha'),
            obscureText: true,
          ),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: _login, child: const Text('Entrar')),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RegistroView()),
            ),
            child: const Text('Criar Conta'),
          ),
          const SizedBox(height: 12),
          Text(_status),
        ],
      ),
    ),
  );
}
}