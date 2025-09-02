class EmprestimoModel {
final String? id;
final  String? idLivro;
final String? idUsuario;
final  String? dataEmprestimo;
final  String? dataDevolucao;

  // Construtor
  EmprestimoModel({
    this.id,
    this.idLivro,
    this.idUsuario,
    this.dataEmprestimo,
    this.dataDevolucao,
  });

  // Criar a partir de JSON
 

  // Converter para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idLivro': idLivro,
      'idUsuario': idUsuario,
      'dataEmprestimo': dataEmprestimo,
      'dataDevolucao': dataDevolucao,
    };
  }

  factory EmprestimoModel.fromJson(Map<String, dynamic> json) {
    return EmprestimoModel(
      id: json['id'] as String?,
      idLivro: json['idLivro'] as String?,
      idUsuario: json['idUsuario'] as String?,
      dataEmprestimo: json['dataEmprestimo'] as String?,
      dataDevolucao: json['dataDevolucao'] as String?,
    );
  }

}