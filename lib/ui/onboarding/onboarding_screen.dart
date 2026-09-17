import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../routing/routes.dart';
import '../core/theme/app_theme.dart';
import '../core/widgets/app_buttons.dart';
import '../core/widgets/highlight_text.dart';
import '../core/widgets/indicators.dart';
import '../core/widgets/tdah_logo.dart';
import '../quiz/view_model/quiz_view_model.dart';

/// Fluxo de introdução: 3 telas deslizáveis (bem-vindo, como funciona,
/// aviso importante), fiéis ao protótipo.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _page = 0;

  static const _labels = ['Próximo', 'Entendido', 'Começar o teste'];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (_page < 2) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      context.go(Routes.intro);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 24, 32, 8),
              child: Row(
                children: [
                  const TdahLogo(),
                  const Spacer(),
                  DotsIndicator(total: 3, current: _page),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                controller: _controller,
                onPageChanged: (i) => setState(() => _page = i),
                children: const [
                  _WelcomePage(),
                  _HowItWorksPage(),
                  _WarningPage(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 8, 32, 24),
              child: PrimaryButton(label: _labels[_page], onPressed: _next),
            ),
          ],
        ),
      ),
    );
  }
}

/// Coluna de conteúdo centralizada que rola apenas se faltar espaço.
class _PageBody extends StatelessWidget {
  const _PageBody({required this.children});
  final List<Widget> children;

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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: children,
            ),
          ),
        );
      },
    );
  }
}

class _Title extends StatelessWidget {
  const _Title(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: AppColors.navy,
        fontSize: 24,
        fontWeight: FontWeight.w700,
        height: 1.25,
      ),
    );
  }
}

class _WelcomePage extends StatelessWidget {
  const _WelcomePage();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<QuizViewModel>();
    return _PageBody(
      children: [
        const SizedBox(height: 8),
        if (viewModel.hasSavedProgress)
          _ResumeBanner(
            location: viewModel.resumeLocation!,
            summary: _resumeSummary(viewModel),
          ),
        const _Title('Bem-vindo ao Teste de sintomas de TDAH!'),
        Image.asset('assets/images/group_hug.png', height: 220),
        const HighlightText([
          Seg('Nosso teste é baseado na '),
          Seg('escala ASRS-18', hl: true),
          Seg(', uma '),
          Seg('ferramenta validada', hl: true),
          Seg(' para '),
          Seg('autoavaliação de sintomas em adultos', hl: true),
          Seg('.'),
        ]),
        const SizedBox(height: 8),
      ],
    );
  }

  String _resumeSummary(QuizViewModel vm) {
    final n = vm.resumeQuestionIndex + 1;
    switch (vm.resumeLocation) {
      case Routes.quizPartA:
        return 'Parte A · pergunta $n de 6';
      case Routes.quizPartB:
        return 'Parte B · pergunta $n de 12';
      case Routes.transition:
        return 'Parte A concluída';
      default:
        return 'Retomar o teste';
    }
  }
}

/// Banner de retomada exibido no topo da tela de boas-vindas quando há um
/// teste em andamento salvo.
class _ResumeBanner extends StatelessWidget {
  const _ResumeBanner({required this.location, required this.summary});

  final String location;
  final String summary;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
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
                        summary,
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
      ),
    );
  }
}

class _HowItWorksPage extends StatelessWidget {
  const _HowItWorksPage();

  @override
  Widget build(BuildContext context) {
    return _PageBody(
      children: [
        const SizedBox(height: 8),
        const _Title('Como funciona o autoteste?'),
        const HighlightText([
          Seg('O teste é dividido em '),
          Seg('duas partes:', hl: true),
        ]),
        const HighlightText(
          [
            Seg('Parte A: ', hl: true),
            Seg('Identifica os sintomas mais comuns.'),
          ],
          height: 1.5,
        ),
        const HighlightText(
          [
            Seg('Parte B: ', hl: true),
            Seg('Explora sintomas complementares.'),
          ],
          height: 1.5,
        ),
        Image.asset('assets/images/onboarding_duo.png', height: 210),
        const HighlightText([
          Seg('Responda com sinceridade às perguntas sobre seu '
              'comportamento, usando a escala: '),
          Seg('Nunca, Raramente, Às vezes, Frequentemente, '
              'Muito frequentemente.', hl: true),
        ]),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _WarningPage extends StatelessWidget {
  const _WarningPage();

  @override
  Widget build(BuildContext context) {
    return _PageBody(
      children: [
        const SizedBox(height: 8),
        const _Title('Aviso Importante'),
        const HighlightText([
          Seg('Este teste é uma '),
          Seg('autoavaliação inicial', hl: true),
          Seg(' e não substitui um diagnóstico profissional.'),
        ]),
        const HighlightText([
          Seg('Se os resultados indicarem possíveis sintomas de TDAH, '
              'recomendamos procurar um '),
          Seg('médico ou psicólogo especializado', hl: true),
          Seg(' para uma avaliação completa.'),
        ]),
        Image.asset('assets/images/onboarding_mirror.png', height: 180),
        const HighlightText([
          Seg('Lembre-se:', hl: true),
          Seg(' o diagnóstico é o primeiro passo para o tratamento e '
              'melhoria da qualidade de vida!'),
        ]),
        const SizedBox(height: 8),
      ],
    );
  }
}
