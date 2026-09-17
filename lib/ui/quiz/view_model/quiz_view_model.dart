import 'package:flutter/foundation.dart';

import '../../../data/models/question.dart';
import '../../../data/models/quiz_progress.dart';
import '../../../data/models/quiz_result.dart';
import '../../../data/repositories/question_repository.dart';
import '../../../data/repositories/quiz_progress_repository.dart';
import '../../../routing/routes.dart';

/// ViewModel do fluxo do teste (MVVM).
///
/// Mantém as respostas, a posição atual no fluxo e o estado derivado
/// (resultado, rastreio). Persiste o progresso a cada mudança para permitir
/// retomar de onde o usuário parou. Compartilhado por todas as telas do teste.
class QuizViewModel extends ChangeNotifier {
  QuizViewModel(this._questionRepository, this._progressRepository) {
    _answers = List<int?>.filled(_questionRepository.questions.length, null);
  }

  final QuestionRepository _questionRepository;
  final QuizProgressRepository _progressRepository;

  late List<int?> _answers;
  bool _loaded = false;
  QuizProgress? _saved;
  String? _currentLocation;
  int _currentQuestionIndex = 0;

  // ---- Perguntas ----

  List<Question> get partA => _questionRepository.partA;
  List<Question> get partB => _questionRepository.partB;

  int? answerFor(Question q) => _answers[q.number - 1];
  bool isAnswered(Question q) => _answers[q.number - 1] != null;

  // ---- Retomada ----

  /// Se o progresso salvo já foi carregado do armazenamento.
  bool get isLoaded => _loaded;

  /// Se há um teste em andamento que pode ser retomado.
  bool get hasSavedProgress =>
      _saved != null && _saved!.location != Routes.onboarding;

  /// Rota para onde retomar o teste.
  String? get resumeLocation => _saved?.location;

  /// Índice do cartão salvo (dentro da parte).
  int get resumeQuestionIndex => _saved?.questionIndex ?? 0;

  /// Posição atual (usada pela QuizScreen para reabrir no cartão certo).
  String? get currentLocation => _currentLocation;
  int get currentQuestionIndex => _currentQuestionIndex;

  /// Carrega o progresso salvo (chamado no início do app).
  Future<void> load() async {
    final saved = await _progressRepository.load();
    if (saved != null && saved.answers.length == _answers.length) {
      _answers = List<int?>.of(saved.answers);
      _currentLocation = saved.location;
      _currentQuestionIndex = saved.questionIndex;
      _saved = saved;
    }
    _loaded = true;
    notifyListeners();
  }

  // ---- Commands ----

  /// Registra a resposta de uma pergunta e persiste o progresso.
  void selectAnswer(Question q, int value) {
    _answers[q.number - 1] = value;
    notifyListeners();
    _persist();
  }

  /// Atualiza a posição atual (rota + índice do cartão) e persiste.
  void setPosition(String location, int questionIndex) {
    _currentLocation = location;
    _currentQuestionIndex = questionIndex;
    _persist();
  }

  /// Reinicia o teste (nova tentativa) e apaga o progresso salvo.
  Future<void> reset() async {
    _answers = List<int?>.filled(_questionRepository.questions.length, null);
    _currentLocation = null;
    _currentQuestionIndex = 0;
    _saved = null;
    await _progressRepository.clear();
    notifyListeners();
  }

  /// Limpa o progresso salvo (usado ao concluir o teste).
  Future<void> clearProgress() async {
    _saved = null;
    _currentLocation = null;
    _currentQuestionIndex = 0;
    await _progressRepository.clear();
    notifyListeners();
  }

  void _persist() {
    final progress = QuizProgress(
      answers: List<int?>.of(_answers),
      location: _currentLocation ?? Routes.onboarding,
      questionIndex: _currentQuestionIndex,
      updatedAt: DateTime.now(),
    );
    _saved = progress;
    _progressRepository.save(progress);
  }

  // ---- Estado derivado ----

  bool get isPartAScreenPositive {
    var shaded = 0;
    for (final q in partA) {
      final v = _answers[q.number - 1] ?? 0;
      if (v >= q.shadedFrom) shaded++;
    }
    return shaded >= QuizResult.partAThreshold;
  }

  QuizResult get result =>
      QuizResult.fromAnswers(_questionRepository.questions, _answers);

  /// Mensagem para compartilhar o resultado (texto condicional à triagem).
  String shareMessage() {
    final verdict = result.isScreenPositive
        ? 'a triagem indicou compatibilidade com sintomas de TDAH — vale '
            'procurar uma avaliação profissional.'
        : 'a triagem não indicou um número significativo de sintomas.';
    return 'Fiz a autoavaliação de sintomas de TDAH (escala ASRS-18). '
        'No meu resultado, $verdict\n\n'
        '⚠️ Este teste não é um diagnóstico. Só um profissional de saúde '
        'pode diagnosticar TDAH.';
  }
}
