import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<UserCredential> signIn(String email, String password) =>
      _auth.signInWithEmailAndPassword(email: email, password: password);

  Future<void> signOut() => _auth.signOut();

  Future<void> savePonto({
    required String uid,
    required double latitude,
    required double longitude,
    required DateTime timestamp,
  }) {
    final doc = _db.collection('pontos').doc();
    return doc.set({
      'uid': uid,
      'latitude': latitude,
      'longitude': longitude,
      // salva como Timestamp do Firestore para facilitar ordenação/consulta
      'timestamp': Timestamp.fromDate(timestamp.toUtc()),
    });
  }

  /// Retorna stream dos registros do usuário ordenados por timestamp desc
  Stream<QuerySnapshot> listarRegistros(String uid) {
    return _db
        .collection('pontos')
        .where('uid', isEqualTo: uid)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}