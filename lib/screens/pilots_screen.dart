import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../core/doc_stats.dart';
import '../l10n/app_strings.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import '../widgets/common.dart';

class PilotsScreen extends StatelessWidget {
  const PilotsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final strings = state.text;
    final documents = state.documents;

    return LayoutBuilder(
      builder: (context, constraints) {
        final pagePadding = constraints.maxWidth < 620 ? 18.0 : 30.0;
        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(pagePadding, 24, pagePadding, 36),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppLayout.maxContentWidth,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PageHeading(
                    eyebrow: strings.navPilots,
                    title: strings.pilotsTitle,
                    subtitle: strings.pilotsSubtitle,
                    actions: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        Pill(
                          label: strings.pilotMeasuring,
                          color: AppColors.primary,
                          background: AppColors.mint,
                          icon: Icons.timelapse_rounded,
                        ),
                        Pill(
                          label:
                              '${state.pilots.length} ${strings.pilotUnitsCompanies}',
                          color: AppColors.inkSoft,
                          background: AppColors.paperDeep,
                          icon: Icons.business_outlined,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _SummaryStrip(state: state),
                  const SizedBox(height: 16),
                  const _ProtocolCard(),
                  const SizedBox(height: 20),
                  LayoutBuilder(
                    builder: (context, grid) {
                      final columns = grid.maxWidth >= 1080
                          ? 3
                          : grid.maxWidth >= 700
                          ? 2
                          : 1;
                      const gap = 16.0;
                      final width =
                          (grid.maxWidth - gap * (columns - 1)) / columns;
                      return Wrap(
                        spacing: gap,
                        runSpacing: gap,
                        children: [
                          for (
                            var index = 0;
                            index < state.pilots.length;
                            index++
                          )
                            SizedBox(
                              width: width,
                              child: _PilotCard(
                                pilot: state.pilots[index],
                                validated: documents.validatedCountForPilot(
                                  state.pilots[index].id,
                                ),
                                savedMinutes: documents.minutesSavedForPilot(
                                  state.pilots[index].id,
                                ),
                                color: _pilotColor(index),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 18),
                  _TestNote(strings: strings),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Color _pilotColor(int index) {
    return switch (index % 3) {
      0 => AppColors.primary,
      1 => AppColors.blue,
      _ => AppColors.amberDeep,
    };
  }
}

class _SummaryStrip extends StatelessWidget {
  const _SummaryStrip({required this.state});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    final strings = state.text;
    final documents = state.documents;
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
      child: Wrap(
        spacing: 26,
        runSpacing: 12,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          _Metric(
            icon: Icons.business_outlined,
            value: '${state.pilots.length}',
            label: strings.pilotUnitsCompanies,
            color: AppColors.primary,
          ),
          _Metric(
            icon: Icons.account_tree_outlined,
            value: '${state.pilots.length}',
            label: strings.pilotUnitsProcess,
            color: AppColors.blue,
          ),
          _Metric(
            icon: Icons.verified_outlined,
            value: '${documents.validatedCount}',
            label: strings.pilotDocumentsShort,
            color: AppColors.violet,
          ),
          _Metric(
            icon: Icons.bolt_outlined,
            value: strings.formatMinutes(documents.totalMinutesSaved),
            label: strings.pilotTimeSavedShort,
            color: AppColors.amberDeep,
          ),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(icon, size: 16, color: color),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                color: AppColors.ink,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                height: 1.15,
              ),
            ),
            Text(
              label,
              style: const TextStyle(color: AppColors.inkMuted, fontSize: 9.5),
            ),
          ],
        ),
      ],
    );
  }
}

class _ProtocolCard extends StatelessWidget {
  const _ProtocolCard();

  @override
  Widget build(BuildContext context) {
    final strings = AppScope.of(context).text;
    final steps = [
      (strings.pilotStep1Title, strings.pilotStep1Text),
      (strings.pilotStep2Title, strings.pilotStep2Text),
      (strings.pilotStep3Title, strings.pilotStep3Text),
    ];

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  strings.pilotProtocolTitle,
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Pill(
                label: strings.pilotMode,
                color: AppColors.amberDeep,
                background: AppColors.amberSoft,
                icon: Icons.straighten_rounded,
                dense: true,
              ),
            ],
          ),
          const SizedBox(height: 14),
          LayoutBuilder(
            builder: (context, constraints) {
              final stepWidgets = [
                for (var index = 0; index < steps.length; index++)
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.paper,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.line),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            color: AppColors.mint,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                steps[index].$1,
                                style: const TextStyle(
                                  color: AppColors.ink,
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                steps[index].$2,
                                style: const TextStyle(
                                  color: AppColors.inkMuted,
                                  fontSize: 10,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
              ];

              if (constraints.maxWidth >= 800) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (
                      var index = 0;
                      index < stepWidgets.length;
                      index++
                    ) ...[
                      Expanded(child: stepWidgets[index]),
                      if (index < stepWidgets.length - 1)
                        const SizedBox(width: 10),
                    ],
                  ],
                );
              }
              return Column(
                children: [
                  for (var index = 0; index < stepWidgets.length; index++) ...[
                    stepWidgets[index],
                    if (index < stepWidgets.length - 1)
                      const SizedBox(height: 10),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _PilotCard extends StatelessWidget {
  const _PilotCard({
    required this.pilot,
    required this.validated,
    required this.savedMinutes,
    required this.color,
  });

  final PilotCompany pilot;
  final int validated;
  final double savedMinutes;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final strings = AppScope.of(context).text;
    final progress = pilot.targetDocuments == 0
        ? 0.0
        : (validated / pilot.targetDocuments).clamp(0.0, 1.0);
    final completed = validated >= pilot.targetDocuments;

    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.11),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  pilot.initials,
                  style: TextStyle(
                    color: color,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pilot.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.ink,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${pilot.sector(strings.language)} · ${pilot.city}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.inkMuted,
                        fontSize: 10.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Pill(
                label: completed
                    ? strings.pilotTargetReached
                    : strings.pilotActive,
                color: completed ? AppColors.primary : AppColors.inkSoft,
                background: completed ? AppColors.mint : AppColors.paperDeep,
                icon: completed
                    ? Icons.check_circle_outline_rounded
                    : Icons.radio_button_checked_rounded,
                dense: true,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            strings.pilotProcess.toUpperCase(),
            style: const TextStyle(
              color: AppColors.inkMuted,
              fontSize: 8.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.7,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            pilot.process(strings.language),
            style: const TextStyle(
              color: AppColors.ink,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Text(
                  strings.pilotTarget,
                  style: const TextStyle(
                    color: AppColors.inkSoft,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Text(
                '$validated / ${pilot.targetDocuments}',
                style: TextStyle(
                  color: color,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: AppColors.paperDeep,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            '${strings.pilotStarted} ${strings.pilotSince(pilot.startedDaysAgo)}',
            style: const TextStyle(color: AppColors.inkMuted, fontSize: 9),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _TimeBox(
                  label: strings.pilotBefore,
                  value: strings.formatPreciseMinutes(pilot.minutesBefore),
                  muted: true,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _TimeBox(
                  label: strings.pilotAfter,
                  value: strings.formatPreciseMinutes(pilot.minutesAfter),
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.bolt_rounded, size: 16, color: color),
                const SizedBox(width: 6),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        strings.pilotSaved,
                        style: const TextStyle(
                          color: AppColors.inkMuted,
                          fontSize: 9,
                        ),
                      ),
                      Text(
                        strings.formatMinutes(savedMinutes),
                        style: TextStyle(
                          color: color,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          height: 1.15,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      strings.pilotRoi,
                      style: const TextStyle(
                        color: AppColors.inkMuted,
                        fontSize: 8.5,
                      ),
                    ),
                    Text(
                      strings.formatPercent(pilot.timeReduction),
                      style: TextStyle(
                        color: color,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TimeBox extends StatelessWidget {
  const _TimeBox({
    required this.label,
    required this.value,
    this.color = AppColors.ink,
    this.muted = false,
  });

  final String label;
  final String value;
  final Color color;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    final strings = AppScope.of(context).text;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
      decoration: BoxDecoration(
        color: AppColors.paper,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              color: AppColors.inkMuted,
              fontSize: 7.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              color: muted ? AppColors.inkSoft : color,
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            strings.pilotPerDocument,
            style: const TextStyle(color: AppColors.inkMuted, fontSize: 8),
          ),
        ],
      ),
    );
  }
}

class _TestNote extends StatelessWidget {
  const _TestNote({required this.strings});

  final AppStrings strings;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.primaryDeep,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.09),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.science_outlined,
              color: Color(0xFF9FD9C5),
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  strings.pilotSummaryTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  strings.pilotTestNote,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.62),
                    fontSize: 11,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
