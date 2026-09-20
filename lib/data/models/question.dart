/// Uma pergunta de um teste, genérica o suficiente para vários instrumentos.
class Question {
  const Question({
    required this.number,
    required this.text,
    required this.countFrom,
  });

  /// Número global da pergunta dentro do teste (1-based).
  final int number;

  /// Enunciado da pergunta.
  final String text;

  /// A resposta conta para a seção quando o índice escolhido é maior ou igual
  /// a este valor (ASRS: "área sombreada"; SNAP: 2 = "Bastante"/"Demais").
  final int countFrom;
}
