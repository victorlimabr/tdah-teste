import 'package:flutter_test/flutter_test.dart';

import 'package:tdah_teste/data/models/assessment.dart';
import 'package:tdah_teste/data/models/quiz_progress.dart';
import 'package:tdah_teste/data/repositories/assessment_repository.dart';
import 'package:tdah_teste/data/repositories/quiz_progress_repository.dart';
import 'package:tdah_teste/routing/routes.dart';
import 'package:tdah_teste/ui/quiz/view_model/quiz_view_model.dart';

class _FakeProgressRepository implements QuizProgressRepository {
  QuizProgress? stored;

  @override
  Future<void> clear() async => stored = null;

  @override
  Future<QuizProgress?> load() async => stored;

  @override
  Future<void> save(QuizProgress progress) async => stored = progress;
}

void main() {
  late DefaultAssessmentRepository assessments;
  late _FakeProgressRepository progress;
  late QuizViewModel viewModel;
  late Assessment asrs;

  setUp(() {
    assessments = DefaultAssessmentRepository();
    progress = _FakeProgressRepository();
    viewModel = QuizViewModel(assessments, progress);
    asrs = assessments.byId('asrs18')!;
  });

  test('catálogo expõe ASRS-18 e SNAP-IV', () {
    expect(viewModel.catalog.map((a) => a.id), containsAll(['asrs18', 'snap18']));
  });

  test('selectAssessment começa com respostas vazias', () {
    viewModel.selectAssessment(asrs);
    for (final q in asrs.questions) {
      expect(viewModel.isAnswered(q), isFalse);
    }
    expect(viewModel.result.isPositive, isFalse);
  });

  test('selectAnswer persiste com o id do teste', () {
    viewModel.selectAssessment(asrs);
    viewModel.selectAnswer(asrs.questions.first, 4);

    expect(progress.stored, isNotNull);
    expect(progress.stored!.assessmentId, 'asrs18');
    expect(progress.stored!.answers[0], 4);
  });

  test('responder a Parte A com "Muito frequentemente" dá positivo', () {
    viewModel.selectAssessment(asrs);
    for (final q in asrs.sections.first.questions) {
      viewModel.selectAnswer(q, 4);
    }
    expect(viewModel.result.isPositive, isTrue);
    expect(viewModel.shareMessage(),
        contains('compatibilidade com sintomas de TDAH'));
  });

  test('setRespondent guarda quem respondeu (SNAP)', () {
    final snap = assessments.byId('snap18')!;
    viewModel.selectAssessment(snap);
    viewModel.setRespondent('Pais');

    expect(viewModel.respondent, 'Pais');
    expect(progress.stored!.respondent, 'Pais');
  });

  test('load restaura o teste e a posição salvos', () async {
    progress.stored = QuizProgress(
      assessmentId: 'asrs18',
      answers: [4, ...List<int?>.filled(17, null)],
      location: Routes.quizSection(0),
      questionIndex: 2,
      updatedAt: DateTime(2026, 9, 17),
    );

    await viewModel.load();

    expect(viewModel.assessment!.id, 'asrs18');
    expect(viewModel.hasSavedProgress, isTrue);
    expect(viewModel.resumeAssessmentName, 'ASRS-18');
    expect(viewModel.resumeLocation, Routes.quizSection(0));
    expect(viewModel.resumeQuestionIndex, 2);
  });

  test('clearProgress apaga o progresso salvo', () async {
    viewModel.selectAssessment(asrs);
    viewModel.setPosition(Routes.quizSection(0), 1);
    await viewModel.clearProgress();

    expect(progress.stored, isNull);
    expect(viewModel.hasSavedProgress, isFalse);
  });
}
