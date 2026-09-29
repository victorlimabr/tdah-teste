/// Snapshot do progresso de um teste, para retomar de onde o usuário parou.
class QuizProgress {
  const QuizProgress({
    required this.assessmentId,
    required this.answers,
    required this.location,
    required this.questionIndex,
    required this.updatedAt,
    this.respondent,
  });

  /// Qual teste estava sendo respondido (ex.: 'asrs18', 'snap18').
  final String assessmentId;

  /// Respostas (índice ou null), indexadas por `pergunta.number - 1`.
  final List<int?> answers;

  /// Rota em que o usuário estava (ex.: '/quiz/0', '/transition/0').
  final String location;

  /// Índice do cartão dentro da seção (para reabrir na pergunta certa).
  final int questionIndex;

  /// Quem estava respondendo (SNAP-IV: 'Pais' / 'Professor'), se aplicável.
  final String? respondent;

  final DateTime updatedAt;

  Map<String, dynamic> toJson() => {
        'assessmentId': assessmentId,
        'answers': answers,
        'location': location,
        'questionIndex': questionIndex,
        'respondent': respondent,
        'updatedAt': updatedAt.toIso8601String(),
      };

  static QuizProgress? fromJson(Map<String, dynamic> json) {
    try {
      final answers = (json['answers'] as List)
          .map((e) => e == null ? null : e as int)
          .toList();
      return QuizProgress(
        assessmentId: json['assessmentId'] as String,
        answers: answers,
        location: json['location'] as String,
        questionIndex: json['questionIndex'] as int,
        respondent: json['respondent'] as String?,
        updatedAt:
            DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
                DateTime.now(),
      );
    } catch (_) {
      return null;
    }
  }
}
