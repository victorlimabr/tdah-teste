import '../data/asrs_questions.dart';
import 'question.dart';
import 'quiz_result.dart';

/// Mantém as respostas do usuário durante todo o fluxo do teste
/// (Parte A e Parte B), compartilhado entre as telas.
class QuizSession {
  QuizSession() : answers = List<int?>.filled(kQuestions.length, null);

  /// Resposta (índice 0-4) de cada pergunta, indexada por `number - 1`.
  final List<int?> answers;

  /// Perguntas da Parte A (rastreio).
  List<Question> get partA =>
      kQuestions.where((q) => q.part == 'A').toList(growable: false);

  /// Perguntas da Parte B (complementar).
  List<Question> get partB =>
      kQuestions.where((q) => q.part == 'B').toList(growable: false);

  int? answerFor(Question q) => answers[q.number - 1];

  void setAnswer(Question q, int value) => answers[q.number - 1] = value;

  /// Resultado apenas da Parte A (usado na tela de transição).
  bool get isPartAScreenPositive {
    var shaded = 0;
    for (final q in partA) {
      final v = answers[q.number - 1] ?? 0;
      if (v >= q.shadedFrom) shaded++;
    }
    return shaded >= QuizResult.partAThreshold;
  }

  /// Resultado final considerando todas as respostas.
  QuizResult get result => QuizResult.fromAnswers(answers);
}
