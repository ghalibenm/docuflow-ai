import 'package:flutter/material.dart';

import '../models/models.dart';

abstract final class AppColors {
  static const ink = Color(0xFF14221E);
  static const inkSoft = Color(0xFF56645E);
  static const inkMuted = Color(0xFF89938F);
  static const primary = Color(0xFF0E6B57);
  static const primaryDeep = Color(0xFF0A4437);
  static const primaryDark = Color(0xFF072A23);
  static const mint = Color(0xFFDDEFE7);
  static const mintDeep = Color(0xFFBFE3D6);
  static const amber = Color(0xFFDDA23F);
  static const amberDeep = Color(0xFF96651A);
  static const amberSoft = Color(0xFFFBF0DA);
  static const paper = Color(0xFFF5F3EC);
  static const paperDeep = Color(0xFFEDE9DF);
  static const surface = Color(0xFFFFFFFF);
  static const line = Color(0xFFE5E1D6);
  static const lineStrong = Color(0xFFD6D0C1);
  static const danger = Color(0xFFB3473D);
  static const dangerSoft = Color(0xFFFAE7E3);
  static const blue = Color(0xFF356C8A);
  static const blueSoft = Color(0xFFE3EEF4);
  static const violet = Color(0xFF6B5B95);
  static const violetSoft = Color(0xFFEDE9F6);

  static Color kindColor(DocumentKind kind) {
    switch (kind) {
      case DocumentKind.invoice:
        return primary;
      case DocumentKind.supplierForm:
        return blue;
      case DocumentKind.deliveryNote:
        return amberDeep;
      case DocumentKind.custom:
        return violet;
    }
  }

  static Color kindSoftColor(DocumentKind kind) {
    switch (kind) {
      case DocumentKind.invoice:
        return mint;
      case DocumentKind.supplierForm:
        return blueSoft;
      case DocumentKind.deliveryNote:
        return amberSoft;
      case DocumentKind.custom:
        return violetSoft;
    }
  }

  static Color statusColor(DocumentStatus status) {
    switch (status) {
      case DocumentStatus.pending:
        return amberDeep;
      case DocumentStatus.validated:
        return primary;
      case DocumentStatus.rejected:
        return danger;
    }
  }

  static Color statusSoftColor(DocumentStatus status) {
    switch (status) {
      case DocumentStatus.pending:
        return amberSoft;
      case DocumentStatus.validated:
        return mint;
      case DocumentStatus.rejected:
        return dangerSoft;
    }
  }

  static Color confidenceColor(double confidence) {
    if (confidence >= 0.9) return primary;
    if (confidence >= 0.8) return amberDeep;
    return danger;
  }

  static Color confidenceSoftColor(double confidence) {
    if (confidence >= 0.9) return mint;
    if (confidence >= 0.8) return amberSoft;
    return dangerSoft;
  }
}

abstract final class AppLayout {
  static const maxContentWidth = 1240.0;
  static const pagePadding = 28.0;
  static const sidebarWidth = 254.0;
  static const radius = 20.0;
  static const radiusSmall = 14.0;
}

