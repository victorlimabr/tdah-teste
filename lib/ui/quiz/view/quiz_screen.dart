import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/models/question.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_buttons.dart';
import '../../core/widgets/indicators.dart';
import '../view_model/quiz_view_model.dart';
import 'result_screen.dart';
import 'transition_screen.dart';

/// Tela de perguntas de uma parte do teste (A ou B).
///
/// Um card por pergunta, navegável por deslize e pelo botão inferior.
/// As respostas são lidas e escritas no [QuizViewModel] compartilhado.
class QuizScreen extends StatefulWidget {
  const QuizScreen({
    super.key,
    required this.questions,
    required this.partLabel,
    this.isLastPart = false,
  });

  final List<Question> questions;
  final String partLabel;

  /// Quando true, ao concluir vai para o resultado; senão, para a transição.
  final bool isLastPart;

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final PageController _controller = PageController();
  int _page = 0;

  Question get _current => widget.questions[_page];
  bool get _isLastQuestion => _page == widget.questions.length - 1;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (!_isLastQuestion) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
      return;
    }
    // Conclusão da parte.
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) =>
            widget.isLastPart ? const ResultScreen() : const TransitionScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<QuizViewModel>();
    final currentAnswered = viewModel.answerFor(_current) != null;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 24, 0, 24),
                child: StepsIndicator(
                  total: widget.questions.length,
                  current: _page,
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: widget.questions.length,
                  onPageChanged: (i) => setState(() => _page = i),
                  itemBuilder: (context, index) {
                    final q = widget.questions[index];
                    return _QuestionPage(
                      partLabel: widget.partLabel,
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
                  onPressed: currentAnswered ? _next : null,
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
