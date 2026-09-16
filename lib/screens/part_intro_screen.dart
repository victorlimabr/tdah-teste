import 'package:flutter/material.dart';

import '../models/quiz_session.dart';
import '../theme/app_theme.dart';
import '../widgets/app_buttons.dart';
import '../widgets/highlight_text.dart';
import '../widgets/tdah_logo.dart';
import 'quiz_screen.dart';

/// Tela de introdução da Parte A, com a ilustração e o resumo do que vem.
class PartIntroScreen extends StatelessWidget {
  const PartIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                    Image.asset('assets/images/group_hug.png', height: 240),
                    const SizedBox(height: 40),
                    const Text(
                      'Parte A',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const HighlightText([
                      Seg('Contém '),
                      Seg('6 questões centrais', hl: true),
                      Seg(', consideradas mais relevantes para '),
                      Seg('identificar sintomas', hl: true),
                      Seg(' do TDAH em adultos.'),
                    ]),
                  ],
                ),
              ),
              PrimaryButton(
                label: 'Começar o teste',
                onPressed: () {
                  final session = QuizSession();
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => QuizScreen(
                        session: session,
                        questions: session.partA,
                        partLabel: 'Parte A',
                      ),
                    ),
                  );
                },
              ),
              TextLinkButton(
                label: 'Sair',
                onPressed: () =>
                    Navigator.of(context).popUntil((r) => r.isFirst),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
