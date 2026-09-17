import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:tdah_teste/data/models/quiz_progress.dart';
import 'package:tdah_teste/data/repositories/question_repository.dart';
import 'package:tdah_teste/data/repositories/quiz_progress_repository.dart';
import 'package:tdah_teste/data/services/share_service.dart';
import 'package:tdah_teste/ui/quiz/view/result_screen.dart';
import 'package:tdah_teste/ui/quiz/view_model/quiz_view_model.dart';

class _FakeShareService implements ShareService {
  String? shared;

  @override
  Future<void> share(String text) async => shared = text;
}

class _FakeProgressRepository implements QuizProgressRepository {
  @override
  Future<void> clear() async {}

  @override
  Future<QuizProgress?> load() async => null;

  @override
  Future<void> save(QuizProgress progress) async {}
}

void main() {
  testWidgets('botão de compartilhar aciona o ShareService com a mensagem',
      (WidgetTester tester) async {
    final repository = AsrsQuestionRepository();
    final viewModel = QuizViewModel(repository, _FakeProgressRepository());
    for (final q in repository.questions) {
      viewModel.selectAnswer(q, 4); // resultado positivo
    }
    final share = _FakeShareService();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<QuizViewModel>.value(value: viewModel),
          Provider<ShareService>.value(value: share),
        ],
        child: const MaterialApp(home: ResultScreen()),
      ),
    );

    await tester.tap(find.byIcon(Icons.share_outlined));
    await tester.pump();

    expect(share.shared, isNotNull);
    expect(share.shared, contains('compatibilidade com sintomas de TDAH'));
  });
}
