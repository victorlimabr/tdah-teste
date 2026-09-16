import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/repositories/question_repository.dart';
import 'ui/core/theme/app_theme.dart';
import 'ui/onboarding/onboarding_screen.dart';
import 'ui/quiz/view_model/quiz_view_model.dart';

void main() {
  runApp(const TdahTesteApp());
}

class TdahTesteApp extends StatelessWidget {
  const TdahTesteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<QuestionRepository>(create: (_) => AsrsQuestionRepository()),
        ChangeNotifierProvider<QuizViewModel>(
          create: (context) => QuizViewModel(context.read<QuestionRepository>()),
        ),
      ],
      child: MaterialApp(
        title: 'Teste TDAH',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        themeMode: ThemeMode.light,
        home: const OnboardingScreen(),
      ),
    );
  }
}
