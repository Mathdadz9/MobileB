import '../models/usuario_model.dart';
import '../services/api_service.dart';

class UsuarioController {
  get usuario => null;

  //metedos do controller

  //GET
  Future<List<UsuarioModel>> fetchAll() async { 
    final list = await ApiService.getList("usuarios?_sort=nome"); //?_sort=nome -> ordenar por nome
    return list.map<UsuarioModel>((item) =>UsuarioModel.fromJson(item)).toList();  
  }

  //getone 
  Future<UsuarioModel> fetchOne(String id) async { 
    final usuario = await ApiService.getOne("usuarios", id);
    return UsuarioModel.fromJson(usuario);  
  } 

  //POST
  Future<UsuarioModel> create(UsuarioModel usuario) async { 
    final created = await ApiService.post("usuarios", usuario.toJson());
    return UsuarioModel.fromJson(created);  
  } 

  //PUT
   Future<UsuarioModel> update(UsuarioModel u) async{
    final updated = await ApiService.put("usuarios", usuario.toJson(), usuario.id!);
  
    return UsuarioModel.fromJson(updated); 
  }   

  //DELETE
  Future<void> delete(String id) async{ 
    await ApiService.delete("usuarios", id); 
    // não retorna nada
  }  

}  