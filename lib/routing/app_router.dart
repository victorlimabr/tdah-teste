import 'package:go_router/go_router.dart';

import '../ui/onboarding/onboarding_screen.dart';
import '../ui/quiz/view/part_intro_screen.dart';
import '../ui/quiz/view/quiz_screen.dart';
import '../ui/professionals/professionals_screen.dart';
import '../ui/quiz/view/result_screen.dart';
import '../ui/quiz/view/transition_screen.dart';
import 'routes.dart';

/// Cria o roteador do app. O [initialLocation] facilita testes.
GoRouter createAppRouter({String initialLocation = Routes.onboarding}) {
  return GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: Routes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: Routes.intro,
        builder: (context, state) => const PartIntroScreen(),
      ),
      GoRoute(
        path: '/quiz/:part',
        builder: (context, state) {
          final part =
              state.pathParameters['part'] == 'b' ? QuizPart.b : QuizPart.a;
          return QuizScreen(part: part);
        },
      ),
      GoRoute(
        path: Routes.transition,
        builder: (context, state) => const TransitionScreen(),
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
