import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_buttons.dart';
import '../../core/widgets/highlight_text.dart';
import '../../core/widgets/tdah_logo.dart';
import '../view_model/quiz_view_model.dart';
import 'quiz_screen.dart';

/// Tela de transição entre a Parte A e a Parte B ("Parabéns!").
///
/// O texto muda conforme o rastreio da Parte A foi positivo ou não.
class TransitionScreen extends StatelessWidget {
  const TransitionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<QuizViewModel>();
    final positive = viewModel.isPartAScreenPositive;

    final body = positive
        ? const HighlightText([
            Seg('O resultado sugere uma '),
            Seg('compatibilidade alta com um possível diagnóstico', hl: true),
            Seg(', recomendando uma '),
            Seg('investigação médica.', hl: true),
            Seg(' Vamos para a parte B para uma '),
            Seg('análise mais detalhada', hl: true),
            Seg(' para apoiar a avaliação.'),
          ])
        : const HighlightText([
            Seg('Os critérios de triagem para TDAH '),
            Seg('não foram atendidos', hl: true),
            Seg('. A '),
            Seg('parte B ainda pode ser preenchida', hl: true),
            Seg(' para fornecer informações adicionais, mas '),
            Seg('não é obrigatória.', hl: true),
          ]);

    void goToPartB() {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => QuizScreen(
            questions: viewModel.partB,
            partLabel: 'Parte B',
            isLastPart: true,
          ),
        ),
      );
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                      'Você completou a primeira parte do teste!',
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
              PrimaryButton(
                label: 'Continuar para a parte B',
                onPressed: goToPartB,
              ),
              if (!positive)
                TextLinkButton(
                  label: 'Sair',
                  onPressed: () =>
                      Navigator.of(context).popUntil((r) => r.isFirst),
                ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
