// Teste de Conversão de JSON para <-> Dart

import 'dart:convert';  

void main(){
  //Tenho um texto em formato JSON
  String UsuarioJson = '''{
                            "id": "1ab2",
                            "user": "usuario1",
                            "nome": "Pedro",
                            "idade": 25,
                            "cadastrado": true
                      }''';
//para manipular o texto
//coversão de JSON para Map
  Map<String,dynamic> usuario = json.decode(UsuarioJson);
  //manipulação informações do JSoN
  print(usuario["idade"]);
  usuario["idade"] = 26;
  //converter Map para JSON
  UsuarioJson = json.encode(usuario);
  //temho novamente o texto em formato de texto 
  print(UsuarioJson);

  
}