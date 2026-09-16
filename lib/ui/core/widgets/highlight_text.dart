import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Um trecho de texto que pode estar em destaque (azul e negrito).
class Seg {
  const Seg(this.text, {this.hl = false});
  final String text;
  final bool hl;
}

/// Parágrafo com trechos destacados em azul/negrito, como no protótipo.
///
/// O texto normal usa [AppColors.navy]; os trechos com `hl: true`
/// usam [AppColors.primary] em negrito.
class HighlightText extends StatelessWidget {
  const HighlightText(
    this.segments, {
    super.key,
    this.fontSize = 14,
    this.height = 2.0,
    this.align = TextAlign.center,
    this.letterSpacing = 0.14,
    this.baseWeight = FontWeight.w400,
  });

  final List<Seg> segments;
  final double fontSize;
  final double height;
  final TextAlign align;
  final double letterSpacing;
  final FontWeight baseWeight;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          for (final s in segments)
            TextSpan(
              text: s.text,
              style: TextStyle(
                color: s.hl ? AppColors.primary : AppColors.navy,
                fontWeight: s.hl ? FontWeight.w700 : baseWeight,
              ),
            ),
        ],
      ),
      textAlign: align,
      style: TextStyle(
        fontSize: fontSize,
        height: height,
        letterSpacing: letterSpacing,
      ),
    );
  }
}
