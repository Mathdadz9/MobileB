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

class LivrosFormView extends StatefulWidget {
  final LivroModel? livro; // Pode ser nulo, se for criar novo

  const LivrosFormView({super.key, this.livro});

  @override
  State<LivrosFormView> createState() => _LivrosFormViewState();
}

class _LivrosFormViewState extends State<LivrosFormView> {
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

  // Salvar ou atualizar livro
  void _salvar() {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    final novoLivro = LivroModel(
      id: widget.livro?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      titulo: _tituloController.text.trim(),
      autor: _autorController.text.trim(),
      disponivel: widget.livro?.disponivel ?? true,
    );

    // Aqui você chamaria o controller / backend
    // Simulando delay
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() => _loading = false);
      Navigator.pop(context, novoLivro); // Retorna o livro para lista
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              widget.livro == null ? "Livro criado!" : "Livro atualizado!"),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.livro == null ? "Novo Livro" : "Editar Livro"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Campo Título
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
              // Campo Autor
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
              // Botão Salvar / Atualizar
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
