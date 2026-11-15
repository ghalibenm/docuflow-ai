import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import 'common.dart';
import 'document_preview.dart';

Future<bool?> showDocumentDetailSheet(
  BuildContext context,
  DocRecord document,
) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    barrierColor: AppColors.ink.withValues(alpha: 0.38),
    builder: (sheetContext) => _DocumentDetailSheet(documentId: document.id),
  );
}

class _DocumentDetailSheet extends StatelessWidget {
  const _DocumentDetailSheet({required this.documentId});

  final String documentId;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final strings = state.text;
    final document = state.documentById(documentId);

    if (document == null) {
      return const SizedBox.shrink();
    }

    final pilot = state.pilotById(document.pilotId);
    final screenHeight = MediaQuery.sizeOf(context).height;

    return Padding(
      padding: const EdgeInsets.all(14),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 760,
            maxHeight: screenHeight * 0.9,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(26),
              border: Border.all(color: AppColors.line),
              boxShadow: [
                BoxShadow(
                  color: AppColors.ink.withValues(alpha: 0.16),
                  blurRadius: 40,
                  offset: const Offset(0, 20),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.lineStrong,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 14, 16, 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DocumentTypeIcon(kind: document.kind, size: 46),
                      const SizedBox(width: 13),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              strings.kindLabel(document.kind).toUpperCase(),
                              style: const TextStyle(
                                color: AppColors.inkMuted,
                                fontSize: 9.5,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              strings.documentTitle(document),
                              style: const TextStyle(
                                color: AppColors.ink,
                                fontSize: 19,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.3,
                                height: 1.2,
                              ),
                            ),
                            if (document.fileName != null) ...[
                              const SizedBox(height: 3),
                              Text(
                                document.fileName!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: AppColors.inkMuted,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: strings.actionClose,
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      StatusPill(status: document.status),
                      const SizedBox(width: 8),
                      ConfidencePill(confidence: document.confidence),
                      if (document.status == DocumentStatus.validated) ...[
                        const SizedBox(width: 8),
                        Pill(
                          label:
                              '+${strings.formatPreciseMinutes(document.minutesSaved)}',
                          color: AppColors.primary,
                          background: AppColors.mint,
                          icon: Icons.bolt_rounded,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
                    children: [
                      if (document.status == DocumentStatus.pending)
                        _NoticeBanner(
                          icon: Icons.fact_check_outlined,
                          text: strings.detailPendingHint,
                          color: AppColors.amberDeep,
                          background: AppColors.amberSoft,
                        ),
                      if (document.status == DocumentStatus.rejected)
                        _NoticeBanner(
                          icon: Icons.info_outline_rounded,
                          text: strings.detailRejectedHint,
                          color: AppColors.danger,
                          background: AppColors.dangerSoft,
                        ),
                      if (document.status != DocumentStatus.validated) ...[
                        const SizedBox(height: 14),
                      ],
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          _MetaTile(
                            label: strings.detailPilot,
                            value: pilot?.name ?? strings.detailNoPilot,
                          ),
                          _MetaTile(
                            label: strings.detailLanguage,
                            value: strings.languageLabel(
                              document.sourceLanguage,
                            ),
                          ),
                          _MetaTile(
                            label: strings.detailImportedOn,
                            value: strings.formatDate(document.importedAt),
                          ),
                          _MetaTile(
                            label: strings.detailConfidence,
                            value: strings.formatPercent(document.confidence),
                          ),
                          _MetaTile(
                            label: strings.detailFieldsCount,
                            value: '${document.fields.length}',
                          ),
                          if (document.validatedAt != null)
                            _MetaTile(
                              label: strings.detailValidatedOn,
                              value: strings.formatDate(document.validatedAt!),
                            ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        strings.detailExtractedFields,
                        style: const TextStyle(
                          color: AppColors.ink,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.paper,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.line),
                        ),
                        child: Column(
                          children: [
                            for (
                              var index = 0;
                              index < document.fields.length;
                              index++
                            ) ...[
                              if (index > 0)
                                const Divider(height: 1, color: AppColors.line),
                              _FieldRow(
                                field: document.fields[index],
                                language: strings.language,
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      DocumentPreview(document: document, compact: true),
                      const SizedBox(height: 8),
                      Text(
                        document.id,
                        style: const TextStyle(
                          color: AppColors.inkMuted,
                          fontSize: 10,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
                if (document.status == DocumentStatus.pending)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
                    decoration: const BoxDecoration(
                      color: AppColors.surface,
                      border: Border(top: BorderSide(color: AppColors.line)),
                    ),
                    child: FilledButton.icon(
                      onPressed: () => Navigator.of(context).pop(true),
                      icon: const Icon(Icons.fact_check_outlined, size: 18),
                      label: Text(strings.actionVerify),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FieldRow extends StatelessWidget {
  const _FieldRow({required this.field, required this.language});

  final ExtractedField field;
  final AppLanguage language;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  field.label(language),
                  style: const TextStyle(
                    color: AppColors.inkMuted,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  field.value,
                  textDirection: language.isArabic
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ConfidencePill(confidence: field.confidence, dense: true),
        ],
      ),
    );
  }
}

class _MetaTile extends StatelessWidget {
  const _MetaTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 138),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
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
            style: const TextStyle(
              color: AppColors.inkMuted,
              fontSize: 9.5,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.ink,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _NoticeBanner extends StatelessWidget {
  const _NoticeBanner({
    required this.icon,
    required this.text,
    required this.color,
    required this.background,
  });

  final IconData icon;
  final String text;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 17, color: color),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
