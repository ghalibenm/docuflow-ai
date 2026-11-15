import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/app_theme.dart';
import '../core/doc_stats.dart';
import '../core/exporters.dart';
import '../l10n/app_strings.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import '../widgets/common.dart';
import '../widgets/document_actions.dart';

enum _RecordFilter { all, pending, validated, rejected }

class RecordsScreen extends StatefulWidget {
  const RecordsScreen({super.key});

  @override
  State<RecordsScreen> createState() => _RecordsScreenState();
}

class _RecordsScreenState extends State<RecordsScreen> {
  final TextEditingController _searchController = TextEditingController();
  _RecordFilter _filter = _RecordFilter.all;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<DocRecord> _applyFilter(
    List<DocRecord> source,
    AppStrings strings, {
    bool includeStatus = true,
  }) {
    final query = _searchController.text.trim().toLowerCase();
    return source.where((document) {
      if (includeStatus) {
        final matchesStatus = switch (_filter) {
          _RecordFilter.all => true,
          _RecordFilter.pending => document.status == DocumentStatus.pending,
          _RecordFilter.validated =>
            document.status == DocumentStatus.validated,
          _RecordFilter.rejected => document.status == DocumentStatus.rejected,
        };
        if (!matchesStatus) return false;
      }
      if (query.isEmpty) return true;
      final haystack = <String?>[
        document.id,
        document.fileName,
        document.party,
        document.reference,
        document.amount,
        document.documentDate,
        strings.kindLabel(document.kind),
        strings.statusLabel(document.status),
        for (final field in document.fields)
          if (!field.isPlaceholder) field.value,
      ].whereType<String>().join(' ').toLowerCase();
      return haystack.contains(query);
    }).toList();
  }

  Future<void> _exportCsv(AppState state) async {
    final strings = state.text;
    final documents = _applyFilter(
      state.documents.sortedByRecentFirst,
      strings,
    );
    if (documents.isEmpty) {
      showAppSnackBar(context, strings.exportEmpty, error: true);
      return;
    }
    final csv = buildCsv(documents: documents, strings: strings);
    try {
      await Clipboard.setData(ClipboardData(text: csv));
    } catch (_) {
      if (!mounted) return;
      showAppSnackBar(context, strings.clipboardCopyError, error: true);
      return;
    }
    if (!mounted) return;
    showAppSnackBar(context, strings.exportSuccess(documents.length));
  }

