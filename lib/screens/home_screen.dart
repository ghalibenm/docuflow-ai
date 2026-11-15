import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../core/doc_stats.dart';
import '../l10n/app_strings.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import '../widgets/common.dart';
import '../widgets/document_actions.dart';
import '../widgets/document_detail_sheet.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final strings = state.text;
    final documents = state.documents;

    return LayoutBuilder(
      builder: (context, constraints) {
        final pagePadding = constraints.maxWidth < 620 ? 18.0 : 30.0;
        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(pagePadding, 24, pagePadding, 32),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppLayout.maxContentWidth,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PageHeading(
                    eyebrow: strings.homeEyebrow,
                    title: strings.homeTitle,
                    subtitle: strings.homeSubtitle,
                    actions: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        Pill(
                          label: strings.pilotMode,
                          color: AppColors.primary,
                          background: AppColors.mint,
                          icon: Icons.science_outlined,
                        ),
                        Pill(
                          label:
                              '${documents.pendingCount} ${strings.homePendingTitle.toLowerCase()}',
                          color: documents.pendingCount > 0
                              ? AppColors.amberDeep
                              : AppColors.inkSoft,
                          background: documents.pendingCount > 0
                              ? AppColors.amberSoft
                              : AppColors.paperDeep,
                          icon: Icons.fact_check_outlined,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  _HeroPanel(onImport: () => state.selectTab(1)),
                  const SizedBox(height: 18),
                  _StatsGrid(state: state),
                  const SizedBox(height: 18),
                  LayoutBuilder(
                    builder: (context, inner) {
                      if (inner.maxWidth >= 1000) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 7,
                              child: Column(
                                children: [
                                  _PendingCard(state: state),
                                  const SizedBox(height: 18),
                                  _RecentCard(state: state),
                                ],
                              ),
                            ),
                            const SizedBox(width: 18),
                            SizedBox(
                              width: 360,
                              child: Column(
                                children: [
                                  _ImpactCard(state: state),
                                  const SizedBox(height: 18),
                                  _CapabilitiesCard(state: state),
                                ],
                              ),
                            ),
                          ],
                        );
                      }
                      return Column(
                        children: [
                          _PendingCard(state: state),
                          const SizedBox(height: 18),
                          _ImpactCard(state: state),
                          const SizedBox(height: 18),
                          _RecentCard(state: state),
                          const SizedBox(height: 18),
                          _CapabilitiesCard(state: state),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      const Icon(
                        Icons.lock_outline_rounded,
                        size: 14,
                        color: AppColors.inkMuted,
                      ),
                      const SizedBox(width: 7),
                      Expanded(
                        child: Text(
                          strings.homeFooter,
                          style: const TextStyle(
                            color: AppColors.inkMuted,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _HeroPanel extends StatelessWidget {
  const _HeroPanel({required this.onImport});

  final VoidCallback onImport;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final strings = state.text;

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0A3E32), Color(0xFF0C5C49), Color(0xFF13705A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDeep.withValues(alpha: 0.2),
            blurRadius: 36,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned(
            top: -90,
            right: -40,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.07),
                  width: 34,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -120,
            left: 180,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.035),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(26, 26, 26, 26),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final wide = constraints.maxWidth >= 780;
                final content = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.12),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Color(0xFF86E0BC),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 7),
                          Text(
                            strings.homeHeroBadge,
                            style: const TextStyle(
                              color: Color(0xFFD8F3E9),
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 470),
                      child: Text(
                        strings.homeHeroTitle,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.8,
                          height: 1.1,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 470),
                      child: Text(
                        strings.homeHeroText,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 13,
                          height: 1.55,
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        FilledButton.icon(
                          onPressed: onImport,
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.primaryDeep,
                            minimumSize: const Size(0, 46),
                          ),
                          icon: const Icon(
                            Icons.add_photo_alternate_outlined,
                            size: 18,
                          ),
                          label: Text(strings.actionImport),
                        ),
                        OutlinedButton.icon(
                          onPressed: () => state.selectTab(2),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            minimumSize: const Size(0, 46),
                            side: BorderSide(
                              color: Colors.white.withValues(alpha: 0.25),
                            ),
                          ),
                          icon: const Icon(Icons.table_rows_outlined, size: 17),
                          label: Text(strings.actionViewRecords),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Wrap(
                      spacing: 14,
                      runSpacing: 8,
                      children: [
                        _HeroFeature(
                          icon: Icons.translate_rounded,
                          label: 'FR + AR',
                        ),
                        _HeroFeature(
                          icon: Icons.verified_user_outlined,
                          label: strings.humanValidationShort,
                        ),
                        _HeroFeature(
                          icon: Icons.cloud_off_outlined,
                          label: strings.localProcessing,
                        ),
                      ],
                    ),
                  ],
                );

                if (!wide) return content;
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: content),
                    const SizedBox(width: 26),
                    const SizedBox(
                      width: 300,
                      height: 250,
                      child: _HeroDocumentStack(),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroFeature extends StatelessWidget {
  const _HeroFeature({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: const Color(0xFF9FD9C5)),
        const SizedBox(width: 5),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.62),
            fontSize: 10.5,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _HeroDocumentStack extends StatelessWidget {
  const _HeroDocumentStack();

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          top: 10,
          right: 2,
          child: Transform.rotate(
            angle: 0.075,
            child: _MiniDocument(
              width: 190,
              color: const Color(0xFFE9E4D5),
              arabic: true,
            ),
          ),
        ),
        Positioned(
          top: 34,
          left: 4,
          child: Transform.rotate(
            angle: -0.045,
            child: Container(
              width: 226,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.18),
                    blurRadius: 24,
                    offset: const Offset(0, 14),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: AppColors.mint,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(
                          Icons.receipt_long_outlined,
                          color: AppColors.primary,
                          size: 12,
                        ),
                      ),
                      const SizedBox(width: 7),
                      const Expanded(
                        child: Text(
                          'FACTURE FOURNISSEUR',
                          style: TextStyle(
                            color: AppColors.inkMuted,
                            fontSize: 6.5,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.7,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'FR',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 6,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Boulangerie Lefèvre',
                    style: TextStyle(
                      color: AppColors.ink,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'FA-2026-0412 · 18 octobre 2026',
                    style: TextStyle(color: AppColors.inkMuted, fontSize: 7.5),
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 1, color: AppColors.line),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'TOTAL TTC',
                              style: TextStyle(
                                color: AppColors.inkMuted,
                                fontSize: 6.5,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.7,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              '1 498,30 €',
                              style: TextStyle(
                                color: AppColors.ink,
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.mint,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Text(
                          '96 %',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 8,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.verified_rounded,
                        color: AppColors.primary,
                        size: 13,
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        '7 champs · validé',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 7.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      ...List.generate(
                        10,
                        (index) => Container(
                          width: index.isEven ? 1 : 2,
                          height: 9,
                          margin: const EdgeInsets.only(left: 1.5),
                          color: AppColors.ink.withValues(alpha: 0.35),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          right: 6,
          bottom: 6,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF5CB77),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.14),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.shield_outlined,
                  color: AppColors.primaryDeep,
                  size: 12,
                ),
                const SizedBox(width: 5),
                Text(
                  AppScope.of(context).text.humanValidationShort,
                  style: const TextStyle(
                    color: AppColors.primaryDeep,
                    fontSize: 8.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MiniDocument extends StatelessWidget {
  const _MiniDocument({
    required this.width,
    required this.color,
    this.arabic = false,
  });

  final double width;
  final Color color;
  final bool arabic;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: AppColors.ink.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              const Spacer(),
              Text(
                arabic ? 'AR' : 'FR',
                style: TextStyle(
                  color: AppColors.ink.withValues(alpha: 0.45),
                  fontSize: 6.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            arabic ? 'شركة النور للتوريدات' : 'Document',
            textDirection: arabic ? TextDirection.rtl : TextDirection.ltr,
            style: TextStyle(
              color: AppColors.ink.withValues(alpha: 0.68),
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          for (var index = 0; index < 3; index++) ...[
            Container(
              width: index == 1 ? width * 0.45 : width * 0.6,
              height: 3,
              decoration: BoxDecoration(
                color: AppColors.ink.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 5),
          ],
        ],
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.state});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    final strings = state.text;
    final documents = state.documents;

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 980
            ? 4
            : constraints.maxWidth >= 560
            ? 2
            : 1;
        const gap = 14.0;
        final width = (constraints.maxWidth - gap * (columns - 1)) / columns;
        final cards = [
          _StatCard(
            width: width,
            icon: Icons.description_outlined,
            color: AppColors.primary,
            softColor: AppColors.mint,
            label: strings.homeStatDocuments,
            value: '${documents.length}',
            hint: '+${documents.importedThisWeek} ${strings.homeThisWeek}',
          ),
          _StatCard(
            width: width,
            icon: Icons.bolt_outlined,
            color: AppColors.amberDeep,
            softColor: AppColors.amberSoft,
            label: strings.homeStatTime,
            value: strings.formatMinutes(documents.totalMinutesSaved),
            hint: strings.homeOnValidatedDocs,
          ),
          _StatCard(
            width: width,
            icon: Icons.verified_outlined,
            color: AppColors.blue,
            softColor: AppColors.blueSoft,
            label: strings.homeStatAccuracy,
            value: strings.formatPercent(documents.averageConfidence),
            hint:
                '${documents.structuredFieldCount} ${strings.homeExtractedFields}',
          ),
          _StatCard(
            width: width,
            icon: Icons.business_outlined,
            color: AppColors.violet,
            softColor: AppColors.violetSoft,
            label: strings.homeStatPilots,
            value: '${state.pilots.length}',
            hint: strings.homeOneProcess,
          ),
        ];

        return Wrap(spacing: gap, runSpacing: gap, children: cards);
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.width,
    required this.icon,
    required this.color,
    required this.softColor,
    required this.label,
    required this.value,
    required this.hint,
  });

  final double width;
  final IconData icon;
  final Color color;
  final Color softColor;
  final String label;
  final String value;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: AppCard(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: softColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, size: 17, color: color),
                ),
                const Spacer(),
                Text(
                  label.toUpperCase(),
                  style: const TextStyle(
                    color: AppColors.inkMuted,
                    fontSize: 8.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                value,
                style: const TextStyle(
                  color: AppColors.ink,
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.7,
                  height: 1.1,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              hint,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: AppColors.inkMuted, fontSize: 10.5),
            ),
          ],
        ),
      ),
    );
  }
}

class _PendingCard extends StatelessWidget {
  const _PendingCard({required this.state});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    final strings = state.text;
    final pending = state.documents.pendingDocuments.sortedByRecentFirst;
    final visible = pending.take(3).toList();

    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 16, 12),
            child: SectionTitle(
              title: strings.homePendingTitle,
              count: pending.length,
              action: pending.isEmpty
                  ? null
                  : TextButton(
                      onPressed: () => state.selectTab(2),
                      style: TextButton.styleFrom(
                        minimumSize: Size.zero,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(strings.actionViewAll),
                    ),
            ),
          ),
          if (pending.isEmpty)
            SizedBox(
              height: 150,
              child: EmptyState(
                icon: Icons.task_alt_rounded,
                title: strings.homePendingEmptyTitle,
                text: strings.homePendingEmptyText,
              ),
            )
          else
            for (var index = 0; index < visible.length; index++) ...[
              if (index > 0) const Divider(height: 1, color: AppColors.line),
              _PendingRow(document: visible[index], state: state),
            ],
          if (pending.length > visible.length)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(bottom: 8),
              child: TextButton(
                onPressed: () => state.selectTab(2),
                child: Text(
                  '+${pending.length - visible.length} ${strings.recordsStatDocuments}',
                ),
              ),
            ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _PendingRow extends StatelessWidget {
  const _PendingRow({required this.document, required this.state});

  final DocRecord document;
  final AppState state;

  @override
  Widget build(BuildContext context) {
    final strings = state.text;
    final pilot = state.pilotById(document.pilotId);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => pushValidation(context, document.id),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 13, 16, 13),
          child: Row(
            children: [
              DocumentTypeIcon(kind: document.kind, size: 42),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      strings.documentTitle(document),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.ink,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      [
                        strings.relativeTime(document.importedAt),
                        if (pilot != null) pilot.name,
                      ].join(' · '),
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
              const SizedBox(width: 10),
              ConfidencePill(confidence: document.confidence, dense: true),
              const SizedBox(width: 4),
              const Icon(
                Icons.chevron_right_rounded,
                size: 18,
                color: AppColors.inkMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecentCard extends StatelessWidget {
  const _RecentCard({required this.state});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    final strings = state.text;
    final recent = state.documents.sortedByRecentFirst.take(5).toList();

    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 16, 12),
            child: SectionTitle(
              title: strings.homeRecentTitle,
              action: TextButton(
                onPressed: () => state.selectTab(2),
                style: TextButton.styleFrom(
                  minimumSize: Size.zero,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(strings.actionViewAll),
              ),
            ),
          ),
          for (var index = 0; index < recent.length; index++) ...[
            if (index > 0) const Divider(height: 1, color: AppColors.line),
            _RecentRow(document: recent[index], state: state),
          ],
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _RecentRow extends StatelessWidget {
  const _RecentRow({required this.document, required this.state});

  final DocRecord document;
  final AppState state;

  @override
  Widget build(BuildContext context) {
    final strings = state.text;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (document.status == DocumentStatus.pending) {
            pushValidation(context, document.id);
          } else {
            showDocumentDetailSheet(context, document);
          }
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 16, 12),
          child: Row(
            children: [
              DocumentTypeIcon(kind: document.kind, size: 38),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      strings.documentTitle(document),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.ink,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${strings.relativeTime(document.importedAt)} · ${strings.fieldsDetected(document.fields.length)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.inkMuted,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              StatusPill(status: document.status, dense: true),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImpactCard extends StatelessWidget {
  const _ImpactCard({required this.state});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    final strings = state.text;
    final documents = state.documents;
    const colors = [AppColors.primary, AppColors.blue, AppColors.amber];

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(
            title: strings.homeImpactTitle,
            action: TextButton(
              onPressed: () => state.selectTab(3),
              style: TextButton.styleFrom(
                minimumSize: Size.zero,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(strings.homeDetails),
            ),
          ),
          const SizedBox(height: 18),
          for (var index = 0; index < state.pilots.length; index++) ...[
            _PilotImpactRow(
              pilot: state.pilots[index],
              validated: documents.validatedCountForPilot(
                state.pilots[index].id,
              ),
              savedMinutes: documents.minutesSavedForPilot(
                state.pilots[index].id,
              ),
              color: colors[index % colors.length],
              strings: strings,
            ),
            if (index < state.pilots.length - 1) const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }
}

class _PilotImpactRow extends StatelessWidget {
  const _PilotImpactRow({
    required this.pilot,
    required this.validated,
    required this.savedMinutes,
    required this.color,
    required this.strings,
  });

  final PilotCompany pilot;
  final int validated;
  final double savedMinutes;
  final Color color;
  final AppStrings strings;

  @override
  Widget build(BuildContext context) {
    final progress = pilot.targetDocuments == 0
        ? 0.0
        : (validated / pilot.targetDocuments).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                pilot.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.ink,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              strings.formatMinutes(savedMinutes),
              style: TextStyle(
                color: color,
                fontSize: 11,
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
            minHeight: 5,
            backgroundColor: AppColors.paperDeep,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$validated / ${pilot.targetDocuments} ${strings.pilotDocuments}',
          style: const TextStyle(color: AppColors.inkMuted, fontSize: 9.5),
        ),
      ],
    );
  }
}

class _CapabilitiesCard extends StatelessWidget {
  const _CapabilitiesCard({required this.state});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    final strings = state.text;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            strings.homeCapabilitiesTitle,
            style: const TextStyle(
              color: AppColors.ink,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          _CapabilityBlock(
            icon: Icons.translate_rounded,
            color: AppColors.blue,
            background: AppColors.blueSoft,
            title: strings.homeLanguagesTitle,
            text: strings.homeLanguagesText,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Divider(height: 1, color: AppColors.line),
          ),
          _CapabilityBlock(
            icon: Icons.verified_user_outlined,
            color: AppColors.primary,
            background: AppColors.mint,
            title: strings.homeValidationTitle,
            text: strings.homeValidationText,
          ),
        ],
      ),
    );
  }
}

class _CapabilityBlock extends StatelessWidget {
  const _CapabilityBlock({
    required this.icon,
    required this.color,
    required this.background,
    required this.title,
    required this.text,
  });

  final IconData icon;
  final Color color;
  final Color background;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 17),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.ink,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                text,
                style: const TextStyle(
                  color: AppColors.inkMuted,
                  fontSize: 10.5,
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
