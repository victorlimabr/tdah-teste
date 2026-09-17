import '../../data/services/url_launcher_service.dart';

/// ViewModel da tela "Encontrar profissionais".
///
/// Monta as URLs de busca/diretórios e delega a abertura ao
/// [UrlLauncherService]. Cada command devolve `true` se a abertura funcionou.
class ProfessionalsViewModel {
  ProfessionalsViewModel(this._launcher);

  final UrlLauncherService _launcher;

  /// Contato de apoio emocional (CVV).
  static const supportPhone = '188';

  /// Abre o mapa buscando a especialidade perto do usuário.
  Future<bool> searchNearby(String specialty) {
    final query = Uri.encodeComponent('$specialty perto de mim');
    return _launcher.open(
      Uri.parse('https://www.google.com/maps/search/?api=1&query=$query'),
    );
  }

  /// Abre um diretório oficial (site externo).
  Future<bool> openDirectory(String url) => _launcher.open(Uri.parse(url));

  /// Liga para o apoio emocional (CVV 188).
  Future<bool> callSupport() =>
      _launcher.open(Uri.parse('tel:$supportPhone'));
}
