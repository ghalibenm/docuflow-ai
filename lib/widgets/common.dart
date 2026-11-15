import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../models/models.dart';
import '../state/app_state.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(22),
    this.color = AppColors.surface,
    this.radius = AppLayout.radius,
    this.border = true,
    this.shadow = true,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color color;
  final double radius;
  final bool border;
  final bool shadow;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
        border: border ? Border.all(color: AppColors.line) : null,
        boxShadow: shadow
            ? [
                BoxShadow(
                  color: AppColors.ink.withValues(alpha: 0.025),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ]
            : null,
      ),
      child: child,
    );
  }
}

class PageHeading extends StatelessWidget {
  const PageHeading({
    super.key,
    required this.title,
    this.subtitle,
    this.eyebrow,
    this.actions,
  });

  final String title;
  final String? subtitle;
  final String? eyebrow;
  final Widget? actions;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final narrow = constraints.maxWidth < 760;
        final heading = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (eyebrow != null) ...[
              Text(
                eyebrow!.toUpperCase(),
                style: const TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.4,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 8),
            ],
            Text(
              title,
              style: Theme.of(context).textTheme.headlineLarge
                  ?.copyWith(fontSize: narrow ? 27 : 34),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 680),
                child: Text(
                  subtitle!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 14,
                    color: AppColors.inkSoft,
                    height: 1.55,
                  ),
                ),
              ),
            ],
          ],
        );

        if (actions == null) return heading;
        if (narrow) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [heading, const SizedBox(height: 18), actions!],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(child: heading),
            const SizedBox(width: 24),
            actions!,
          ],
        );
      },
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    super.key,
    required this.title,
    this.subtitle,
    this.count,
    this.action,
  });

  final String title;
  final String? subtitle;
  final int? count;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium
                          ?.copyWith(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                  ),
                  if (count != null) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.paperDeep,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '$count',
                        style: const TextStyle(
                          color: AppColors.inkSoft,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle!,
                  style: const TextStyle(
                    color: AppColors.inkMuted,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (action != null) ...[const SizedBox(width: 12), action!],
      ],
    );
  }
}

class Pill extends StatelessWidget {
  const Pill({
    super.key,
    required this.label,
    this.color = AppColors.inkSoft,
    this.background = AppColors.paperDeep,
    this.icon,
    this.iconSize = 12,
    this.dense = false,
  });

  final String label;
  final Color color;
  final Color background;
  final IconData? icon;
  final double iconSize;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: dense ? 7 : 9,
        vertical: dense ? 3 : 4.5,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: iconSize, color: color),
            const SizedBox(width: 4),
          ],
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: dense ? 10.5 : 11.5,
                fontWeight: FontWeight.w600,
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StatusPill extends StatelessWidget {
  const StatusPill({super.key, required this.status, this.dense = false});

  final DocumentStatus status;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final color = AppColors.statusColor(status);
    final IconData icon;
    switch (status) {
      case DocumentStatus.pending:
        icon = Icons.schedule_rounded;
      case DocumentStatus.validated:
        icon = Icons.check_circle_rounded;
      case DocumentStatus.rejected:
        icon = Icons.cancel_rounded;
    }
    return Pill(
      label: state.text.statusLabel(status),
      color: color,
      background: AppColors.statusSoftColor(status),
      icon: icon,
      dense: dense,
    );
  }
}

class ConfidencePill extends StatelessWidget {
  const ConfidencePill({
    super.key,
    required this.confidence,
    this.dense = false,
  });

  final double confidence;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final color = AppColors.confidenceColor(confidence);
    return Tooltip(
      message: state.text.validationConfidence,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: dense ? 7 : 9,
          vertical: dense ? 3 : 4.5,
        ),
        decoration: BoxDecoration(
          color: AppColors.confidenceSoftColor(confidence),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 5),
            Text(
              state.text.formatPercent(confidence),
              style: TextStyle(
                color: color,
                fontSize: dense ? 10.5 : 11.5,
                fontWeight: FontWeight.w700,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DocumentTypeIcon extends StatelessWidget {
  const DocumentTypeIcon({super.key, required this.kind, this.size = 44});

  final DocumentKind kind;
  final double size;

  @override
  Widget build(BuildContext context) {
    final icon = switch (kind) {
      DocumentKind.invoice => Icons.receipt_long_outlined,
      DocumentKind.supplierForm => Icons.assignment_ind_outlined,
      DocumentKind.deliveryNote => Icons.local_shipping_outlined,
      DocumentKind.custom => Icons.insert_drive_file_outlined,
    };
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.kindSoftColor(kind),
        borderRadius: BorderRadius.circular(size * 0.3),
      ),
      child: Icon(icon, color: AppColors.kindColor(kind), size: size * 0.48),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.text,
    this.action,
  });

  final IconData icon;
  final String title;
  final String text;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 34),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: const BoxDecoration(
                color: AppColors.paperDeep,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.inkMuted, size: 24),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
              ),
            ),
            const SizedBox(height: 4),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 340),
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12.5,
                  height: 1.5,
                  color: AppColors.inkMuted,
                ),
              ),
            ),
            if (action != null) ...[const SizedBox(height: 16), action!],
          ],
        ),
      ),
    );
  }
}

void showAppSnackBar(
  BuildContext context,
  String message, {
  bool error = false,
}) {
  final messenger = ScaffoldMessenger.of(context);
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              error
                  ? Icons.error_outline_rounded
                  : Icons.check_circle_outline_rounded,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: error ? AppColors.danger : AppColors.ink,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        duration: const Duration(seconds: 3),
      ),
    );
}
