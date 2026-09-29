import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../routing/routes.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_buttons.dart';
import '../../core/widgets/centered_scroll_view.dart';
import '../../core/widgets/highlight_text.dart';
import '../../core/widgets/tdah_logo.dart';
import '../view_model/quiz_view_model.dart';

/// Tela de transição entre seções ("Parabéns!"), com conteúdo do teste.
class TransitionScreen extends StatelessWidget {
  const TransitionScreen({super.key, required this.afterSection});

  final int afterSection;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<QuizViewModel>();
    final content =
        viewModel.assessment!.transitionAfter(afterSection, viewModel.result);
    if (content == null) {
      return const Scaffold(body: SizedBox.shrink());
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 24, bottom: 8),
                child: Align(alignment: Alignment.centerLeft, child: TdahLogo()),
              ),
              Expanded(
                child: CenteredScrollView(
                  children: [
                    Image.asset('assets/images/group_hug.png', height: 230),
                    const SizedBox(height: 36),
                    Text(
                      content.title,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      content.subtitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),
                    HighlightText(content.body),
                  ],
                ),
              ),
              PrimaryButton(
                label: 'Continuar',
                onPressed: () =>
                    context.go(Routes.quizSection(afterSection + 1)),
              ),
              if (content.showExit)
                TextLinkButton(
                  label: 'Sair',
                  onPressed: () => context.go(Routes.catalog),
                ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
