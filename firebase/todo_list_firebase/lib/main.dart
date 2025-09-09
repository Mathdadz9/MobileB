import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todo_list_firebase/firebase_options.dart';

import 'views/auth_widget.dart';

void main() async { 
  WidgetsFlutterBinding.ensureInitialized(); 
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, //garante a conexao somente com o android 

  );
  runApp(MaterialApp(
    title: "Lista de Tarefas Firebase",
    home: AuthWidget(), // widget que decide qual tela mostrar
  ));
}

