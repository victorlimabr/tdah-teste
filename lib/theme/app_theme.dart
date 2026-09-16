import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Paleta de cores extraída do protótipo do Figma.
class AppColors {
  const AppColors._();

  /// Fundo creme/off-white (#FFFFF6).
  static const Color cream = Color(0xFFFFFFF6);

  /// Azul primário dos botões, destaques e progresso (#495AFF).
  static const Color primary = Color(0xFF495AFF);

  /// Azul-marinho dos títulos e textos (#131F5A).
  static const Color navy = Color(0xFF131F5A);

  /// Azul claro dos passos inativos (#A8BCF0).
  static const Color stepInactive = Color(0xFFA8BCF0);

  /// Borda das opções não selecionadas (#CFD6DC).
  static const Color optionBorder = Color(0xFFCFD6DC);

  /// Texto das opções não selecionadas (#ABB7C2).
  static const Color optionText = Color(0xFFABB7C2);

  /// Fundo da opção selecionada e do botão tonal (#F0F4FF).
  static const Color selectedBg = Color(0xFFF0F4FF);
}

/// Tema Material 3 do app, fiel ao design (claro, fonte Inter).
class AppTheme {
  const AppTheme._();

  static ThemeData light() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      brightness: Brightness.light,
    ).copyWith(surface: AppColors.cream);

    final base = ThemeData(useMaterial3: true, colorScheme: colorScheme);

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.cream,
      textTheme: GoogleFonts.interTextTheme(base.textTheme).apply(
        bodyColor: AppColors.navy,
        displayColor: AppColors.navy,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.cream,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }
}
