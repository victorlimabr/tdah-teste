import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tdah_teste/data/models/quiz_progress.dart';
import 'package:tdah_teste/data/repositories/assessment_repository.dart';
import 'package:tdah_teste/data/repositories/quiz_progress_repository.dart';
import 'package:tdah_teste/main.dart';
import 'package:tdah_teste/routing/app_router.dart';
import 'package:tdah_teste/ui/quiz/view_model/quiz_view_model.dart';

class _FakeProgress implements QuizProgressRepository {
  _FakeProgress(this.stored);
  QuizProgress? stored;

  @override
  Future<void> clear() async => stored = null;

  @override
  Future<QuizProgress?> load() async => stored;

  @override
  Future<void> save(QuizProgress progress) async => stored = progress;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  void phoneSize(WidgetTester tester) {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  testWidgets('catálogo mostra os testes disponíveis', (tester) async {
    SharedPreferences.setMockInitialValues({});
    phoneSize(tester);
    await tester.pumpWidget(const TdahTesteApp());
    await tester.pumpAndSettle();

    expect(find.text('Escolha um teste'), findsOneWidget);
    expect(find.text('ASRS-18'), findsOneWidget);
    expect(find.text('SNAP-IV'), findsOneWidget);
  });

  testWidgets('selecionar o ASRS abre a introdução do teste', (tester) async {
    SharedPreferences.setMockInitialValues({});
    phoneSize(tester);
    await tester.pumpWidget(const TdahTesteApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('ASRS-18'));
    await tester.pumpAndSettle();

    expect(
      find.text('Bem-vindo ao Teste de sintomas de TDAH!'),
      findsOneWidget,
    );
  });

  testWidgets('banner de retomada aparece e volta ao teste salvo',
      (tester) async {
    phoneSize(tester);

    final assessments = DefaultAssessmentRepository();
    final progress = _FakeProgress(
      QuizProgress(
        assessmentId: 'snap18',
        answers: List<int?>.filled(18, null),
        location: '/quiz/0',
        questionIndex: 0,
        respondent: 'Pais',
        updatedAt: DateTime(2026, 9, 17),
      ),
    );
    final viewModel = QuizViewModel(assessments, progress);
    await viewModel.load();

    await tester.pumpWidget(
      ChangeNotifierProvider<QuizViewModel>.value(
        value: viewModel,
        child: MaterialApp.router(routerConfig: createAppRouter()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Continuar de onde parei'), findsOneWidget);
    expect(find.text('SNAP-IV'), findsWidgets);

    await tester.tap(find.text('Continuar de onde parei'));
    await tester.pumpAndSettle();

    // Retomou no primeiro item do SNAP-IV.
    expect(find.text('Nem um pouco'), findsOneWidget);
    expect(find.text('Próxima pergunta'), findsOneWidget);
  });
}
