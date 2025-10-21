# 📝 Relatório de Implementação 

## Funcionalidades Desenvolvidas

O aplicativo foi construído para simular um sistema de **registro de ponto presencial com base em geolocalização**, oferecendo:

- **Cadastro e autenticação** de usuários por e-mail (ou NIF) e senha  
- **Registro automático de ponto** com captura de data, hora e coordenadas geográficas via GPS  
- **Histórico em tempo real** dos registros, atualizado dinamicamente conforme novos pontos são registrados  

A arquitetura adota o padrão **MVC (Model-View-Controller)**, com:
- **Views**: telas de interface (`LoginView`, `RegisterView`, `HomeView`, `HistoryView`)
- **Controllers**: classes responsáveis pela lógica (`AuthController`, `PointController`)
- **Model**: dados gerenciados pelo **Firebase** (Authentication e Firestore)

---

## Integração com Firebase

O projeto utiliza três serviços principais do Firebase:

1. **Firebase Authentication** – para gerenciar login e cadastro de forma segura  
2. **Cloud Firestore** – para armazenar cada registro de ponto com `userId`, latitude, longitude e timestamp  
3. **Firebase Core** – como camada base para inicialização do SDK nas plataformas Android e iOS  

A configuração foi realizada com o comando `flutterfire configure`, que gera automaticamente o arquivo `lib/firebase_options.dart` com as credenciais específicas de cada plataforma.

---

## Desafio Técnico: Configuração do Firebase

O maior desafio foi garantir uma **integração estável e funcional com o Firebase**, envolvendo:

- Posicionar corretamente os arquivos de configuração (`google-services.json` no Android)  
- Ativar os serviços necessários no **Firebase Console**:  
  - Método de login por **e-mail/senha** no Authentication  
  - Banco de dados **Firestore em modo de teste** (apenas para desenvolvimento)  
- Garantir a inicialização correta do SDK com:  
  ```dart
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
---


# 📄 Documentação  

## 📱 Instruções de Uso

### Fluxo do usuário

#### **Tela de Login**
- Informe seu e-mail (ou NIF) e senha  
- Clique em **"Entrar"**  
- Não possui conta? Clique em **"Criar Conta"**

#### **Tela de Cadastro**
- Preencha e-mail e senha (mínimo 6 caracteres)  
- Clique em **"Criar Conta"**  
- Após confirmação, você será redirecionado automaticamente para a tela de login

#### **Tela Principal**
- Toque em **"Registrar Ponto"**  
- Aceite a solicitação de permissão de localização  
- Um aviso de sucesso será exibido na tela

#### **Histórico de Pontos**
- Clique no botão flutuante (ícone de relógio)  
- Visualize todos os seus registros com:  
  - **Data e hora exatas**  
  - **Coordenadas de latitude e longitude**

---

## 🔒 Observações Importantes

- **Atualização em tempo real**: o histórico é sincronizado automaticamente com o Firestore.  
- **Localização obrigatória**: o registro de ponto falhará se a permissão de localização for negada.  
- **Modo de teste**: o Firestore está configurado para desenvolvimento — **não use em produção sem definir regras de segurança adequadas**.  
- **Identidade visual**: interface com paleta de cores verde musgo (`#4A6B3F`) e fundo branco, seguindo princípios de usabilidade e acessibilidade.

---

## 📁 Estrutura do Código (MVC)

- **Model**:  
  Dados provenientes do Firebase Auth e Firestore (usuários, registros de ponto)

- **View**:  
  Telas independentes de lógica:  
  `LoginView`, `RegisterView`, `HomeView`, `HistoryView`

- **Controller**:  
  Classes de serviço que encapsulam a lógica de negócio:  
  - `AuthController` → responsável por login e cadastro  
  - `PointController` → responsável pelo registro de ponto com geolocalização