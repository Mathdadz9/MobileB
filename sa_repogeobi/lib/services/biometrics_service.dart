import 'package:local_auth/local_auth.dart';

class BiometricsService {
  final LocalAuthentication auth = LocalAuthentication();

  /// Verifica se o dispositivo suporta autenticação biométrica
  Future<bool> isBiometricAvailable() async {
    try {
      return await auth.canCheckBiometrics;
    } catch (e) {
      // evite prints em produção, mas útil para debug local
      // print('Erro ao verificar biometria: $e');
      return false;
    }
  }

  /// Retorna a lista de tipos de biometria disponíveis (impressão digital, face, etc)
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await auth.getAvailableBiometrics();
    } catch (e) {
      // print('Erro ao obter biometria disponível: $e');
      return <BiometricType>[];
    }
  }

  /// Chamada mínima compatível com várias versões do plugin
  Future<bool> authenticate() async {
    try {
      return await auth.authenticate(
        localizedReason: 'Autentique-se para acessar o app',
      );
    } catch (e) {
      // print('Erro na autenticação: $e');
      return false;
    }
  }

  /// Método em português usado pelo restante do projeto
  Future<bool> autenticar() async {
    return await authenticate();
  }
}
