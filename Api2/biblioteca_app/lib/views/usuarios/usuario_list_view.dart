import 'package:biblioteca_app/controllers/usuario_controller.dart';
import 'package:biblioteca_app/models/usuario_model.dart';
import 'package:biblioteca_app/views/usuarios/usuario_form_view.dart';
import 'package:flutter/material.dart';

class UsuarioListView extends StatefulWidget {
  const UsuarioListView({super.key});

  @override
  State<UsuarioListView> createState() => _UsuarioListViewState();
}

class _UsuarioListViewState extends State<UsuarioListView> {
  final TextEditingController _buscarField = TextEditingController();
  List<UsuarioModel> _usuarios = [];
  List<UsuarioModel> _usuariosFiltrados = [];
  final UsuarioController _controller = UsuarioController();
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  // Carrega usuários
  Future<void> _load() async {
    setState(() => _carregando = true);
    try {
      _usuarios = await _controller.fetchAll();
      _usuariosFiltrados = _usuarios;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao carregar usuários: $e")),
      );
    } finally {
      setState(() => _carregando = false);
    }
  }

  // Filtra usuários
  void _filtrar() {
    final query = _buscarField.text.toLowerCase();
    setState(() {
      _usuariosFiltrados = _usuarios.where((user) {
        return user.nome.toLowerCase().contains(query) ||
            user.email.toLowerCase().contains(query);
      }).toList();
    });
  }

  // Deleta usuário com confirmação
  Future<void> _delete(UsuarioModel user) async {
    if (user.id == null) return;

    final confirmado = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Confirma Exclusão"),
        content: Text("Deseja realmente deletar o usuário ${user.nome}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Excluir", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmado == true) {
      try {
        await _controller.delete(user.id!);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Usuário ${user.nome} deletado!")),
        );
        _load();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro ao deletar usuário: $e")),
        );
      }
    }
  }

  // Abre o formulário para criar/editar usuário
  Future<void> _openForm({UsuarioModel? user}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => UsuarioFormView(user: user)),
    );

    // Atualiza a lista se houve modificação
    if (result == true) {
      _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Usuários"),
        centerTitle: true,
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Campo de busca estilizado
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    controller: _buscarField,
                    onChanged: (value) => _filtrar(),
                    decoration: InputDecoration(
                      hintText: "Pesquisar usuário...",
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: _usuariosFiltrados.isEmpty
                      ? const Center(
                          child: Text(
                            "Nenhum usuário encontrado",
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: _usuariosFiltrados.length,
                          itemBuilder: (context, index) {
                            final usuario = _usuariosFiltrados[index];
                            return Card(
                              elevation: 3,
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              child: ListTile(
                                leading: const CircleAvatar(
                                  child: Icon(Icons.person),
                                ),
                                title: Text(usuario.nome),
                                subtitle: Text(usuario.email),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit,
                                          color: Colors.blue),
                                      onPressed: () => _openForm(user: usuario),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
                                      onPressed: () => _delete(usuario),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
