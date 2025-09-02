import 'dart:convert';

import 'package:http/http.dart' as http;
//classe para auxiliar nas chamadas da api

class ApiService {
  //atributos e métodos da Classe e não do Obj
  // base URL para Conexão API
  //static -> transforma o atributo em atributo da classe não do obj
  static const String _baseUrl = "http://10.109.197.13:3020";

  //métodos
  //GET (Listar todos os Recurso)
  static Future<List<dynamic>> getList(String path) async{
    final res = await http.get(Uri.parse("$_baseUrl/$path")); //uri -> convert string -> URL
    if(res.statusCode == 200) return json.decode(res.body); 
    //se não deu certo -> gerar um erro 
    throw Exception("Falha ao carregar lista de $path");
  }

  //GET (Listar um Unico Recurso)
  static Future<Map<String,dynamic>> getOne(String path, String id) async{ 
    final res = await http.get(Uri.parse("$_baseUrl/$path/$id")); //uri -> convert string -> URL
    if(res.statusCode == 200) return json.decode(res.body); 
    //se não deu certo -> gerar um erro 
    throw Exception("Falha ao carregar recurso $path");     
    
  }

  //POST ( Criar novo Recurso)
  static Future<Map<String,dynamic>> post(String path, Map<String,dynamic> body) async{
    final res = await http.post(
      Uri.parse("$_baseUrl/$path"),
      headers: {"Content-Type":"application/json"}, 
      body: json.encode(body)
    ); 
    if(res.statusCode == 201) return json.decode(res.body); 
    //se não deu certo -> gerar um erro  
    throw Exception("Falha ao criar recurso $path");     
  }

  //PUT (Atualizar Recurso)
  static Future<Map<String,dynamic>> put(String path, String id, Map<String,dynamic> body) async{
    final res = await http.put(
      Uri.parse("$_baseUrl/$path/$id"),  
      headers: {"Content-Type":"application/json"},
      body: json.encode(body) 
    ); 
    if(res.statusCode == 200) return json.decode(res.body);   
    //se não deu certo -> gerar um erro  
    throw Exception("Falha ao alterar recurso $path");      
  }
  //DELETE (Apagar Recurso)
  static delete(String path, String id) async{
    final res = await http.delete(Uri.parse("$_baseUrl/$path/$id"));
    if ( res.statusCode != 200) throw Exception("Falha ao Deletar Recurso $path");
  }
}