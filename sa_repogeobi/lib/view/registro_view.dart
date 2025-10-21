import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firebase_service.dart';
import '../services/location_service.dart';
import '../services/permission_service.dart';
import 'ponto_view.dart';

class RegistroView extends StatefulWidget {
  final String? uid;
  const RegistroView({super.key, this.uid});

  @override
  State<RegistroView> createState() => _RegistroViewState();
}

class _RegistroViewState extends State<RegistroView> {
  // campos para criação de usuário
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _nomeCtrl = TextEditingController(); // opcional
  bool _loading = false;
  String _status = '';

  final _firebase = FirebaseService();
  final _location = LocationService();

  // Modo: criar usuário (quando widget.uid == null)
  Future<void> _registrarUsuario() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _status = 'Criando conta...';
    });

    final email = _emailCtrl.text.trim();
    final pass = _passCtrl.text;
    try {
      final cred = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: pass);

      final nome = _nomeCtrl.text.trim();
      if (nome.isNotEmpty) {
        await cred.user?.updateDisplayName(nome);
      }

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const PontoView()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() => _status = e.message ?? e.code);
    } catch (e) {
      setState(() => _status = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  // Modo: registrar ponto manual (quando widget.uid != null)
  Future<void> _registrarPontoManual() async {
    setState(() => _loading = true);

    final okPerms = await PermissionService.requestLocationPermission();
    if (!okPerms) {
      setState(() {
        _loading = false;
        _status = 'Permissão de localização necessária.';
      });
      return;
    }

    final pos = await _location.getCurrentLocation();
    if (pos == null) {
      setState(() {
        _loading = false;
        _status = 'Não foi possível obter a localização.';
      });
      return;
    }

    final uid = widget.uid;
    if (uid == null) {
      setState(() {
        _loading = false;
        _status = 'UID ausente.';
      });
      return;
    }

    try {
      await _firebase.savePonto(
        uid: uid,
        latitude: pos.latitude,
        longitude: pos.longitude,
        timestamp: DateTime.now(),
      );
      setState(() {
        _status = 'Ponto registrado com sucesso!';
      });
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Ponto salvo.')));
      }
    } catch (e) {
      setState(() => _status = 'Erro ao salvar ponto: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _nomeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Se recebeu uid -> modo "Registrar Ponto Manual"
    if (widget.uid != null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Registrar Ponto (Manual)")),
        body: Center(
          child: _loading
              ? const CircularProgressIndicator()
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: _registrarPontoManual,
                      child: const Text("Registrar Ponto Agora"),
                    ),
                    const SizedBox(height: 12),
                    Text(_status),
                  ],
                ),
        ),
      );
    }

    // Caso contrário -> modo "Criar Usuário"
    return Scaffold(
      appBar: AppBar(title: const Text("Criar Conta")),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nomeCtrl,
                  decoration:
                      const InputDecoration(labelText: 'Nome / NIF (opcional)'),
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _emailCtrl,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Informe email' : null,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _passCtrl,
                  decoration: const InputDecoration(labelText: 'Senha'),
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  validator: (v) =>
                      (v == null || v.length < 6) ? 'Senha mínimo 6 caracteres' : null,
                ),
                const SizedBox(height: 16),
                _loading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _registrarUsuario,
                        child: const Text('Registrar'),
                      ),
                const SizedBox(height: 12),
                Text(_status, style: const TextStyle(color: Colors.red)),
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Voltar ao login')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
