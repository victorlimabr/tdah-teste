import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Indicador de passos do onboarding: o passo atual é uma barra larga,
/// os demais são pequenos pontos.
class DotsIndicator extends StatelessWidget {
  const DotsIndicator({
    super.key,
    required this.total,
    required this.current,
  });

  final int total;
  final int current;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < total; i++)
          Padding(
            padding: EdgeInsets.only(left: i == 0 ? 0 : 8),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              width: i == current ? 27 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: i == current ? AppColors.primary : AppColors.stepInactive,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
      ],
    );
  }
}

/// Barra de progresso segmentada das perguntas: um segmento por pergunta
/// da parte, preenchido em azul até a pergunta atual (inclusive).
class StepsIndicator extends StatelessWidget {
  const StepsIndicator({
    super.key,
    required this.total,
    required this.current,
  });

  final int total;

  /// Índice (0-based) da pergunta atual.
  final int current;

  @override
  Widget build(BuildContext context) {
    final gap = total > 8 ? 6.0 : 12.0;
    return Row(
      children: [
        for (var i = 0; i < total; i++)
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: i == 0 ? 0 : gap),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                height: 6,
                decoration: BoxDecoration(
                  color: i <= current ? AppColors.primary : AppColors.stepInactive,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
