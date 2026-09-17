import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/quiz_progress.dart';

/// Fonte da verdade do progresso salvo do teste.
abstract class QuizProgressRepository {
  /// Carrega o progresso salvo, ou `null` se não houver.
  Future<QuizProgress?> load();

  /// Salva o progresso atual.
  Future<void> save(QuizProgress progress);

  /// Apaga o progresso salvo.
  Future<void> clear();
}

/// Implementação usando `shared_preferences` (armazenamento local do aparelho).
class SharedPrefsQuizProgressRepository implements QuizProgressRepository {
  static const _key = 'quiz_progress';

  @override
  Future<QuizProgress?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return null;
    try {
      return QuizProgress.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> save(QuizProgress progress) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(progress.toJson()));
  }

  @override
  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
