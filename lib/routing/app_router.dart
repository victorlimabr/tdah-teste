import 'package:go_router/go_router.dart';

import '../ui/catalog/catalog_screen.dart';
import '../ui/onboarding/onboarding_screen.dart';
import '../ui/professionals/professionals_screen.dart';
import '../ui/quiz/view/quiz_screen.dart';
import '../ui/quiz/view/result_screen.dart';
import '../ui/quiz/view/transition_screen.dart';
import '../ui/respondent/respondent_screen.dart';
import 'routes.dart';

/// Cria o roteador do app. O [initialLocation] facilita testes.
GoRouter createAppRouter({String initialLocation = Routes.catalog}) {
  return GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: Routes.catalog,
        builder: (context, state) => const CatalogScreen(),
      ),
      GoRoute(
        path: Routes.intro,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: Routes.respondent,
        builder: (context, state) => const RespondentScreen(),
      ),
      GoRoute(
        path: '/quiz/:section',
        builder: (context, state) {
          final index =
              int.tryParse(state.pathParameters['section'] ?? '0') ?? 0;
          return QuizScreen(sectionIndex: index);
        },
      ),
      GoRoute(
        path: '/transition/:after',
        builder: (context, state) {
          final index =
              int.tryParse(state.pathParameters['after'] ?? '0') ?? 0;
          return TransitionScreen(afterSection: index);
        },
      ),
      GoRoute(
        path: Routes.result,
        builder: (context, state) => const ResultScreen(),
      ),
      GoRoute(
        path: Routes.professionals,
        builder: (context, state) => const ProfessionalsScreen(),
      ),
    ],
  );
}

/// Instância única usada pelo app.
final GoRouter appRouter = createAppRouter();
