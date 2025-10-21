import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;

  Future<UserModel?> login(String email, String senha) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: senha,
      );
      return UserModel(uid: cred.user!.uid, email: cred.user!.email!);
    } catch (e) {
      print("Erro ao logar: $e");
      return null;
    }
  }

  Future<UserModel?> registrar(String email, String senha) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );
      return UserModel(uid: cred.user!.uid, email: cred.user!.email!);
    } catch (e) {
      print("Erro ao registrar: $e");
      return null;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
