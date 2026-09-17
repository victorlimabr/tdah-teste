import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../data/services/share_service.dart';
import '../../../routing/routes.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_buttons.dart';
import '../../core/widgets/centered_scroll_view.dart';
import '../../core/widgets/highlight_text.dart';
import '../../core/widgets/tdah_logo.dart';
import '../view_model/quiz_view_model.dart';

/// Tela de resultado final ("Parabéns!"), com mensagem conforme a triagem.
class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  Future<void> _share(BuildContext context, QuizViewModel viewModel) async {
    try {
      await context.read<ShareService>().share(viewModel.shareMessage());
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Não foi possível compartilhar.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<QuizViewModel>();
    final positive = viewModel.result.isScreenPositive;

    final body = positive
        ? const HighlightText([
            Seg('A triagem indicou '),
            Seg('compatibilidade com sintomas de TDAH', hl: true),
            Seg(', é importante '),
            Seg('procurar um médico ou psicólogo especializado', hl: true),
            Seg(' para '),
            Seg('confirmar o diagnóstico', hl: true),
            Seg(' e '),
            Seg('discutir possíveis tratamentos.', hl: true),
          ])
        : const HighlightText([
            Seg('A triagem '),
            Seg('não indicou um número significativo de sintomas', hl: true),
            Seg(' de TDAH. Se ainda assim eles '),
            Seg('afetam o seu dia a dia', hl: true),
            Seg(', vale conversar com um '),
            Seg('profissional de saúde.', hl: true),
          ]);

    void finish() => context.go(Routes.onboarding);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 24, bottom: 8),
                child: Row(
                  children: [
                    const TdahLogo(),
                    const Spacer(),
                    IconButton(
                      onPressed: () => _share(context, viewModel),
                      icon: const Icon(Icons.share_outlined,
                          color: AppColors.primary),
                      tooltip: 'Compartilhar resultado',
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CenteredScrollView(
                  children: [
                    Image.asset('assets/images/group_hug.png', height: 230),
                    const SizedBox(height: 36),
                    const Text(
                      'Parabéns!',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Você completou o teste!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),
                    body,
                  ],
                ),
              ),
              if (positive) ...[
                TonalButton(
                  label: 'Encontrar profissionais próximo',
                  onPressed: () => context.push(Routes.professionals),
                ),
                const SizedBox(height: 12),
              ],
              PrimaryButton(label: 'Finalizar', onPressed: finish),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
