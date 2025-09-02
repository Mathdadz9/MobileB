
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: MyApp()));
}

//class de janela
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  //construtor de widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Exemplo Widget de Exibição")),
      body: Center(
        child: Column(
          children: [
            Text(
              "Exemplo de Texto",
              style: TextStyle(fontSize: 20, color: Colors.blue),
            ),
            Text(
              "Texto Personalizado",
              style: TextStyle(
                fontSize: 24,
                color: Colors.red,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                wordSpacing: 2,
                decoration: TextDecoration.underline,
              ),
            ),
            //icones
            Icon(Icons.star, size: 50, color: Colors.amber),
            IconButton(
              onPressed: () => print("Icone Pressionado"),
              icon: Icon(Icons.add_a_photo),
              iconSize: 50,
            ),
            //imagens
            Image.network(
              "https://imgs.search.brave.com/CC8W9XsuxwKAXOHzJTH6jSX2AsT75UBctnpdurAByOE/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9pbWFn/ZXMubmlnaHRjYWZl/LnN0dWRpby9qb2Jz/L3BuMm5hMkxhSlZX/ZlBKYUJ5VmIxL3Bu/Mm5hMkxhSlZXZlBK/YUJ5VmIxLS0xLS1t/OTJpdC5qcGc_dHI9/dy0xNjAwLGMtYXRf/bWF4",
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),
            Image.asset(
              "assets/img/image.png",
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),
            //Box Exibição de Imagem
            Row(
              children: [
                ClipOval(
                  child: Image.asset(
                    "assets/img/image.png",
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    "assets/img/image.png",
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
