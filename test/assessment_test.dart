import 'package:flutter_test/flutter_test.dart';

import 'package:tdah_teste/data/assessments/asrs18.dart';
import 'package:tdah_teste/data/assessments/snap18.dart';

void main() {
  group('ASRS-18', () {
    final asrs = Asrs18Assessment();

    test('tem 18 perguntas, Parte A com 6 e Parte B com 12', () {
      expect(asrs.totalQuestions, 18);
      expect(asrs.sections[0].questions.length, 6);
      expect(asrs.sections[1].questions.length, 12);
    });

    test('"Às vezes" em tudo não atinge o rastreio da Parte A (só 3)', () {
      final result = asrs.buildResult(List<int?>.filled(18, 2));
      expect(result.sectionById('A').count, 3);
      expect(result.isPositive, isFalse);
    });

    test('"Muito frequentemente" em tudo dá rastreio positivo', () {
      final result = asrs.buildResult(List<int?>.filled(18, 4));
      expect(result.sectionById('A').count, 6);
      expect(result.isPositive, isTrue);
    });
  });

  group('SNAP-IV', () {
    final snap = Snap18Assessment();

    test('tem 18 itens em duas subescalas de 9', () {
      expect(snap.totalQuestions, 18);
      expect(snap.sections[0].questions.length, 9);
      expect(snap.sections[1].questions.length, 9);
      expect(snap.needsRespondent, isTrue);
      expect(snap.scale.length, 4);
    });

    test('"Bastante" (>=2) em tudo atinge as duas subescalas', () {
      final result = snap.buildResult(List<int?>.filled(18, 2));
      expect(result.sectionById('inatt').count, 9);
      expect(result.sectionById('hyper').count, 9);
      expect(result.isPositive, isTrue);
    });

    test('"Só um pouco" (1) em tudo não atinge nenhuma subescala', () {
      final result = snap.buildResult(List<int?>.filled(18, 1));
      expect(result.sectionById('inatt').count, 0);
      expect(result.sectionById('hyper').count, 0);
      expect(result.isPositive, isFalse);
    });
  });
}
