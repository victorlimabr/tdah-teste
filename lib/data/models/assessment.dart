import 'package:flutter/widgets.dart';

import 'question.dart';
import 'text_segment.dart';

/// Uma seção/subescala de um teste (ex.: "Parte A", "Desatenção").
class Section {
  const Section({
    required this.id,
    required this.label,
    required this.questions,
    required this.passThreshold,
    this.isScreener = true,
  });

  final String id;
  final String label;
  final List<Question> questions;

  /// Nº mínimo de perguntas "contadas" para a seção ser considerada atingida.
  final int passThreshold;

  /// Se a seção participa do veredito (rastreio positivo).
  final bool isScreener;
}

/// Resultado de uma seção após a contagem.
class SectionResult {
  const SectionResult(this.section, this.count);
  final Section section;
  final int count;
  int get total => section.questions.length;
  bool get reached => count >= section.passThreshold;
}

/// Resultado completo de um teste.
class AssessmentResult {
  const AssessmentResult(this.sectionResults);
  final List<SectionResult> sectionResults;

  bool get isPositive =>
      sectionResults.any((r) => r.section.isScreener && r.reached);

  SectionResult sectionById(String id) =>
      sectionResults.firstWhere((r) => r.section.id == id);
}

/// Página de introdução (onboarding por teste).
class IntroPage {
  const IntroPage({
    required this.title,
    required this.image,
    required this.paragraphs,
  });

  final String title;
  final String image;
  final List<List<Seg>> paragraphs;
}

/// Conteúdo da tela de transição entre seções.
class TransitionContent {
  const TransitionContent({
    required this.title,
    required this.subtitle,
    required this.body,
    this.showExit = false,
  });

  final String title;
  final String subtitle;
  final List<Seg> body;
  final bool showExit;
}

/// Conteúdo da tela de resultado.
class ResultContent {
  const ResultContent({
    required this.headline,
    required this.subtitle,
    required this.body,
  });

  final String headline;
  final String subtitle;
  final List<Seg> body;
}

/// Um teste/instrumento (ASRS-18, SNAP-IV, ...). Encapsula perguntas, escala,
/// seções, conteúdo (intro/transição/resultado) e a regra de pontuação.
abstract class Assessment {
  String get id;
  String get name;
  String get subtitle;
  String get audience;
  int get estimatedMinutes;
  IconData get icon;

  /// Rótulos das opções de resposta (o índice é o valor).
  List<String> get scale;

  List<Section> get sections;

  /// Se o teste precisa do passo "quem responde" (ex.: SNAP-IV).
  bool get needsRespondent;

  List<IntroPage> get intro;

  List<Question> get questions => [for (final s in sections) ...s.questions];
  int get totalQuestions => questions.length;

  /// Conta as respostas por seção e monta o resultado.
  AssessmentResult buildResult(List<int?> answers) {
    final results = <SectionResult>[];
    for (final section in sections) {
      var count = 0;
      for (final q in section.questions) {
        final value = answers[q.number - 1] ?? 0;
        if (value >= q.countFrom) count++;
      }
      results.add(SectionResult(section, count));
    }
    return AssessmentResult(results);
  }

  /// Conteúdo da transição após concluir a seção [sectionIndex], ou `null`
  /// para ir direto à próxima seção.
  TransitionContent? transitionAfter(int sectionIndex, AssessmentResult partial);

  ResultContent resultContent(AssessmentResult result);

  String shareMessage(AssessmentResult result);
}
