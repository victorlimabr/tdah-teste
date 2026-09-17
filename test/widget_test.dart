import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tdah_teste/data/asrs_questions.dart';
import 'package:tdah_teste/data/models/quiz_progress.dart';
import 'package:tdah_teste/data/models/quiz_result.dart';
import 'package:tdah_teste/data/repositories/question_repository.dart';
import 'package:tdah_teste/data/repositories/quiz_progress_repository.dart';
import 'package:tdah_teste/main.dart';
import 'package:tdah_teste/routing/app_router.dart';
import 'package:tdah_teste/routing/routes.dart';
import 'package:tdah_teste/ui/quiz/view/part_intro_screen.dart';
import 'package:tdah_teste/ui/quiz/view_model/quiz_view_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('Onboarding mostra o título de boas-vindas e o botão Próximo',
      (WidgetTester tester) async {
    await tester.pumpWidget(const TdahTesteApp());

    expect(
      find.text('Bem-vindo ao Teste de sintomas de TDAH!'),
      findsOneWidget,
    );
    expect(find.text('Próximo'), findsOneWidget);
  });

  testWidgets('fluxo do quiz acessa o QuizViewModel via provider',
      (WidgetTester tester) async {
    // Usa um tamanho de tela realista de celular (a janela padrão de teste
    // é 800x600, baixa e larga demais para um app mobile).
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<QuestionRepository>(create: (_) => AsrsQuestionRepository()),
          Provider<QuizProgressRepository>(
            create: (_) => SharedPrefsQuizProgressRepository(),
          ),
          ChangeNotifierProvider<QuizViewModel>(
            create: (c) => QuizViewModel(
              c.read<QuestionRepository>(),
              c.read<QuizProgressRepository>(),
            ),
          ),
        ],
        child: MaterialApp.router(
          routerConfig: createAppRouter(initialLocation: Routes.intro),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Parte A'), findsOneWidget);

    await tester.tap(find.text('Começar o teste'));
    await tester.pumpAndSettle();

    // Navegou para /quiz/a e renderizou o primeiro card.
    expect(find.text('Nunca'), findsOneWidget);
    expect(find.text('Próxima pergunta'), findsOneWidget);
  });

  testWidgets('banner "Continuar de onde parei" aparece e retoma o teste',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final saved = QuizProgress(
      answers: [4, ...List<int?>.filled(17, null)],
      location: Routes.quizPartA,
      questionIndex: 2,
      updatedAt: DateTime(2026, 9, 16),
    );
    SharedPreferences.setMockInitialValues(
      {'quiz_progress': jsonEncode(saved.toJson())},
    );

    await tester.pumpWidget(const TdahTesteApp());
    await tester.pumpAndSettle();

    expect(find.text('Continuar de onde parei'), findsOneWidget);
    expect(find.text('Parte A · pergunta 3 de 6'), findsOneWidget);

    await tester.tap(find.text('Continuar de onde parei'));
    await tester.pumpAndSettle();

    // Retomou no cartão de perguntas da Parte A.
    expect(find.text('Nunca'), findsOneWidget);
    expect(find.text('Próxima pergunta'), findsOneWidget);
  });

  testWidgets('telas centralizadas não estouram em tela baixa',
      (WidgetTester tester) async {
    // Tela bem baixa/estreita — reproduz o cenário que causava overflow.
    tester.view.physicalSize = const Size(1080, 1280);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<QuestionRepository>(create: (_) => AsrsQuestionRepository()),
          Provider<QuizProgressRepository>(
            create: (_) => SharedPrefsQuizProgressRepository(),
          ),
          ChangeNotifierProvider<QuizViewModel>(
            create: (c) => QuizViewModel(
              c.read<QuestionRepository>(),
              c.read<QuizProgressRepository>(),
            ),
          ),
        ],
        child: const MaterialApp(home: PartIntroScreen()),
      ),
    );

    // Sem CenteredScrollView isto lançaria "RenderFlex overflowed".
    expect(tester.takeException(), isNull);
    expect(find.text('Parte A'), findsOneWidget);
  });

  test('Há 18 perguntas, sendo 6 na Parte A', () {
    expect(kQuestions.length, 18);
    expect(kQuestions.where((q) => q.isPartA).length, 6);
  });

  group('Cálculo do resultado', () {
    test('Todas "Nunca" resulta em rastreio negativo', () {
      final answers = List<int?>.filled(kQuestions.length, 0);
      final result = QuizResult.fromAnswers(kQuestions, answers);

      expect(result.partAShaded, 0);
      expect(result.isScreenPositive, isFalse);
    });

    test('Todas "Sempre" resulta em rastreio positivo', () {
      final answers = List<int?>.filled(kQuestions.length, 4);
      final result = QuizResult.fromAnswers(kQuestions, answers);

      expect(result.partAShaded, 6);
      expect(result.isScreenPositive, isTrue);
      expect(result.inattentionScore, QuizResult.maxInattention);
      expect(result.hyperactivityScore, QuizResult.maxHyperactivity);
    });

    test('Rastreio positivo exige 4+ marcações na área sombreada da Parte A',
        () {
      // Responde "Às vezes" (índice 2) em tudo.
      // Parte A: perguntas 1-3 têm shadedFrom 2 (contam), 4-6 têm 3 (não).
      final answers = List<int?>.filled(kQuestions.length, 2);
      final result = QuizResult.fromAnswers(kQuestions, answers);

      expect(result.partAShaded, 3);
      expect(result.isScreenPositive, isFalse);
    });
  });
}
