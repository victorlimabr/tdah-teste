import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Logo "TD / AH" em duas linhas, no canto superior esquerdo das telas.
class TdahLogo extends StatelessWidget {
  const TdahLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'TD',
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 24,
            fontWeight: FontWeight.w700,
            height: 1.1,
          ),
        ),
        Text(
          'AH',
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 24,
            fontWeight: FontWeight.w700,
            height: 1.1,
          ),
        ),
      ],
    );
  }
}
