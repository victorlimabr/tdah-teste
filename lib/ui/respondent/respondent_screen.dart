import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../routing/routes.dart';
import '../core/theme/app_theme.dart';
import '../core/widgets/tdah_logo.dart';
import '../quiz/view_model/quiz_view_model.dart';

/// Passo "quem responde" (SNAP-IV): pais/responsável ou professor.
class RespondentScreen extends StatelessWidget {
  const RespondentScreen({super.key});

  static const _options = <(String, IconData, String)>[
    ('Pais ou responsável', Icons.family_restroom, 'Pais'),
    ('Professor(a)', Icons.school_outlined, 'Professor'),
  ];

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<QuizViewModel>();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => context.go(Routes.intro),
                      icon:
                          const Icon(Icons.arrow_back, color: AppColors.navy),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 12),
                    const TdahLogo(),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Quem está respondendo?',
                style: TextStyle(
                  color: AppColors.navy,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Este teste deve ser respondido por quem convive com a criança.',
                style: TextStyle(color: AppColors.optionText, fontSize: 14),
              ),
              const SizedBox(height: 24),
              for (final (label, icon, value) in _options)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _RespondentCard(
                    label: label,
                    icon: icon,
                    onTap: () {
                      viewModel.setRespondent(value);
                      context.go(Routes.quizSection(0));
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RespondentCard extends StatelessWidget {
  const _RespondentCard({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.optionBorder),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.selectedBg,
                ),
                child: Icon(icon, size: 24, color: AppColors.primary),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.navy,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.primary),
            ],
          ),
        ),
      ),
    );
  }
}
