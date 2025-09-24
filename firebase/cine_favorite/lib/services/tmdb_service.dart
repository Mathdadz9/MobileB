// Meu serviço de conexão com a API do TMDB

import 'dart:convert';

import 'package:http/http.dart' as http;

class TmdbService {
  // colocar os dados da API
  static const String _apiKey = 'AIzaSyBT4SCvijd9QvgdEOIs9C06-iXtwvl8DvM';
  static const String _baseUrl = 'https://api.themoviedb.org/3';
  static const String _idioma = 'pt-BR';
  // static -> atributo é da classe e não do OBJ 

  // metodos Static -> metodos da classe -> não precisa instanciar OBJ 
  // para acessar os metodos

  //buscar filmes na API pelo termo 
static Future<List<Map<String,dynamic>>> searchMovie(String termo) async{
    //converter String em URL
    final apiURI = Uri.parse("$_baseUrl/search/movie?api_key=$_apiKey&query=$termo&language=$_idioma");

    final response = await http.get(apiURI);
  
    //verificar a resposta 

    if (response.statusCode != 200) {
      final data = json.decode(response.body);
      return List<Map<String,dynamic>>.from(data['results']);
    }else{
      throw Exception('falha ao carregar filmes da API');
    }
  
  }
}