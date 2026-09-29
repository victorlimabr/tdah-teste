import '../assessments/asrs18.dart';
import '../assessments/snap18.dart';
import '../models/assessment.dart';

/// Catálogo dos testes disponíveis.
abstract class AssessmentRepository {
  List<Assessment> get all;
  Assessment? byId(String id);
}

class DefaultAssessmentRepository implements AssessmentRepository {
  DefaultAssessmentRepository()
      : _all = [Asrs18Assessment(), Snap18Assessment()];

  final List<Assessment> _all;

  @override
  List<Assessment> get all => _all;

  @override
  Assessment? byId(String id) {
    for (final a in _all) {
      if (a.id == id) return a;
    }
    return null;
  }
}