  void _openReport(AppState state) {
    final strings = state.text;
    if (state.documents.validatedCount == 0) {
      showAppSnackBar(context, strings.reportNoData, error: true);
      return;
    }
    showDialog<void>(
      context: context,
      builder: (_) => _ReportDialog(state: state),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final strings = state.text;
    final allDocuments = state.documents.sortedByRecentFirst;
    final visible = _applyFilter(allDocuments, strings);
    final searchOnly = _applyFilter(
      allDocuments,
      strings,
      includeStatus: false,
    );

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
                    eyebrow: strings.navRecords,
                    title: strings.recordsTitle,
                    subtitle: strings.recordsSubtitle,
                    actions: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        OutlinedButton.icon(
                          onPressed: () => _openReport(state),
                          icon: const Icon(Icons.summarize_outlined, size: 18),
                          label: Text(strings.actionReport),
                        ),
                        FilledButton.icon(
                          onPressed: () => _exportCsv(state),
                          icon: const Icon(
                            Icons.file_download_outlined,
                            size: 18,
                          ),
                          label: Text(strings.actionExportCsv),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _SummaryBar(state: state),
                  const SizedBox(height: 16),
                  _Toolbar(
                    controller: _searchController,
                    onSearchChanged: (_) => setState(() {}),
                    filter: _filter,
                    onFilterChanged: (filter) =>
                        setState(() => _filter = filter),
                    counts: {
                      _RecordFilter.all: searchOnly.length,
                      _RecordFilter.pending: searchOnly
                          .where(
                            (document) =>
                                document.status == DocumentStatus.pending,
                          )
                          .length,
                      _RecordFilter.validated: searchOnly
                          .where(
                            (document) =>
                                document.status == DocumentStatus.validated,
                          )
                          .length,
                      _RecordFilter.rejected: searchOnly
                          .where(
                            (document) =>
                                document.status == DocumentStatus.rejected,
                          )
                          .length,
                    },
                  ),
                  const SizedBox(height: 16),
                  if (visible.isEmpty)
                    AppCard(
                      child: EmptyState(
                        icon: Icons.manage_search_rounded,
                        title: strings.recordsEmptyTitle,
                        text: strings.recordsEmptyText,
                        action: OutlinedButton.icon(
                          onPressed: () => state.selectTab(1),
                          icon: const Icon(Icons.add_rounded, size: 18),
                          label: Text(strings.actionImport),
                        ),
                      ),
                    )
                  else
                    LayoutBuilder(
                      builder: (context, tableConstraints) {
                        if (tableConstraints.maxWidth >= 980) {
                          return _RecordsTable(
                            documents: visible,
                            onTap: (document) =>
                                openDocumentDetailOrVerify(context, document),
                          );
                        }
                        return _RecordsList(
                          documents: visible,
                          onTap: (document) =>
                              openDocumentDetailOrVerify(context, document),
                        );
                      },
                    ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 6,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    alignment: WrapAlignment.spaceBetween,
                    children: [
                      Text(
                        '${visible.length} ${strings.recordsShowing} · ${strings.recordsSortRecent}',
                        style: const TextStyle(
                          color: AppColors.inkMuted,
                          fontSize: 10.5,
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.lock_outline_rounded,
                            size: 12,
                            color: AppColors.inkMuted,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            strings.humanValidation,
                            style: const TextStyle(
                              color: AppColors.inkMuted,
                              fontSize: 10,
                            ),
                          ),
                        ],
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

class _SummaryBar extends StatelessWidget {
  const _SummaryBar({required this.state});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    final strings = state.text;
    final documents = state.documents;

    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      child: Wrap(
        spacing: 24,
        runSpacing: 12,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          _SummaryMetric(
            icon: Icons.description_outlined,
            color: AppColors.primary,
            value: '${documents.length}',
            label: strings.recordsStatDocuments,
          ),
          _SummaryMetric(
            icon: Icons.verified_outlined,
            color: AppColors.blue,
            value: '${documents.validatedCount}',
            label: strings.recordsStatValidated,
          ),
          _SummaryMetric(
            icon: Icons.schema_outlined,
            color: AppColors.violet,
            value: '${documents.structuredFieldCount}',
            label: strings.recordsStatFields,
          ),
          _SummaryMetric(
            icon: Icons.bolt_outlined,
            color: AppColors.amberDeep,
            value: strings.formatMinutes(documents.totalMinutesSaved),
            label: strings.recordsStatSaved,
          ),
        ],
      ),
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({
    required this.icon,
    required this.color,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final Color color;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(icon, size: 15, color: color),
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

class _Toolbar extends StatelessWidget {
  const _Toolbar({
    required this.controller,
    required this.onSearchChanged,
    required this.filter,
    required this.onFilterChanged,
    required this.counts,
  });

  final TextEditingController controller;
  final ValueChanged<String> onSearchChanged;
  final _RecordFilter filter;
  final ValueChanged<_RecordFilter> onFilterChanged;
  final Map<_RecordFilter, int> counts;

  @override
  Widget build(BuildContext context) {
    final strings = AppScope.of(context).text;

    final search = TextField(
      controller: controller,
      onChanged: onSearchChanged,
      textInputAction: TextInputAction.search,
      style: const TextStyle(color: AppColors.ink, fontSize: 13),
      decoration: InputDecoration(
        hintText: strings.recordsSearchHint,
        prefixIcon: const Icon(Icons.search_rounded, size: 19),
        suffixIcon: controller.text.isEmpty
            ? null
            : IconButton(
                tooltip: strings.actionCancel,
                onPressed: () {
                  controller.clear();
                  onSearchChanged('');
                },
                icon: const Icon(Icons.close_rounded, size: 17),
              ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
      ),
    );

    final filters = Wrap(
      spacing: 7,
      runSpacing: 7,
      children: [
        _FilterChip(
          label: strings.filterAll,
          count: counts[_RecordFilter.all] ?? 0,
          selected: filter == _RecordFilter.all,
          onTap: () => onFilterChanged(_RecordFilter.all),
        ),
        _FilterChip(
          label: strings.filterPending,
          count: counts[_RecordFilter.pending] ?? 0,
          selected: filter == _RecordFilter.pending,
          onTap: () => onFilterChanged(_RecordFilter.pending),
          selectedColor: AppColors.amberDeep,
          selectedBackground: AppColors.amberSoft,
        ),
        _FilterChip(
          label: strings.filterValidated,
          count: counts[_RecordFilter.validated] ?? 0,
          selected: filter == _RecordFilter.validated,
          onTap: () => onFilterChanged(_RecordFilter.validated),
        ),
        _FilterChip(
          label: strings.filterRejected,
          count: counts[_RecordFilter.rejected] ?? 0,
          selected: filter == _RecordFilter.rejected,
          onTap: () => onFilterChanged(_RecordFilter.rejected),
          selectedColor: AppColors.danger,
          selectedBackground: AppColors.dangerSoft,
        ),
      ],
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 860) {
          return Row(
            children: [
              SizedBox(width: 340, child: search),
              const SizedBox(width: 14),
              Expanded(
                child: Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: filters,
                ),
              ),
            ],
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [search, const SizedBox(height: 10), filters],
        );
      },
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.count,
    required this.selected,
    required this.onTap,
    this.selectedColor = AppColors.primary,
    this.selectedBackground = AppColors.mint,
  });

  final String label;
  final int count;
  final bool selected;
  final VoidCallback onTap;
  final Color selectedColor;
  final Color selectedBackground;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
          decoration: BoxDecoration(
            color: selected ? selectedBackground : AppColors.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected
                  ? selectedColor.withValues(alpha: 0.24)
                  : AppColors.line,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: selected ? selectedColor : AppColors.inkSoft,
                  fontSize: 11.5,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                  color: selected
                      ? selectedColor.withValues(alpha: 0.13)
                      : AppColors.paperDeep,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$count',
                  style: TextStyle(
                    color: selected ? selectedColor : AppColors.inkMuted,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecordsTable extends StatelessWidget {
  const _RecordsTable({required this.documents, required this.onTap});

  final List<DocRecord> documents;
  final ValueChanged<DocRecord> onTap;

  @override
  Widget build(BuildContext context) {
    final strings = AppScope.of(context).text;
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 10),
            child: Row(
              children: [
                _headerCell(strings.colDocument, 34),
                _headerCell(strings.colType, 17),
                _headerCell(strings.colParty, 18),
                _headerCell(strings.colDate, 14),
                _headerCell(strings.colReference, 17),
                _headerCell(strings.colConfidence, 12),
                _headerCell(strings.colStatus, 13),
                const SizedBox(width: 24),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.line),
          for (var index = 0; index < documents.length; index++) ...[
            if (index > 0) const Divider(height: 1, color: AppColors.line),
            _RecordTableRow(
              document: documents[index],
              onTap: () => onTap(documents[index]),
            ),
          ],
        ],
      ),
    );
  }

  Widget _headerCell(String text, int flex) {
    return Expanded(
      flex: flex,
      child: Text(
        text.toUpperCase(),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: AppColors.inkMuted,
          fontSize: 8.5,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}

class _RecordTableRow extends StatelessWidget {
  const _RecordTableRow({required this.document, required this.onTap});

  final DocRecord document;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final strings = AppScope.of(context).text;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
          child: Row(
            children: [
              Expanded(
                flex: 34,
                child: Row(
                  children: [
                    DocumentTypeIcon(kind: document.kind, size: 34),
                    const SizedBox(width: 9),
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
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            document.id,
                            style: const TextStyle(
                              color: AppColors.inkMuted,
                              fontSize: 9,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 17,
                child: Text(
                  strings.kindLabel(document.kind),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.inkSoft,
                    fontSize: 10.5,
                  ),
                ),
              ),
              Expanded(
                flex: 18,
                child: Text(
                  document.party ?? strings.recordsEmptyValue,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textDirection: document.sourceLanguage.isArabic
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                  style: const TextStyle(
                    color: AppColors.inkSoft,
                    fontSize: 10.5,
                  ),
                ),
              ),
              Expanded(
                flex: 14,
                child: Text(
                  document.documentDate ??
                      strings.formatDate(document.importedAt, short: true),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.inkSoft,
                    fontSize: 10,
                  ),
                ),
              ),
              Expanded(
                flex: 17,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      document.amount ?? strings.recordsEmptyValue,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.ink,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (document.reference != null)
                      Text(
                        document.reference!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.inkMuted,
                          fontSize: 8.5,
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                flex: 12,
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: ConfidencePill(
                    confidence: document.confidence,
                    dense: true,
                  ),
                ),
              ),
              Expanded(
                flex: 13,
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: StatusPill(status: document.status, dense: true),
                ),
              ),
              const SizedBox(
                width: 24,
                child: Icon(
                  Icons.chevron_right_rounded,
                  size: 17,
                  color: AppColors.inkMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecordsList extends StatelessWidget {
  const _RecordsList({required this.documents, required this.onTap});

  final List<DocRecord> documents;
  final ValueChanged<DocRecord> onTap;

  @override
  Widget build(BuildContext context) {
    final strings = AppScope.of(context).text;
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          for (var index = 0; index < documents.length; index++) ...[
            if (index > 0) const Divider(height: 1, color: AppColors.line),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => onTap(documents[index]),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DocumentTypeIcon(kind: documents[index].kind, size: 40),
                      const SizedBox(width: 11),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              strings.documentTitle(documents[index]),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: AppColors.ink,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              [
                                strings.kindLabel(documents[index].kind),
                                documents[index].party,
                              ].whereType<String>().join(' · '),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: AppColors.inkMuted,
                                fontSize: 10.5,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                StatusPill(
                                  status: documents[index].status,
                                  dense: true,
                                ),
                                ConfidencePill(
                                  confidence: documents[index].confidence,
                                  dense: true,
                                ),
                                Text(
                                  documents[index].amount ??
                                      documents[index].documentDate ??
                                      documents[index].id,
                                  style: const TextStyle(
                                    color: AppColors.inkSoft,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(
                        Icons.chevron_right_rounded,
                        size: 18,
                        color: AppColors.inkMuted,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ReportDialog extends StatefulWidget {
  const _ReportDialog({required this.state});

  final AppState state;

  @override
  State<_ReportDialog> createState() => _ReportDialogState();
}

class _ReportDialogState extends State<_ReportDialog> {
  bool _copied = false;

  Future<void> _copy() async {
    final strings = widget.state.text;
    final report = buildReportText(
      documents: widget.state.documents,
      pilots: widget.state.pilots,
      strings: strings,
    );
    try {
      await Clipboard.setData(ClipboardData(text: report));
    } catch (_) {
      if (!mounted) return;
      showAppSnackBar(context, strings.clipboardCopyError, error: true);
      return;
    }
    if (!mounted) return;
    setState(() => _copied = true);
  }

  @override
  Widget build(BuildContext context) {
    final strings = widget.state.text;
    final documents = widget.state.documents;
    final counts = documents.validatedCountByKind;
    final screenHeight = MediaQuery.sizeOf(context).height;

    return Dialog(
      backgroundColor: AppColors.surface,
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 620,
          maxHeight: screenHeight * 0.88,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 16, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: AppColors.mint,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.summarize_outlined,
                      color: AppColors.primary,
                      size: 21,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          strings.reportTitle,
                          style: const TextStyle(
                            color: AppColors.ink,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${strings.reportGenerated} ${strings.formatDate(DateTime.now())}',
                          style: const TextStyle(
                            color: AppColors.inkMuted,
                            fontSize: 10.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.line),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 18, 24, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      strings.reportSubtitle,
                      style: const TextStyle(
                        color: AppColors.inkMuted,
                        fontSize: 11.5,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        _ReportStat(
                          label: strings.docsLabel,
                          value: '${documents.length}',
                        ),
                        _ReportStat(
                          label: strings.validatedLabel,
                          value: '${documents.validatedCount}',
                        ),
                        _ReportStat(
                          label: strings.reportHoursSaved,
                          value: strings.formatMinutes(
                            documents.totalMinutesSaved,
                          ),
                        ),
                        _ReportStat(
                          label: strings.accuracyLabel,
                          value: strings.formatPercent(
                            documents.averageConfidence,
                          ),
                        ),
                        _ReportStat(
                          label: strings.fieldsStructured,
                          value: '${documents.structuredFieldCount}',
                        ),
                        _ReportStat(
                          label: strings.reportAverageTime,
                          value: strings.formatMinutes(
                            averageMinutesPerValidatedDocument(documents),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    Text(
                      strings.reportByPilot,
                      style: const TextStyle(
                        color: AppColors.ink,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    for (
                      var index = 0;
                      index < widget.state.pilots.length;
                      index++
                    ) ...[
                      _ReportPilotRow(
                        pilot: widget.state.pilots[index],
                        validated: documents.validatedCountForPilot(
                          widget.state.pilots[index].id,
                        ),
                        savedMinutes: documents.minutesSavedForPilot(
                          widget.state.pilots[index].id,
                        ),
                        strings: strings,
                      ),
                      if (index < widget.state.pilots.length - 1)
                        const SizedBox(height: 10),
                    ],
                    const SizedBox(height: 22),
                    Text(
                      strings.reportByType,
                      style: const TextStyle(
                        color: AppColors.ink,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (counts.isEmpty)
                      Text(
                        strings.reportNoData,
                        style: const TextStyle(
                          color: AppColors.inkMuted,
                          fontSize: 11,
                        ),
                      )
                    else
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final entry in counts.entries)
                            Pill(
                              label:
                                  '${strings.kindLabel(entry.key)} · ${entry.value}',
                              color: AppColors.kindColor(entry.key),
                              background: AppColors.kindSoftColor(entry.key),
                              icon: Icons.folder_outlined,
                            ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: AppColors.line)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _copy,
                        icon: Icon(
                          _copied
                              ? Icons.check_rounded
                              : Icons.copy_all_outlined,
                          size: 17,
                        ),
                        label: Text(
                          _copied ? strings.copiedShort : strings.actionCopy,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(strings.actionClose),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReportStat extends StatelessWidget {
  const _ReportStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 174,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.paper,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.inkMuted,
              fontSize: 9,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.ink,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReportPilotRow extends StatelessWidget {
  const _ReportPilotRow({
    required this.pilot,
    required this.validated,
    required this.savedMinutes,
    required this.strings,
  });

  final PilotCompany pilot;
  final int validated;
  final double savedMinutes;
  final AppStrings strings;

  @override
  Widget build(BuildContext context) {
    final progress = pilot.targetDocuments == 0
        ? 0.0
        : (validated / pilot.targetDocuments).clamp(0.0, 1.0);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.paper,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.mint,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  pilot.initials,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  pilot.name,
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                '$validated ${strings.recordsStatValidated} · ${strings.formatMinutes(savedMinutes)}',
                style: const TextStyle(
                  color: AppColors.inkMuted,
                  fontSize: 9.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 4,
              backgroundColor: AppColors.paperDeep,
            ),
          ),
        ],
      ),
    );
  }
}
