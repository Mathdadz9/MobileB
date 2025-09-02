import 'package:flutter/material.dart';

// Modelo de Livro
class LivroModel {
  String id;
  String titulo;
  String autor;
  bool disponivel;

  LivroModel({
    required this.id,
    required this.titulo,
    required this.autor,
    this.disponivel = true,
  });
}

// Tela de formulário de Livro
class LivroFormView extends StatefulWidget {
  final LivroModel? livro;

  const LivroFormView({super.key, this.livro});

  @override
  State<LivroFormView> createState() => _LivroFormViewState();
}

class _LivroFormViewState extends State<LivroFormView> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _autorController = TextEditingController();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    if (widget.livro != null) {
      _tituloController.text = widget.livro!.titulo;
      _autorController.text = widget.livro!.autor;
    }
  }

  void _salvar() {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    final novoLivro = LivroModel(
      id: widget.livro?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      titulo: _tituloController.text.trim(),
      autor: _autorController.text.trim(),
      disponivel: widget.livro?.disponivel ?? true,
    );

    // Aqui você faria a chamada ao controller / backend
    // Simulação de delay
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() => _loading = false);
      Navigator.pop(context, novoLivro);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.livro == null ? "Novo Livro" : "Editar Livro"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _tituloController,
                decoration: const InputDecoration(
                  labelText: "Título",
                  prefixIcon: Icon(Icons.book),
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? "Informe o título" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _autorController,
                decoration: const InputDecoration(
                  labelText: "Autor",
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? "Informe o autor" : null,
              ),
              const SizedBox(height: 24),
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
                      : Icon(widget.livro == null ? Icons.save : Icons.update),
                  label: Text(widget.livro == null ? "Salvar" : "Atualizar"),
                  onPressed: _loading ? null : _salvar,
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

// Tela de lista de livros
class LivrosListView extends StatefulWidget {
  const LivrosListView({super.key});

  @override
  State<LivrosListView> createState() => _LivrosListViewState();
}

class _LivrosListViewState extends State<LivrosListView> {
  List<LivroModel> _livros = [];
  List<LivroModel> _livrosFiltrados = [];
  final TextEditingController _buscarController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadLivros();
  }

  void _loadLivros() {
    // Aqui você buscaria os livros do backend / controller
    // Simulando alguns livros
    _livros = [
      LivroModel(id: "1", titulo: "O Senhor dos Anéis", autor: "J.R.R. Tolkien"),
      LivroModel(id: "2", titulo: "Harry Potter", autor: "J.K. Rowling"),
      LivroModel(id: "3", titulo: "1984", autor: "George Orwell"),
    ];
    _livrosFiltrados = List.from(_livros);
    setState(() {});
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
        content: Text("Deseja realmente excluir o livro '${livro.titulo}'?"),
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
      _livros.removeWhere((l) => l.id == livro.id);
      _filtrar();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Livro '${livro.titulo}' deletado!")));
    }
  }

  Future<void> _openForm({LivroModel? livro}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => LivroFormView(livro: livro)),
    );

    if (result != null && result is LivroModel) {
      if (livro != null) {
        // editar
        final index = _livros.indexWhere((l) => l.id == livro.id);
        if (index != -1) _livros[index] = result;
      } else {
        // adicionar
        _livros.add(result);
      }
      _filtrar();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Livros"),
        centerTitle: true,
      ),
      body: Column(
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
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => _openForm(livro: livro),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
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
