import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../data/models/assessment.dart';
import '../../routing/routes.dart';
import '../core/theme/app_theme.dart';
import '../core/widgets/tdah_logo.dart';
import '../quiz/view_model/quiz_view_model.dart';

/// Tela inicial: catálogo de testes disponíveis para o usuário escolher.
class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<QuizViewModel>();

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
          children: [
            const TdahLogo(),
            const SizedBox(height: 20),
            const Text(
              'Escolha um teste',
              style: TextStyle(
                color: AppColors.navy,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Selecione a avaliação que deseja fazer.',
              style: TextStyle(color: AppColors.optionText, fontSize: 14),
            ),
            const SizedBox(height: 20),
            if (viewModel.hasSavedProgress) ...[
              _ResumeBanner(
                name: viewModel.resumeAssessmentName ?? 'teste',
                location: viewModel.resumeLocation!,
              ),
              const SizedBox(height: 16),
            ],
            for (final assessment in viewModel.catalog) ...[
              _AssessmentCard(
                assessment: assessment,
                onTap: () {
                  viewModel.selectAssessment(assessment);
                  context.go(Routes.intro);
                },
              ),
              const SizedBox(height: 12),
            ],
            const SizedBox(height: 8),
            const Text(
              'Nenhum teste é diagnóstico, apenas um ponto de partida.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.optionText, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class _AssessmentCard extends StatelessWidget {
  const _AssessmentCard({required this.assessment, required this.onTap});

  final Assessment assessment;
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
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.optionBorder),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.selectedBg,
                ),
                child: Icon(assessment.icon, size: 24, color: AppColors.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            assessment.name,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.navy,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.selectedBg,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Text(
                            assessment.audience,
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      assessment.subtitle,
                      style: const TextStyle(
                        color: AppColors.optionText,
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.schedule,
                            size: 14, color: AppColors.optionText),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            '≈${assessment.estimatedMinutes} min · '
                            '${assessment.totalQuestions} perguntas',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.optionText,
                              fontSize: 11.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Icon(Icons.chevron_right, color: AppColors.primary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResumeBanner extends StatelessWidget {
  const _ResumeBanner({required this.name, required this.location});

  final String name;
  final String location;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.selectedBg,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => context.go(location),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.primary, width: 1.5),
          ),
          child: Row(
            children: [
              const Icon(Icons.history, color: AppColors.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Continuar de onde parei',
                      style: TextStyle(
                        color: AppColors.navy,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      name,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward, color: AppColors.primary),
            ],
          ),
        ),
      ),
    );
  }
}
