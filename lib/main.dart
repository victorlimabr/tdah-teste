import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/repositories/question_repository.dart';
import 'data/repositories/quiz_progress_repository.dart';
import 'routing/app_router.dart';
import 'ui/core/theme/app_theme.dart';
import 'ui/quiz/view_model/quiz_view_model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TdahTesteApp());
}

class TdahTesteApp extends StatelessWidget {
  const TdahTesteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<QuestionRepository>(create: (_) => AsrsQuestionRepository()),
        Provider<QuizProgressRepository>(
          create: (_) => SharedPrefsQuizProgressRepository(),
        ),
        ChangeNotifierProvider<QuizViewModel>(
          create: (context) => QuizViewModel(
            context.read<QuestionRepository>(),
            context.read<QuizProgressRepository>(),
          )..load(),
        ),
      ],
      child: MaterialApp.router(
        title: 'Teste TDAH',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        themeMode: ThemeMode.light,
        routerConfig: appRouter,
      ),
    );
  }
}
