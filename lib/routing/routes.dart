/// Caminhos das rotas do app (fonte única, sem dependências).
abstract class Routes {
  static const catalog = '/tests';
  static const intro = '/intro';
  static const respondent = '/respondent';
  static const result = '/result';
  static const professionals = '/professionals';

  /// Rota de uma seção do teste (0-based).
  static String quizSection(int index) => '/quiz/$index';

  /// Rota da transição após concluir a seção [index].
  static String transitionAfter(int index) => '/transition/$index';
}
