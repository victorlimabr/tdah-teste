import 'package:url_launcher/url_launcher.dart';

/// Abstrai a abertura de URLs externas (mapa, sites, telefone), para que a
/// lógica de negócio possa ser testada sem depender do plugin.
abstract class UrlLauncherService {
  Future<bool> open(Uri uri);
}

/// Implementação padrão usando o pacote `url_launcher`.
class DefaultUrlLauncherService implements UrlLauncherService {
  @override
  Future<bool> open(Uri uri) =>
      launchUrl(uri, mode: LaunchMode.externalApplication);
}
