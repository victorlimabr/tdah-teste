import '../asrs_questions.dart';
import '../models/question.dart';

/// Fonte da verdade das perguntas do teste.
///
/// Abstrai de onde as perguntas vêm (hoje, uma lista estática; futuramente
/// poderia ser um arquivo JSON ou uma API) sem que a UI precise saber.
abstract class QuestionRepository {
  /// Todas as 18 perguntas, na ordem oficial.
  List<Question> get questions;

  /// Perguntas da Parte A (rastreio).
  List<Question> get partA;

  /// Perguntas da Parte B (complementar).
  List<Question> get partB;
}

/// Implementação baseada na escala ASRS-18 (lista estática).
class AsrsQuestionRepository implements QuestionRepository {
  @override
  List<Question> get questions => kQuestions;

  @override
  List<Question> get partA =>
      kQuestions.where((q) => q.part == 'A').toList(growable: false);

  @override
  List<Question> get partB =>
      kQuestions.where((q) => q.part == 'B').toList(growable: false);
}
