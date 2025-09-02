import 'package:biblioteca_app/controllers/usuario_controller.dart';
import 'package:biblioteca_app/models/usuario_model.dart';
import 'package:flutter/material.dart';

class UsuarioFormView extends StatefulWidget {
  final UsuarioModel? user;

  const UsuarioFormView({super.key, this.user});

  @override
  State<UsuarioFormView> createState() => _UsuarioFormViewState();
}

class _UsuarioFormViewState extends State<UsuarioFormView> {
  final _formKey = GlobalKey<FormState>();
  final _controller = UsuarioController();
  final _nomeField = TextEditingController();
  final _emailField = TextEditingController();
  bool _loading = false; // para mostrar loading no botão

  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      _nomeField.text = widget.user!.nome;
      _emailField.text = widget.user!.email;
    }
  }

  // Criar usuário
  Future<void> _criar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    final novoUsuario = UsuarioModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      nome: _nomeField.text.trim(),
      email: _emailField.text.trim(),
    );

    try {
      await _controller.create(novoUsuario);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Usuário criado com sucesso!")),
      );
      Navigator.pop(context, true); // retorna true para atualizar lista
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao criar usuário: $e")),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  // Atualizar usuário
  Future<void> _atualizar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    final usuarioAtualizado = UsuarioModel(
      id: widget.user!.id,
      nome: _nomeField.text.trim(),
      email: _emailField.text.trim(),
    );

    try {
      await _controller.update(usuarioAtualizado);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Usuário atualizado com sucesso!")),
      );
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao atualizar usuário: $e")),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user == null ? "Novo Usuário" : "Editar Usuário"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Campo Nome
              TextFormField(
                controller: _nomeField,
                decoration: const InputDecoration(
                  labelText: "Nome",
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? "Informe o nome" : null,
              ),
              const SizedBox(height: 16),
              // Campo Email
              TextFormField(
                controller: _emailField,
                decoration: const InputDecoration(
                  labelText: "Email",
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Informe o email";
                  }
                  // validação simples de email
                  final emailRegex =
                      RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
                  if (!emailRegex.hasMatch(value)) {
                    return "Informe um email válido";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              // Botão Salvar/Atualizar
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  icon: _loading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Icon(widget.user == null ? Icons.save : Icons.update),
                  label: Text(widget.user == null ? "Salvar" : "Atualizar"),
                  onPressed: _loading
                      ? null
                      : widget.user == null
                          ? _criar
                          : _atualizar,
                  style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
