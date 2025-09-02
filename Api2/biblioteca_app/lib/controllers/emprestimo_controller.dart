import '../models/emprestimo_model.dart';
import '../services/api_service.dart';

class EmprestimoController {
  get emprestimo => null;

  // Métodos do controller

  // GET
  Future<List<EmprestimoModel>> fetchAll() async {
    final list = await ApiService.getList("emprestimos?_sort=data");
    return list.map<EmprestimoModel>((item) => EmprestimoModel.fromJson(item)).toList();
  }

  // GET one
  Future<EmprestimoModel> fetchOne(String id) async {
    final emprestimo = await ApiService.getOne("emprestimos", id);
    return EmprestimoModel.fromJson(emprestimo);
  }

  // POST
  Future<EmprestimoModel> create(EmprestimoModel emprestimo) async {
    final created = await ApiService.post("emprestimos", emprestimo.toJson());
    return EmprestimoModel.fromJson(created);
  }

  // PUT
  Future<EmprestimoModel> update(EmprestimoModel e) async {
    final updated = await ApiService.put("emprestimos", emprestimo.toJson(), emprestimo.id!);
    return EmprestimoModel.fromJson(updated);
  }

  // DELETE
  Future<void> delete(String id) async {
    await ApiService.delete("emprestimos", id);
  }
}