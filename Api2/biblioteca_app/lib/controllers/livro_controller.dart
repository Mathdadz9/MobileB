import 'package:biblioteca_app/views/livros/livros_list_view.dart' hide LivroModel;
import 'package:flutter/material.dart';
import '../controllers/livro_controller.dart';
import '../models/livro_model.dart';


class LivrosListView extends StatefulWidget {
  const LivrosListView({super.key});

  @override
  State<LivrosListView> createState() => _LivrosListViewState();
}

class _LivrosListViewState extends State<LivrosListView> {
  final LivroController _controller = LivroController();
  List<LivroModel> _livros = [];
  List<LivroModel> _livrosFiltrados = [];
  final TextEditingController _buscarController = TextEditingController();
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _loadLivros();
  }

  Future<void> _loadLivros() async {
    setState(() => _carregando = true);
    try {
      _livros = await _controller.fetchAll();
      _livrosFiltrados = List.from(_livros);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao carregar livros: $e")),
      );
    } finally {
      setState(() => _carregando = false);
    }
  }

  void _filtrar() {
    final query = _buscarController.text.toLowerCase();
    setState(() {
      _livrosFiltrados = _livros
          .where((l) =>
              l.titulo.toLowerCase().contains(query) ||
              l.autor.toLowerCase().contains(query))
          .toList();
    });
  }

  Future<void> _deletar(LivroModel livro) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Confirma Exclusão"),
        content: Text("Deseja realmente excluir '${livro.titulo}'?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text("Cancelar")),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text("Excluir", style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirmado == true) {
      try {
        await _controller.delete(livro.id);
        _loadLivros();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Livro '${livro.titulo}' deletado!")),
        );
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Erro ao deletar: $e")));
      }
    }
  }

  Future<void> _openForm({LivroModel? livro}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => LivroFormView(livro: livro)),
    );

    if (result != null && result is LivroModel) {
      try {
        if (livro != null) {
          await _controller.update(result);
        } else {
          await _controller.create(result);
        }
        _loadLivros();
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Erro: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Livros"), centerTitle: true),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    controller: _buscarController,
                    onChanged: (value) => _filtrar(),
                    decoration: InputDecoration(
                      hintText: "Pesquisar livro...",
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
                  child: _livrosFiltrados.isEmpty
                      ? const Center(
                          child: Text(
                            "Nenhum livro encontrado",
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: _livrosFiltrados.length,
                          itemBuilder: (context, index) {
                            final livro = _livrosFiltrados[index];
                            return Card(
                              elevation: 3,
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              child: ListTile(
                                leading: const CircleAvatar(
                                  child: Icon(Icons.book),
                                ),
                                title: Text(livro.titulo),
                                subtitle: Text(livro.autor),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon:
                                          const Icon(Icons.edit, color: Colors.blue),
                                      onPressed: () => _openForm(livro: livro),
                                    ),
                                    IconButton(
                                      icon:
                                          const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () => _deletar(livro),
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
