import 'package:flutter/material.dart';

/// Centraliza os filhos verticalmente quando há espaço disponível e passa a
/// rolar quando o conteúdo não cabe (telas baixas ou em paisagem).
///
/// Mantém a aparência centralizada idêntica em telas altas, mas evita o
/// `RenderFlex overflow` quando a altura é pequena.
class CenteredScrollView extends StatelessWidget {
  const CenteredScrollView({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: children,
            ),
          ),
        );
      },
    );
  }
}