ThemeData buildAppTheme() {
  final base = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamilyFallback: const [
      'Noto Sans Arabic',
      'Geeza Pro',
      'Tahoma',
      'Arial',
    ],
  );

  final colorScheme =
      ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
      ).copyWith(
        primary: AppColors.primary,
        onPrimary: Colors.white,
        primaryContainer: AppColors.mint,
        onPrimaryContainer: AppColors.primaryDeep,
        secondary: AppColors.amber,
        onSecondary: AppColors.ink,
        secondaryContainer: AppColors.amberSoft,
        onSecondaryContainer: AppColors.amberDeep,
        surface: AppColors.surface,
        onSurface: AppColors.ink,
        surfaceContainerHighest: AppColors.paperDeep,
        outline: AppColors.lineStrong,
        outlineVariant: AppColors.line,
        error: AppColors.danger,
        onError: Colors.white,
        errorContainer: AppColors.dangerSoft,
        onErrorContainer: AppColors.danger,
      );

  final textTheme = base.textTheme.copyWith(
    displayLarge: base.textTheme.displayLarge?.copyWith(
      color: AppColors.ink,
      fontWeight: FontWeight.w700,
      letterSpacing: -1.6,
      height: 1.04,
    ),
    displayMedium: base.textTheme.displayMedium?.copyWith(
      color: AppColors.ink,
      fontWeight: FontWeight.w700,
      letterSpacing: -1.1,
      height: 1.08,
    ),
    headlineLarge: base.textTheme.headlineLarge?.copyWith(
      color: AppColors.ink,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.7,
      height: 1.15,
    ),
    headlineMedium: base.textTheme.headlineMedium?.copyWith(
      color: AppColors.ink,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.5,
    ),
    titleLarge: base.textTheme.titleLarge?.copyWith(
      color: AppColors.ink,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.2,
    ),
    titleMedium: base.textTheme.titleMedium?.copyWith(
      color: AppColors.ink,
      fontWeight: FontWeight.w600,
    ),
    bodyLarge: base.textTheme.bodyLarge?.copyWith(
      color: AppColors.ink,
      height: 1.5,
    ),
    bodyMedium: base.textTheme.bodyMedium?.copyWith(
      color: AppColors.inkSoft,
      height: 1.5,
    ),
    bodySmall: base.textTheme.bodySmall?.copyWith(
      color: AppColors.inkMuted,
      height: 1.45,
    ),
    labelLarge: base.textTheme.labelLarge?.copyWith(
      color: AppColors.ink,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.1,
    ),
    labelMedium: base.textTheme.labelMedium?.copyWith(
      color: AppColors.inkSoft,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.4,
    ),
    labelSmall: base.textTheme.labelSmall?.copyWith(
      color: AppColors.inkMuted,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.6,
    ),
  );

  return base.copyWith(
    colorScheme: colorScheme,
    scaffoldBackgroundColor: AppColors.paper,
    canvasColor: AppColors.paper,
    textTheme: textTheme,
    dividerColor: AppColors.line,
    iconTheme: const IconThemeData(color: AppColors.inkSoft, size: 20),
    cardTheme: const CardThemeData(
      color: AppColors.surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(AppLayout.radius)),
        side: BorderSide(color: AppColors.line),
      ),
    ),
    inputDecorationTheme: InputDecorationThemeData(
      filled: true,
      fillColor: AppColors.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      hintStyle: const TextStyle(
        color: AppColors.inkMuted,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      labelStyle: const TextStyle(
        color: AppColors.inkSoft,
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.line),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.line),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.6),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.danger),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.danger, width: 1.6),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        disabledBackgroundColor: AppColors.lineStrong,
        disabledForegroundColor: AppColors.inkMuted,
        minimumSize: const Size(0, 48),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppLayout.radiusSmall),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.ink,
        minimumSize: const Size(0, 48),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        side: const BorderSide(color: AppColors.lineStrong),
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppLayout.radiusSmall),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      height: 68,
      elevation: 0,
      backgroundColor: AppColors.surface,
      indicatorColor: AppColors.mint,
      surfaceTintColor: Colors.transparent,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return TextStyle(
          color: selected ? AppColors.primaryDeep : AppColors.inkMuted,
          fontSize: 11.5,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return IconThemeData(
          color: selected ? AppColors.primary : AppColors.inkMuted,
          size: 23,
        );
      }),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.primary,
      linearTrackColor: AppColors.mint,
    ),
    scrollbarTheme: ScrollbarThemeData(
      thickness: const WidgetStatePropertyAll(6),
      radius: const Radius.circular(8),
      thumbColor: WidgetStatePropertyAll(AppColors.ink.withValues(alpha: 0.18)),
    ),
    splashFactory: InkSparkle.splashFactory,
  );
}
