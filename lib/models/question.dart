import 'package:flutter/material.dart';

/// Grupo do sintoma avaliado pela pergunta.
///
/// Usado apenas para o detalhamento informativo do resultado
/// (desatenção x hiperatividade/impulsividade). Não altera o
/// rastreio principal, que é baseado na Parte A.
enum SymptomType {
  inattention('Desatenção'),
  hyperactivity('Hiperatividade / Impulsividade');

  const SymptomType(this.label);
  final String label;
}

/// Uma pergunta do questionário ASRS-18.
class Question {
  const Question({
    required this.number,
    required this.part,
    required this.text,
    required this.type,
    required this.shadedFrom,
    required this.icon,
  });

  /// Número global da pergunta (1 a 18).
  final int number;

  /// Parte do questionário: 'A' (rastreio) ou 'B' (complementar).
  final String part;

  /// Enunciado da pergunta.
  final String text;

  /// Grupo de sintoma.
  final SymptomType type;

  /// Índice mínimo da opção (0 a 4) que cai na "área sombreada" do
  /// questionário original. Uma resposta conta como sombreada quando
  /// o índice escolhido é maior ou igual a este valor.
  final int shadedFrom;

  /// Ícone ilustrativo relacionado ao tema da pergunta.
  final IconData icon;

  bool get isPartA => part == 'A';
}

/// As 5 opções de frequência (índices 0 a 4), conforme o protótipo.
const List<String> kAnswerOptions = <String>[
  'Nunca',
  'Raramente',
  'Às vezes',
  'Frequentemente',
  'Muito frequentemente',
];
