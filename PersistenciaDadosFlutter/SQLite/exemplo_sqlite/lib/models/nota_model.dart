class Nota{
  //atributos = colunas BD
  final int? id;
  final String titulo;
  final String conteudo;

  //construtor
  Nota({this.id, required this.titulo, required this.conteudo});

  //métodos

  //  BD

  // toMap Objeto => BD
  Map<String,dynamic> toMap(){
    return{
      "id":id, 
      "titulo":titulo,
      "conteudo":conteudo
    };
  }

  //fromMap BD => Objeto
  factory Nota.fromMap(Map<String,dynamic> map){
    return Nota(
      id: map["id"] as int,
      titulo: map["titulo"] as String,
      conteudo: map["conteudo"] as String,

    );
  }
}