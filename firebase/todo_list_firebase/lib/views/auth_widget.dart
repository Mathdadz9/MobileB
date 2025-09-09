//widget de autenticação de usuario =-> direcionar o usuário logado para as telas de navegação

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login_view.dart';
import 'tarefas_view.dart';

class AuthWidget extends StatelessWidget {
  const AuthWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(//  
     stream: FirebaseAuth.instance.authStateChanges(),//stream que monitora o estado de autenticação do usuário  
      builder: (context, snapshot) {
        if(snapshot.hasData){
          return TarefasView(); //se o usuário estiver logado, direciona para a tela de tarefas
        }
        return LoginView(); //se o usuário não estiver logado, direciona para a tela de login

      });
  }
}