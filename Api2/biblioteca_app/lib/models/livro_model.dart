class LivroModel {
  final String id;
  final String titulo;
  final String autor;
  final bool disponivel;

  // Construtor
  LivroModel({
     required this.id,
    required this.titulo,
    required this.autor,
    required this.disponivel,
  });


  // Método para converter para JSO
    Map<String,dynamic> toJson() =>{
    "id":id,
    "titulo":titulo,
    "autor":autor,
    "dispinivel":disponivel
  };

  factory LivroModel.fromJson(Map<String, dynamic>json) => LivroModel(
    id: json["id"].toString(),
    titulo: json["titulo"].toString(), 
    autor: json["autor"].toString(), 
    disponivel: json["disponivel"] == true ? true : false); // operador ternario para corrigir a boolean

}