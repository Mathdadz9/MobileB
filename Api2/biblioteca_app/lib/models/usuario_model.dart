class UsuarioModel {
  final String? id; //pode ser nulo inicialmente
  final String nome;
  final String email; 
  
  //construtor 
  UsuarioModel({this.id, 
  required this.nome, 
  required this.email
  }); 

  //metodos 
  
  //toJson -> Map<String,dynamic>
  Map<String,dynamic> toJson() => {
      "id": id,
      "nome": nome,
      "email": email
    }; 
  //fromJson -> Map<String,dynamic>
    factory UsuarioModel.fromJson(Map<String,dynamic> json) => UsuarioModel(
      id: json["id"].toString(), //converte para String
      nome: json["nome"].toString(),
      email: json["email"].toString()
    );  
  
}