import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../data/models/assessment.dart';
import '../../routing/routes.dart';
import '../core/theme/app_theme.dart';
import '../core/widgets/app_buttons.dart';
import '../core/widgets/highlight_text.dart';
import '../core/widgets/indicators.dart';
import '../core/widgets/tdah_logo.dart';
import '../quiz/view_model/quiz_view_model.dart';

/// Introdução do teste selecionado (onboarding por teste). Renderiza as
/// páginas de intro do [Assessment] atual.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next(Assessment assessment) {
    final isLast = _page == assessment.intro.length - 1;
    if (!isLast) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
      return;
    }
    context.go(
      assessment.needsRespondent
          ? Routes.respondent
          : Routes.quizSection(0),
    );
  }

  @override
  Widget build(BuildContext context) {
    final assessment = context.watch<QuizViewModel>().assessment;
    if (assessment == null) {
      return const Scaffold(body: SizedBox.shrink());
    }
    final pages = assessment.intro;
    final isLast = _page == pages.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 24, 32, 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.go(Routes.catalog),
                    icon: const Icon(Icons.arrow_back, color: AppColors.navy),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 12),
                  const TdahLogo(),
                  const Spacer(),
                  DotsIndicator(total: pages.length, current: _page),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: pages.length,
                onPageChanged: (i) => setState(() => _page = i),
                itemBuilder: (context, index) => _IntroPageView(pages[index]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 8, 32, 24),
              child: PrimaryButton(
                label: isLast ? 'Começar o teste' : 'Próximo',
                onPressed: () => _next(assessment),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IntroPageView extends StatelessWidget {
  const _IntroPageView(this.page);
  final IntroPage page;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(height: 8),
                Text(
                  page.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.navy,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    height: 1.25,
                  ),
                ),
                Image.asset(page.image, height: 200),
                for (final paragraph in page.paragraphs) HighlightText(paragraph),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }
}
