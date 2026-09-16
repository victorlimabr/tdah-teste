import 'package:flutter_test/flutter_test.dart';

import 'package:tdah_teste/data/asrs_questions.dart';
import 'package:tdah_teste/main.dart';
import 'package:tdah_teste/data/models/quiz_result.dart';

void main() {
  testWidgets('Onboarding mostra o título de boas-vindas e o botão Próximo',
      (WidgetTester tester) async {
    await tester.pumpWidget(const TdahTesteApp());

    expect(
      find.text('Bem-vindo ao Teste de sintomas de TDAH!'),
      findsOneWidget,
    );
    expect(find.text('Próximo'), findsOneWidget);
  });

  test('Há 18 perguntas, sendo 6 na Parte A', () {
    expect(kQuestions.length, 18);
    expect(kQuestions.where((q) => q.isPartA).length, 6);
  });

  group('Cálculo do resultado', () {
    test('Todas "Nunca" resulta em rastreio negativo', () {
      final answers = List<int?>.filled(kQuestions.length, 0);
      final result = QuizResult.fromAnswers(answers);

      expect(result.partAShaded, 0);
      expect(result.isScreenPositive, isFalse);
    });

    test('Todas "Sempre" resulta em rastreio positivo', () {
      final answers = List<int?>.filled(kQuestions.length, 4);
      final result = QuizResult.fromAnswers(answers);

      expect(result.partAShaded, 6);
      expect(result.isScreenPositive, isTrue);
      expect(result.inattentionScore, QuizResult.maxInattention);
      expect(result.hyperactivityScore, QuizResult.maxHyperactivity);
    });

    test('Rastreio positivo exige 4+ marcações na área sombreada da Parte A',
        () {
      // Responde "De vez em quando" (índice 2) em tudo.
      // Parte A: perguntas 1-3 têm shadedFrom 2 (contam), 4-6 têm 3 (não).
      final answers = List<int?>.filled(kQuestions.length, 2);
      final result = QuizResult.fromAnswers(answers);

      expect(result.partAShaded, 3);
      expect(result.isScreenPositive, isFalse);
    });
  });
}
