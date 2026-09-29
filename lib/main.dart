import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/repositories/assessment_repository.dart';
import 'data/repositories/quiz_progress_repository.dart';
import 'data/services/share_service.dart';
import 'data/services/url_launcher_service.dart';
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
        Provider<AssessmentRepository>(
          create: (_) => DefaultAssessmentRepository(),
        ),
        Provider<QuizProgressRepository>(
          create: (_) => SharedPrefsQuizProgressRepository(),
        ),
        Provider<UrlLauncherService>(create: (_) => DefaultUrlLauncherService()),
        Provider<ShareService>(create: (_) => SharePlusShareService()),
        ChangeNotifierProvider<QuizViewModel>(
          create: (context) => QuizViewModel(
            context.read<AssessmentRepository>(),
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
