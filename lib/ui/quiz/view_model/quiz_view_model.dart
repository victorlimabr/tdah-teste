import 'package:flutter/foundation.dart';

import '../../../data/models/assessment.dart';
import '../../../data/models/question.dart';
import '../../../data/models/quiz_progress.dart';
import '../../../data/repositories/assessment_repository.dart';
import '../../../data/repositories/quiz_progress_repository.dart';
import '../../../routing/routes.dart';

/// ViewModel do fluxo de um teste (MVVM), dirigido pelo [Assessment]
/// selecionado. Mantém respostas, posição e progresso persistido.
class QuizViewModel extends ChangeNotifier {
  QuizViewModel(this._assessments, this._progressRepository);

  final AssessmentRepository _assessments;
  final QuizProgressRepository _progressRepository;

  Assessment? _assessment;
  List<int?> _answers = const [];
  String? _respondent;
  bool _loaded = false;
  QuizProgress? _saved;
  String? _currentLocation;
  int _currentQuestionIndex = 0;

  // ---- Catálogo / seleção ----

  List<Assessment> get catalog => _assessments.all;
  Assessment? get assessment => _assessment;

  /// Inicia um teste do zero.
  void selectAssessment(Assessment a) {
    _assessment = a;
    _answers = List<int?>.filled(a.totalQuestions, null);
    _respondent = null;
    _currentLocation = null;
    _currentQuestionIndex = 0;
    notifyListeners();
  }

  // ---- Perguntas / respostas ----

  List<String> get scale => _assessment!.scale;
  List<Section> get sections => _assessment!.sections;
  String? get respondent => _respondent;

  int? answerFor(Question q) => _answers[q.number - 1];
  bool isAnswered(Question q) => _answers[q.number - 1] != null;

  void selectAnswer(Question q, int value) {
    _answers[q.number - 1] = value;
    notifyListeners();
    _persist();
  }

  void setRespondent(String value) {
    _respondent = value;
    _persist();
    notifyListeners();
  }

  void setPosition(String location, int questionIndex) {
    _currentLocation = location;
    _currentQuestionIndex = questionIndex;
    _persist();
  }

  // ---- Resultado ----

  AssessmentResult get result => _assessment!.buildResult(_answers);
  String shareMessage() => _assessment!.shareMessage(result);

  // ---- Retomada ----

  bool get isLoaded => _loaded;
  bool get hasSavedProgress =>
      _saved != null && _saved!.location != Routes.catalog;
  String? get resumeLocation => _saved?.location;
  int get resumeQuestionIndex => _saved?.questionIndex ?? 0;
  String? get resumeAssessmentName {
    final id = _saved?.assessmentId;
    return id == null ? null : _assessments.byId(id)?.name;
  }

  String? get currentLocation => _currentLocation;
  int get currentQuestionIndex => _currentQuestionIndex;

  Future<void> load() async {
    final saved = await _progressRepository.load();
    if (saved != null) {
      final a = _assessments.byId(saved.assessmentId);
      if (a != null && saved.answers.length == a.totalQuestions) {
        _assessment = a;
        _answers = List<int?>.of(saved.answers);
        _respondent = saved.respondent;
        _currentLocation = saved.location;
        _currentQuestionIndex = saved.questionIndex;
        _saved = saved;
      }
    }
    _loaded = true;
    notifyListeners();
  }

  Future<void> clearProgress() async {
    _saved = null;
    _currentLocation = null;
    _currentQuestionIndex = 0;
    await _progressRepository.clear();
    notifyListeners();
  }

  void _persist() {
    final a = _assessment;
    if (a == null) return;
    final progress = QuizProgress(
      assessmentId: a.id,
      answers: List<int?>.of(_answers),
      location: _currentLocation ?? Routes.catalog,
      questionIndex: _currentQuestionIndex,
      respondent: _respondent,
      updatedAt: DateTime.now(),
    );
    _saved = progress;
    _progressRepository.save(progress);
  }
}
