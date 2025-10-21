import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'view/login_view.dart';
import 'view/ponto_view.dart';
import 'firebase_options.dart'; // gerado pelo flutterfire configure

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'sa_repogeobi',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/login',
      routes: {
        '/login': (_) => const LoginView(),
        '/ponto': (_) => const PontoView(),
      },
    );
  }
}
