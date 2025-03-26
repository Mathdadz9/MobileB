import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: const TextTheme(),
      ),
      home: const ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text('Perfil', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, size: 28),
            onPressed: () {},
          ),
          const SizedBox(width: 16),
          IconButton(
            icon: const Icon(Icons.settings, size: 28),
            onPressed: () {},
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: ListView(  // ListView já garante a rolagem automática
        padding: const EdgeInsets.all(16.0),
        children: [
          // Imagem de perfil com Container
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Colors.blueAccent, Colors.purple],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4)),
                  ],
                ),
                child: ClipOval(
                  child: Image.network(
                    'https://imgs.search.brave.com/wyAJc45k7-dFgNniS1wZtqx_-wvMQehfS_OUIQjSJOE/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9wbTEu/YW1pbm9hcHBzLmNv/bS82ODgwL2M2ZWMw/NzhkYTcwY2U5MmNk/MjEyOTI4ODY2MDli/NjYwMzI0MzlkZGNy/MS04MDAtMTAwM3Yy/X2hxLmpwZw', // Link da imagem do perfil
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 2)),
                    ],
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Nome e Descrição
          const Text(
            'Matheus Crippa',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.deepPurple),
          ),
          const Text(
            'Desenvolvedor de Sistemas | Apaixonado por Jogos',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 20),

          // Contadores de seguidores, seguidos e publicações
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildStatColumn('12K', 'Seguidores'),
              const SizedBox(width: 40),
              _buildStatColumn('120', 'Seguindo'),
              const SizedBox(width: 40),
              _buildStatColumn('3', 'Publicação'),
            ],
          ),
          const SizedBox(height: 20),

          // Feed de posts
          const Text(
            'Feed de Posts',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.deepPurple),
          ),
          const SizedBox(height: 16),

          // Lista de Posts
          _buildPost(
            context,
            'https://imgs.search.brave.com/yh-rutX40bjDq04CdAm1BL6BN7NuVnoHwQA2JEmuy9M/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly93YWxs/cGFwZXJjYXZlLmNv/bS93cC9nczBDQ3RH/LmpwZw',
            'Mais Gato q eu? NUNCA',
            '😘😘',
          ),
          const SizedBox(height: 16),
          _buildPost(
            context,
            'https://imgs.search.brave.com/khsYcfOllFpic7E4olDGu1sWJ3463OxZt9auWFCGWEU/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly93d3cu/bGF2YW5ndWFyZGlh/LmNvbS9wZWxpY3Vs/YXMtc2VyaWVzL2lt/YWdlcy9hbGwvc2Vy/aWUvYmFja2Ryb3Bz/LzE5OTcvNy9zZXJp/ZS0yNDA1L3cxMjgw/L3lqbWVtT1pJa3Nr/a1k1ZktSbEk4VlR2/Q0VTQi5qcGc',
            'Prazer Gato das mulheres! MIAU😘',
            'O Homem mais lindo!',
          ),
          const SizedBox(height: 16),

           _buildPost(
            context,
            'https://imgs.search.brave.com/lBX_-bgOlUEVQA2eynBGGrDuvV9sP1wIXfRGxCbWNOk/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly93d3cu/bGF2YW5ndWFyZGlh/LmNvbS9wZWxpY3Vs/YXMtc2VyaWVzL2lt/YWdlcy9hbGwvc2Vy/aWUvYmFja2Ryb3Bz/LzE5OTcvNy9zZXJp/ZS0yNDA1L3cxMjgw/LzhuZHUzd3ZmV200/dkhqSXRHYVdRUnlj/YlVXSC5qcGc',
            'Até caindo sou Lindo',
            '',
          ),
          const SizedBox(height: 16),

          // BottomNavigationBar
          BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home, size: 30),
                label: 'Início',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search, size: 30),
                label: 'Buscar',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person, size: 30),
                label: 'Perfil',
              ),
            ],
            backgroundColor: Colors.deepPurple,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white70,
          ),
        ],
      ),
    );
  }

  // Método para criar as colunas de estatísticas (seguidores, seguindo, publicações)
  Widget _buildStatColumn(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.deepPurple),
        ),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }

  // Método para criar o card de post
  Widget _buildPost(BuildContext context, String imageUrl, String title, String description) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      shadowColor: Colors.black54,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              imageUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              description,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.thumb_up_alt_outlined),
                onPressed: () {},
                color: Colors.blue,
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.comment_outlined),
                onPressed: () {},
                color: Colors.blue,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
