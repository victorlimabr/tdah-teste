import 'question.dart';

/// Resultado calculado a partir das respostas do questionário.
class QuizResult {
  const QuizResult({
    required this.partAShaded,
    required this.totalShaded,
    required this.inattentionScore,
    required this.hyperactivityScore,
  });

  /// Quantas das 6 perguntas da Parte A caíram na área sombreada.
  final int partAShaded;

  /// Quantas das 18 perguntas caíram na área sombreada.
  final int totalShaded;

  /// Soma dos valores (0-4) das perguntas de desatenção.
  final int inattentionScore;

  /// Soma dos valores (0-4) das perguntas de hiperatividade/impulsividade.
  final int hyperactivityScore;

  static const int partAThreshold = 4;

  /// Pontuação máxima possível de desatenção (9 perguntas x 4).
  static const int maxInattention = 9 * 4;

  /// Pontuação máxima possível de hiperatividade (9 perguntas x 4).
  static const int maxHyperactivity = 9 * 4;

  /// Rastreio positivo: 4 ou mais marcações na área sombreada da Parte A.
  bool get isScreenPositive => partAShaded >= partAThreshold;

  /// Calcula o resultado a partir das perguntas e das respostas.
  ///
  /// [answers] é indexado por `pergunta.number - 1`, cada posição com o
  /// índice (0-4) da opção escolhida, ou `null` se não respondida
  /// (tratada como 0).
  factory QuizResult.fromAnswers(
    List<Question> questions,
    List<int?> answers,
  ) {
    var partAShaded = 0;
    var totalShaded = 0;
    var inattention = 0;
    var hyperactivity = 0;

    for (final question in questions) {
      final value = answers[question.number - 1] ?? 0;
      final isShaded = value >= question.shadedFrom;

      if (isShaded) {
        totalShaded++;
        if (question.isPartA) partAShaded++;
      }

      switch (question.type) {
        case SymptomType.inattention:
          inattention += value;
        case SymptomType.hyperactivity:
          hyperactivity += value;
      }
    }

    return QuizResult(
      partAShaded: partAShaded,
      totalShaded: totalShaded,
      inattentionScore: inattention,
      hyperactivityScore: hyperactivity,
    );
  }
}
