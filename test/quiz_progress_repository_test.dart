import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tdah_teste/data/models/quiz_progress.dart';
import 'package:tdah_teste/data/repositories/quiz_progress_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late QuizProgressRepository repository;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    repository = SharedPrefsQuizProgressRepository();
  });

  test('load retorna null quando não há nada salvo', () async {
    expect(await repository.load(), isNull);
  });

  test('save e load fazem o round-trip do progresso', () async {
    final progress = QuizProgress(
      answers: [null, 2, 4, ...List<int?>.filled(15, null)],
      location: '/quiz/a',
      questionIndex: 3,
      updatedAt: DateTime(2026, 9, 16, 10, 30),
    );

    await repository.save(progress);
    final loaded = await repository.load();

    expect(loaded, isNotNull);
    expect(loaded!.location, '/quiz/a');
    expect(loaded.questionIndex, 3);
    expect(loaded.answers.length, 18);
    expect(loaded.answers[1], 2);
    expect(loaded.answers[2], 4);
    expect(loaded.answers[0], isNull);
  });

  test('clear apaga o progresso salvo', () async {
    await repository.save(
      QuizProgress(
        answers: List<int?>.filled(18, 0),
        location: '/quiz/b',
        questionIndex: 5,
        updatedAt: DateTime(2026, 9, 16),
      ),
    );
    await repository.clear();

    expect(await repository.load(), isNull);
  });
}
