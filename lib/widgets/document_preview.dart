import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../l10n/app_strings.dart';
import '../models/models.dart';
import 'brand.dart';

class DocumentPreview extends StatelessWidget {
  const DocumentPreview({
    super.key,
    required this.document,
    this.compact = false,
  });

  final DocRecord document;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final bytes = document.imageBytes;
    if (bytes != null) {
      return _ImagePreview(document: document, compact: compact);
    }
    return _PaperPreview(document: document, compact: compact);
  }
}

class _ImagePreview extends StatelessWidget {
  const _ImagePreview({required this.document, required this.compact});

  final DocRecord document;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings(document.sourceLanguage);
    return AspectRatio(
      aspectRatio: compact ? 0.92 : 0.74,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.paperDeep,
          borderRadius: BorderRadius.circular(compact ? 16 : 20),
          border: Border.all(color: AppColors.line),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.memory(
                    document.imageBytes!,
                    fit: BoxFit.contain,
                    cacheWidth: compact ? 900 : 1400,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.broken_image_outlined,
                              color: AppColors.inkMuted,
                              size: 32,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              strings.previewUnavailable,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: AppColors.inkMuted,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Positioned(
              top: 12,
              left: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.ink.withValues(alpha: 0.78),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.photo_camera_outlined,
                      size: 12,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      strings.validationPhoto,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaperPreview extends StatelessWidget {
  const _PaperPreview({required this.document, required this.compact});

  final DocRecord document;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings(document.sourceLanguage);
    final isRtl = document.sourceLanguage.isArabic;
    final visibleFields = document.fields
        .take(compact ? 4 : 6)
        .toList(growable: false);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(compact ? 16 : 20),
        border: Border.all(color: AppColors.line),
        boxShadow: [
          BoxShadow(
            color: AppColors.ink.withValues(alpha: 0.05),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 6,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.kindColor(document.kind),
                  AppColors.kindColor(document.kind).withValues(alpha: 0.35),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(compact ? 16 : 22),
            child: Directionality(
              textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const AppLogoMark(size: 28),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'DOCUFLOW · ${strings.appTagline.toUpperCase()}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.inkMuted,
                            fontSize: 8,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.9,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.paperDeep,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          document.sourceLanguage.toggleLabel,
                          style: const TextStyle(
                            color: AppColors.inkSoft,
                            fontSize: 8.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: compact ? 14 : 20),
                  Text(
                    document.fileName ?? strings.kindLabel(document.kind),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.inkMuted,
                      fontSize: 9,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    strings.documentTitle(document),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.ink,
                      fontSize: compact ? 14 : 16,
                      fontWeight: FontWeight.w700,
                      height: 1.25,
                    ),
                  ),
                  SizedBox(height: compact ? 12 : 18),
                  const Divider(height: 1, color: AppColors.line),
                  const SizedBox(height: 10),
                  ...visibleFields.map(
                    (field) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 4,
                            child: Text(
                              field
                                  .label(document.sourceLanguage)
                                  .toUpperCase(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: AppColors.inkMuted,
                                fontSize: 8,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 7,
                            child: Text(
                              field.value,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: AppColors.ink,
                                fontSize: 10.5,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: compact ? 10 : 14),
                  const Divider(height: 1, color: AppColors.line),
                  SizedBox(height: compact ? 10 : 14),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${document.fields.length} ${strings.validationFields.toLowerCase()}',
                              style: const TextStyle(
                                color: AppColors.inkMuted,
                                fontSize: 9,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: List.generate(
                                22,
                                (index) => Container(
                                  width: index.isEven ? 1.6 : 2.6,
                                  height: 14,
                                  margin: const EdgeInsets.only(right: 2),
                                  color: AppColors.ink.withValues(alpha: 0.42),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      _StatusStamp(
                        status: document.status,
                        strings: strings,
                        compact: compact,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusStamp extends StatelessWidget {
  const _StatusStamp({
    required this.status,
    required this.strings,
    required this.compact,
  });

  final DocumentStatus status;
  final AppStrings strings;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final color = AppColors.statusColor(status);
    final label = switch (status) {
      DocumentStatus.pending => strings.stampPending,
      DocumentStatus.validated => strings.stampValidated,
      DocumentStatus.rejected => strings.stampRejected,
    };
    final icon = switch (status) {
      DocumentStatus.pending => Icons.schedule_rounded,
      DocumentStatus.validated => Icons.verified_rounded,
      DocumentStatus.rejected => Icons.close_rounded,
    };
    final size = compact ? 44.0 : 60.0;

    return Transform.rotate(
      angle: -0.1,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: color, width: compact ? 1.3 : 1.8),
          color: AppColors.statusSoftColor(status).withValues(alpha: 0.45),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: compact ? 13 : 18, color: color),
            const SizedBox(height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: TextStyle(
                  color: color,
                  fontSize: compact ? 5.5 : 7,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                  height: 1.1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
