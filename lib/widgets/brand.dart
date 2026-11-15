import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../models/models.dart';
import '../state/app_state.dart';

class AppLogoMark extends StatelessWidget {
  const AppLogoMark({super.key, this.size = 40, this.onDark = false});

  final double size;
  final bool onDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: onDark
            ? const LinearGradient(
                colors: [Color(0xFF2C947A), Color(0xFF9FD9C5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : const LinearGradient(
                colors: [AppColors.primary, Color(0xFF1C8B73)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        borderRadius: BorderRadius.circular(size * 0.29),
        boxShadow: onDark
            ? null
            : [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.22),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.description_rounded,
            color: onDark ? AppColors.primaryDark : Colors.white,
            size: size * 0.5,
          ),
          Positioned(
            top: size * 0.2,
            right: size * 0.18,
            child: Icon(
              Icons.auto_awesome_rounded,
              color: onDark ? Colors.white : const Color(0xFFF4CF8A),
              size: size * 0.24,
            ),
          ),
        ],
      ),
    );
  }
}

class AppWordmark extends StatelessWidget {
  const AppWordmark({
    super.key,
    this.onDark = false,
    this.showTagline = true,
    this.markSize = 40,
  });

  final bool onDark;
  final bool showTagline;
  final double markSize;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppLogoMark(size: markSize, onDark: onDark),
        const SizedBox(width: 12),
        Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                state.text.appName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: onDark ? Colors.white : AppColors.ink,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                ),
              ),
              if (showTagline)
                Text(
                  state.text.appTagline,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: onDark
                        ? Colors.white.withValues(alpha: 0.55)
                        : AppColors.inkMuted,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.3,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class LanguageToggle extends StatelessWidget {
  const LanguageToggle({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final height = compact ? 32.0 : 36.0;
    final width = compact ? 32.0 : 37.0;

    Widget segment(AppLanguage language) {
      final selected = state.language == language;
      return Semantics(
        button: true,
        selected: selected,
        label: language == AppLanguage.fr ? 'Français' : 'العربية',
        child: InkWell(
          onTap: () => state.setLanguage(language),
          borderRadius: BorderRadius.circular(8),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: width,
            height: height - 8,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected ? AppColors.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              language.toggleLabel,
              style: TextStyle(
                color: selected ? Colors.white : AppColors.inkMuted,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      );
    }

    return Tooltip(
      message: state.language.isArabic ? 'Français' : 'العربية',
      child: Container(
        height: height,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(11),
          border: Border.all(color: AppColors.line),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            segment(AppLanguage.fr),
            const SizedBox(width: 2),
            segment(AppLanguage.ar),
          ],
        ),
      ),
    );
  }
}
