import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../data/models/question.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_buttons.dart';
import '../../core/widgets/indicators.dart';
import '../view_model/quiz_view_model.dart';

/// Parte do teste exibida pela [QuizScreen].
enum QuizPart { a, b }

/// Tela de perguntas de uma parte do teste (A ou B).
///
/// Um card por pergunta, navegável por deslize e pelo botão inferior.
/// As perguntas e respostas vêm do [QuizViewModel] compartilhado.
class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key, required this.part});

  final QuizPart part;

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final PageController _controller = PageController();
  int _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<QuizViewModel>();
    final isPartA = widget.part == QuizPart.a;
    final questions = isPartA ? viewModel.partA : viewModel.partB;
    final partLabel = isPartA ? 'Parte A' : 'Parte B';

    final current = questions[_page];
    final currentAnswered = viewModel.answerFor(current) != null;
    final isLastQuestion = _page == questions.length - 1;

    void onNext() {
      if (!isLastQuestion) {
        _controller.nextPage(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
        );
        return;
      }
      // Conclusão da parte: Parte A -> transição; Parte B -> resultado.
      context.go(isPartA ? '/transition' : '/result');
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 24, 0, 24),
                child: StepsIndicator(total: questions.length, current: _page),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: questions.length,
                  onPageChanged: (i) => setState(() => _page = i),
                  itemBuilder: (context, index) {
                    final q = questions[index];
                    return _QuestionPage(
                      partLabel: partLabel,
                      question: q,
                      selected: viewModel.answerFor(q),
                      onSelected: (v) => viewModel.selectAnswer(q, v),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 24),
                child: PrimaryButton(
                  label: 'Próxima pergunta',
                  onPressed: currentAnswered ? onNext : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuestionPage extends StatelessWidget {
  const _QuestionPage({
    required this.partLabel,
    required this.question,
    required this.selected,
    required this.onSelected,
  });

  final String partLabel;
  final Question question;
  final int? selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            partLabel,
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.6,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            question.text,
            style: const TextStyle(
              color: AppColors.navy,
              fontSize: 24,
              fontWeight: FontWeight.w700,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 40),
          for (var i = 0; i < kAnswerOptions.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _OptionTile(
                label: kAnswerOptions[i],
                selected: selected == i,
                onTap: () => onSelected(i),
              ),
            ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.selectedBg : Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 16),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.optionBorder,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
              color: selected ? AppColors.primary : AppColors.optionText,
            ),
          ),
        ),
      ),
    );
  }
}
