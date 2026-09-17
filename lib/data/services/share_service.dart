import 'package:share_plus/share_plus.dart';

/// Abstrai o compartilhamento de texto (folha nativa do sistema), para que a
/// lógica possa ser testada sem depender do plugin.
abstract class ShareService {
  Future<void> share(String text);
}

/// Implementação padrão usando `share_plus`.
class SharePlusShareService implements ShareService {
  @override
  Future<void> share(String text) => Share.share(text);
}
