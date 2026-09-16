import 'package:flutter/foundation.dart';

import '../../../data/models/question.dart';
import '../../../data/models/quiz_result.dart';
import '../../../data/repositories/question_repository.dart';

/// ViewModel do fluxo do teste (MVVM).
///
/// Mantém as respostas do usuário e expõe o estado derivado (resultado,
/// rastreio da Parte A) para as Views, que apenas leem e disparam commands.
/// É compartilhado por todas as telas do teste (Parte A, transição, Parte B
/// e resultado) via `provider`.
class QuizViewModel extends ChangeNotifier {
  QuizViewModel(this._repository) {
    _answers = List<int?>.filled(_repository.questions.length, null);
  }

  final QuestionRepository _repository;
  late List<int?> _answers;

  /// Perguntas da Parte A (rastreio).
  List<Question> get partA => _repository.partA;

  /// Perguntas da Parte B (complementar).
  List<Question> get partB => _repository.partB;

  /// Resposta escolhida (índice 0-4) para a pergunta, ou `null`.
  int? answerFor(Question q) => _answers[q.number - 1];

  bool isAnswered(Question q) => _answers[q.number - 1] != null;

  // ---- Commands ----

  /// Registra a resposta de uma pergunta.
  void selectAnswer(Question q, int value) {
    _answers[q.number - 1] = value;
    notifyListeners();
  }

  /// Reinicia o teste (novo preenchimento).
  void reset() {
    _answers = List<int?>.filled(_repository.questions.length, null);
    notifyListeners();
  }

  // ---- Estado derivado ----

  /// Rastreio da Parte A: positivo quando 4+ respostas caem na área sombreada.
  bool get isPartAScreenPositive {
    var shaded = 0;
    for (final q in partA) {
      final v = _answers[q.number - 1] ?? 0;
      if (v >= q.shadedFrom) shaded++;
    }
    return shaded >= QuizResult.partAThreshold;
  }

  /// Resultado final considerando todas as respostas.
  QuizResult get result =>
      QuizResult.fromAnswers(_repository.questions, _answers);
}
