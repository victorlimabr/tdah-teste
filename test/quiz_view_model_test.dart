import 'package:flutter_test/flutter_test.dart';

import 'package:tdah_teste/data/repositories/question_repository.dart';
import 'package:tdah_teste/ui/quiz/view_model/quiz_view_model.dart';

void main() {
  late QuestionRepository repository;
  late QuizViewModel viewModel;

  setUp(() {
    repository = AsrsQuestionRepository();
    viewModel = QuizViewModel(repository);
  });

  test('inicia sem respostas e com rastreio negativo', () {
    for (final q in repository.questions) {
      expect(viewModel.isAnswered(q), isFalse);
    }
    expect(viewModel.isPartAScreenPositive, isFalse);
    expect(viewModel.result.partAShaded, 0);
  });

  test('selectAnswer registra a resposta e notifica os listeners', () {
    var notified = 0;
    viewModel.addListener(() => notified++);

    final q = repository.partA.first;
    viewModel.selectAnswer(q, 4);

    expect(viewModel.answerFor(q), 4);
    expect(viewModel.isAnswered(q), isTrue);
    expect(notified, 1);
  });

  test('responder tudo com "Muito frequentemente" dá rastreio positivo', () {
    for (final q in repository.questions) {
      viewModel.selectAnswer(q, 4);
    }

    expect(viewModel.isPartAScreenPositive, isTrue);
    expect(viewModel.result.partAShaded, 6);
    expect(viewModel.result.isScreenPositive, isTrue);
  });

  test('"Às vezes" em tudo mantém rastreio negativo (só 3 sombreadas)', () {
    for (final q in repository.questions) {
      viewModel.selectAnswer(q, 2);
    }

    // A1-A3 contam a partir de "Às vezes" (2); A4-A6 só a partir de 3.
    expect(viewModel.result.partAShaded, 3);
    expect(viewModel.isPartAScreenPositive, isFalse);
  });

  test('reset limpa as respostas', () {
    for (final q in repository.questions) {
      viewModel.selectAnswer(q, 4);
    }
    viewModel.reset();

    for (final q in repository.questions) {
      expect(viewModel.isAnswered(q), isFalse);
    }
    expect(viewModel.result.partAShaded, 0);
  });
}
