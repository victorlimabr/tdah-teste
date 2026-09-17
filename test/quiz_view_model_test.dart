import 'package:flutter_test/flutter_test.dart';

import 'package:tdah_teste/data/models/quiz_progress.dart';
import 'package:tdah_teste/data/repositories/question_repository.dart';
import 'package:tdah_teste/data/repositories/quiz_progress_repository.dart';
import 'package:tdah_teste/ui/quiz/view_model/quiz_view_model.dart';

/// Repositório de progresso em memória para os testes.
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
  late QuestionRepository repository;
  late _FakeProgressRepository progress;
  late QuizViewModel viewModel;

  setUp(() {
    repository = AsrsQuestionRepository();
    progress = _FakeProgressRepository();
    viewModel = QuizViewModel(repository, progress);
  });

  test('inicia sem respostas e com rastreio negativo', () {
    for (final q in repository.questions) {
      expect(viewModel.isAnswered(q), isFalse);
    }
    expect(viewModel.isPartAScreenPositive, isFalse);
    expect(viewModel.result.partAShaded, 0);
    expect(viewModel.hasSavedProgress, isFalse);
  });

  test('selectAnswer registra a resposta, notifica e persiste', () {
    var notified = 0;
    viewModel.addListener(() => notified++);

    final q = repository.partA.first;
    viewModel.selectAnswer(q, 4);

    expect(viewModel.answerFor(q), 4);
    expect(notified, 1);
    expect(progress.stored, isNotNull);
    expect(progress.stored!.answers[q.number - 1], 4);
  });

  test('setPosition persiste a rota e o índice do cartão', () {
    viewModel.setPosition('/quiz/b', 5);

    expect(progress.stored!.location, '/quiz/b');
    expect(progress.stored!.questionIndex, 5);
  });

  test('load restaura respostas e posição salvas', () async {
    progress.stored = QuizProgress(
      answers: [4, ...List<int?>.filled(17, null)],
      location: '/quiz/a',
      questionIndex: 3,
      updatedAt: DateTime(2026, 9, 16),
    );

    await viewModel.load();

    expect(viewModel.isLoaded, isTrue);
    expect(viewModel.hasSavedProgress, isTrue);
    expect(viewModel.resumeLocation, '/quiz/a');
    expect(viewModel.resumeQuestionIndex, 3);
    expect(viewModel.answerFor(repository.partA.first), 4);
  });

  test('responder tudo com "Muito frequentemente" dá rastreio positivo', () {
    for (final q in repository.questions) {
      viewModel.selectAnswer(q, 4);
    }

    expect(viewModel.isPartAScreenPositive, isTrue);
    expect(viewModel.result.partAShaded, 6);
  });

  test('reset limpa respostas e progresso salvo', () async {
    for (final q in repository.questions) {
      viewModel.selectAnswer(q, 4);
    }
    await viewModel.reset();

    for (final q in repository.questions) {
      expect(viewModel.isAnswered(q), isFalse);
    }
    expect(progress.stored, isNull);
    expect(viewModel.hasSavedProgress, isFalse);
  });

  test('clearProgress apaga o progresso salvo', () async {
    viewModel.setPosition('/quiz/a', 2);
    await viewModel.clearProgress();

    expect(progress.stored, isNull);
    expect(viewModel.hasSavedProgress, isFalse);
  });

  test('shareMessage reflete o resultado positivo', () {
    for (final q in repository.questions) {
      viewModel.selectAnswer(q, 4);
    }

    final message = viewModel.shareMessage();
    expect(message, contains('compatibilidade com sintomas de TDAH'));
    expect(message, contains('não é um diagnóstico'));
  });

  test('shareMessage reflete o resultado negativo', () {
    final message = viewModel.shareMessage(); // sem respostas -> negativo
    expect(message, contains('não indicou um número significativo'));
  });
}
