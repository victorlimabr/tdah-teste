/// Snapshot do progresso do teste, para retomar de onde o usuário parou.
class QuizProgress {
  const QuizProgress({
    required this.answers,
    required this.location,
    required this.questionIndex,
    required this.updatedAt,
  });

  /// Respostas (índice 0-4 ou null), indexadas por `pergunta.number - 1`.
  final List<int?> answers;

  /// Rota em que o usuário estava (ex.: '/quiz/a', '/quiz/b', '/transition').
  final String location;

  /// Índice do cartão dentro da parte (para reabrir na pergunta certa).
  final int questionIndex;

  /// Quando o progresso foi salvo pela última vez.
  final DateTime updatedAt;

  Map<String, dynamic> toJson() => {
        'answers': answers,
        'location': location,
        'questionIndex': questionIndex,
        'updatedAt': updatedAt.toIso8601String(),
      };

  /// Reconstrói a partir do JSON. Retorna `null` se o formato for inválido.
  static QuizProgress? fromJson(Map<String, dynamic> json) {
    try {
      final answers = (json['answers'] as List)
          .map((e) => e == null ? null : e as int)
          .toList();
      return QuizProgress(
        answers: answers,
        location: json['location'] as String,
        questionIndex: json['questionIndex'] as int,
        updatedAt:
            DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
                DateTime.now(),
      );
    } catch (_) {
      return null;
    }
  }
}
