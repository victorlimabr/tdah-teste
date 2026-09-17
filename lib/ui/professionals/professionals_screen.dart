import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/services/url_launcher_service.dart';
import '../core/theme/app_theme.dart';
import 'professionals_view_model.dart';

/// Especialidades sugeridas para busca no mapa.
const _specialties = <(String, IconData)>[
  ('Psiquiatra', Icons.medical_services_outlined),
  ('Psicólogo', Icons.psychology_outlined),
  ('Neurologista', Icons.emoji_objects_outlined),
];

/// Diretórios oficiais (título, subtítulo, url).
const _directories = <(String, String, String)>[
  (
    'Cadastro Nacional de Psicólogos',
    'cadastro.cfp.org.br',
    'https://cadastro.cfp.org.br/',
  ),
  (
    'Conselho Federal de Medicina',
    'portal.cfm.org.br',
    'https://portal.cfm.org.br/',
  ),
];

/// Tela "Encontrar profissionais": busca no mapa por especialidade, links
/// para diretórios oficiais e contato de apoio emocional.
class ProfessionalsScreen extends StatelessWidget {
  const ProfessionalsScreen({super.key});

  Future<void> _launch(BuildContext context, Future<bool> action) async {
    final ok = await action;
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível abrir o link.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ProfessionalsViewModel(context.read<UrlLauncherService>());

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: AppColors.navy),
        title: const Text(
          'Encontrar profissionais',
          style: TextStyle(
            color: AppColors.navy,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          children: [
            const Text(
              'Busque um especialista perto de você para uma avaliação '
              'completa.',
              style: TextStyle(
                color: AppColors.optionText,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            const _SectionLabel('Buscar no mapa por'),
            for (final (label, icon) in _specialties)
              _OptionCard(
                icon: icon,
                title: label,
                subtitle: 'abrir no mapa',
                trailing: Icons.place_outlined,
                onTap: () => _launch(context, viewModel.searchNearby(label)),
              ),
            const SizedBox(height: 16),
            const _SectionLabel('Diretórios oficiais'),
            for (final (title, subtitle, url) in _directories)
              _OptionCard(
                icon: Icons.verified_outlined,
                title: title,
                subtitle: subtitle,
                trailing: Icons.open_in_new,
                onTap: () => _launch(context, viewModel.openDirectory(url)),
              ),
            const SizedBox(height: 16),
            _SupportCard(
              onTap: () => _launch(context, viewModel.callSupport()),
            ),
            const SizedBox(height: 16),
            const Text(
              'Estas são sugestões de busca, não uma indicação de '
              'profissionais específicos.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.optionText,
                fontSize: 12,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          color: AppColors.optionText,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  const _OptionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final IconData trailing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.optionBorder),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.selectedBg,
                  ),
                  child: Icon(icon, size: 22, color: AppColors.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: AppColors.navy,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: AppColors.optionText,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(trailing, size: 19, color: AppColors.primary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SupportCard extends StatelessWidget {
  const _SupportCard({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.selectedBg,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              const Icon(Icons.call, color: AppColors.primary),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Apoio emocional · CVV 188',
                      style: TextStyle(
                        color: AppColors.navy,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'gratuito e sigiloso, 24h',
                      style: TextStyle(color: AppColors.primary, fontSize: 12),
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
