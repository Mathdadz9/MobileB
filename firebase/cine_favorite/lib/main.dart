import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'views/favorite_view.dart';
import 'views/login_view.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();


  //conectar com o firebase
  await Firebase.initializeApp();

  runApp(MaterialApp(
    title: "Cine Favorite",
    theme: ThemeData(
      primarySwatch: Colors.orange,
      brightness: Brightness.dark
    ),
    home: AuthStream(), // permite a navegação de tela de acordo com alguma decisão
  ));
}

class AuthStream extends StatelessWidget {
  const AuthStream({super.key});

  @override
  Widget build(BuildContext context) {
    //ouvinte da mudança de status (listener)
    return StreamBuilder<User?>(//permitir retorno null para usuário?
      //ouvinte da mudança de status do usuário
      stream: FirebaseAuth.instance.authStateChanges(),
      //identifica a mudança de status  do usuário(logado ou não) 
      builder: (context, snapshot){ //analisa o instantâneo da aplicação
        if(snapshot.hasData){
          return FavoriteView();
        }
        return LoginView();
      });
  }
}