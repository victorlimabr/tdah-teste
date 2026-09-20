/// Trecho de texto que pode estar em destaque (usado em textos com ênfase).
class Seg {
  const Seg(this.text, {this.hl = false});
  final String text;
  final bool hl;
}
