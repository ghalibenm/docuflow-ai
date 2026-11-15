import 'package:file_selector/file_selector.dart' as file_selector;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../core/app_theme.dart';
import '../data/extraction_service.dart';
import '../data/sample_data.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import '../widgets/common.dart';
import '../widgets/document_preview.dart';
import 'validation_screen.dart';

class ImportScreen extends StatefulWidget {
  const ImportScreen({super.key});

  @override
  State<ImportScreen> createState() => _ImportScreenState();
}

class _ImportScreenState extends State<ImportScreen> {
  static const _maxFileSize = 10 * 1024 * 1024;
  static const _imageExtensions = [
    '.jpg',
    '.jpeg',
    '.png',
    '.webp',
    '.heic',
    '.heif',
  ];

  final ExtractionService _extractionService = const ExtractionService();
  late String _selectedPilotId;

  bool _processing = false;
  int _completedSteps = 0;
  DocRecord? _processingRecord;

  @override
  void initState() {
    super.initState();
    _selectedPilotId = SampleData.pilots.first.id;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final state = AppScope.of(context);
    if (!state.pilots.any((pilot) => pilot.id == _selectedPilotId)) {
      _selectedPilotId = state.pilots.first.id;
    }
  }

  Future<void> _pickPhoto() async {
    if (_processing) return;
    final isMobile =
        !kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS);
    final source = isMobile ? ImageSource.camera : ImageSource.gallery;
    try {
      final picked = await ImagePicker().pickImage(
        source: source,
        maxWidth: 2200,
        imageQuality: 90,
      );
      if (picked == null) return;
      final size = await picked.length();
      if (!mounted) return;
      if (size > _maxFileSize) {
        showAppSnackBar(
          context,
          AppScope.of(context).text.importFileTooLarge,
          error: true,
        );
        return;
      }
      final bytes = await picked.readAsBytes();
      if (!mounted) return;
      await _importBytes(picked.name, bytes, forceImage: true);
    } catch (_) {
      if (!mounted) return;
      showAppSnackBar(
        context,
        AppScope.of(context).text.importPhotoError,
        error: true,
      );
    }
  }

  Future<void> _pickFile() async {
    if (_processing) return;
    final strings = AppScope.of(context).text;
    final typeGroup = file_selector.XTypeGroup(
      label: strings.docsLabel,
      extensions: ['pdf', 'png', 'jpg', 'jpeg', 'webp', 'heic', 'heif'],
    );
    try {
      final picked = await file_selector.openFile(
        acceptedTypeGroups: [typeGroup],
      );
      if (picked == null) return;
      final size = await picked.length();
      if (!mounted) return;
      if (size > _maxFileSize) {
        showAppSnackBar(context, strings.importFileTooLarge, error: true);
        return;
      }
      final bytes = await picked.readAsBytes();
      if (!mounted) return;
      await _importBytes(picked.name, bytes);
    } catch (_) {
      if (!mounted) return;
      showAppSnackBar(context, strings.importError, error: true);
    }
  }

  Future<void> _importBytes(
    String fileName,
    Uint8List bytes, {
    bool forceImage = false,
  }) async {
    final strings = AppScope.of(context).text;
    if (bytes.length > _maxFileSize) {
      showAppSnackBar(context, strings.importFileTooLarge, error: true);
      return;
    }
    final lowerName = fileName.toLowerCase();
    final isImage =
        forceImage || _imageExtensions.any((ext) => lowerName.endsWith(ext));
    final state = AppScope.of(context);
    final record = _extractionService.fromFile(
      fileName: fileName,
      language: state.language,
      pilotId: _selectedPilotId,
      imageBytes: isImage ? bytes : null,
    );
    await _runExtraction(record);
  }

  Future<void> _importSample(SampleDocument sample) async {
    if (_processing) return;
    final record = _extractionService.fromSample(
      sample,
      pilotId: sample.pilotId,
    );
    await _runExtraction(record);
  }

  Future<void> _runExtraction(DocRecord record) async {
    final state = AppScope.of(context);
    if (!mounted) return;
    setState(() {
      _processing = true;
      _completedSteps = 0;
      _processingRecord = record;
    });

    for (var step = 0; step < 4; step++) {
      await Future<void>.delayed(const Duration(milliseconds: 520));
      if (!mounted) return;
      setState(() => _completedSteps = step + 1);
    }

    await Future<void>.delayed(const Duration(milliseconds: 280));
    if (!mounted) return;

    state.addDocument(record);
    setState(() {
      _processing = false;
      _completedSteps = 0;
      _processingRecord = null;
    });
    if (state.tabIndex != 1) return;
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ValidationScreen(documentId: record.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final strings = state.text;
    final selectedPilot =
        state.pilotById(_selectedPilotId) ?? state.pilots.first;

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
                    eyebrow: strings.navImport,
                    title: strings.importTitle,
                    subtitle: strings.importSubtitle,
                    actions: Pill(
                      label: strings.importPrivacy,
                      color: AppColors.primary,
                      background: AppColors.mint,
                      icon: Icons.lock_outline_rounded,
                    ),
                  ),
                  const SizedBox(height: 22),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 260),
                    child: _processing && _processingRecord != null
                        ? _ProcessingPanel(
                            key: const ValueKey('processing'),
                            document: _processingRecord!,
                            completedSteps: _completedSteps,
                          )
                        : _ImportContent(
                            key: const ValueKey('form'),
                            selectedPilotId: _selectedPilotId,
                            selectedPilot: selectedPilot,
                            onPilotChanged: (pilotId) {
                              if (pilotId == null) return;
                              setState(() => _selectedPilotId = pilotId);
                            },
                            onPhoto: _pickPhoto,
                            onFile: _pickFile,
                            onSample: _importSample,
                          ),
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

class _ImportContent extends StatelessWidget {
  const _ImportContent({
    super.key,
    required this.selectedPilotId,
    required this.selectedPilot,
    required this.onPilotChanged,
    required this.onPhoto,
    required this.onFile,
    required this.onSample,
  });

  final String selectedPilotId;
  final PilotCompany selectedPilot;
  final ValueChanged<String?> onPilotChanged;
  final VoidCallback onPhoto;
  final VoidCallback onFile;
  final ValueChanged<SampleDocument> onSample;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final strings = state.text;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _PilotSelector(
          selectedPilotId: selectedPilotId,
          selectedPilot: selectedPilot,
          onChanged: onPilotChanged,
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth >= 720) {
              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: _SourceCard(
                        icon: Icons.photo_camera_outlined,
                        title: strings.importPhotoTitle,
                        description: strings.importPhotoText,
                        badge: strings.importCamera,
                        onTap: onPhoto,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _SourceCard(
                        icon: Icons.upload_file_outlined,
                        title: strings.importFileTitle,
                        description: strings.importFileText,
                        badge: 'PDF · JPG · PNG',
                        onTap: onFile,
                      ),
                    ),
                  ],
                ),
              );
            }
            return Column(
              children: [
                _SourceCard(
                  icon: Icons.photo_camera_outlined,
                  title: strings.importPhotoTitle,
                  description: strings.importPhotoText,
                  badge: strings.importCamera,
                  onTap: onPhoto,
                ),
                const SizedBox(height: 12),
                _SourceCard(
                  icon: Icons.upload_file_outlined,
                  title: strings.importFileTitle,
                  description: strings.importFileText,
                  badge: 'PDF · JPG · PNG',
                  onTap: onFile,
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 16),
        const _HowItWorksStrip(),
        const SizedBox(height: 28),
        SectionTitle(
          title: strings.importSamplesTitle,
          subtitle: strings.importSamplesSubtitle,
        ),
        const SizedBox(height: 14),
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth >= 880 ? 2 : 1;
            const gap = 14.0;
            final width =
                (constraints.maxWidth - gap * (columns - 1)) / columns;
            return Wrap(
              spacing: gap,
              runSpacing: gap,
              children: [
                for (final sample in SampleData.samples)
                  SizedBox(
                    width: width,
                    child: _SampleCard(
                      sample: sample,
                      pilotName: state.pilotById(sample.pilotId)?.name ?? '',
                      onTap: () => onSample(sample),
                    ),
                  ),
              ],
            );
          },
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            const Icon(
              Icons.shield_outlined,
              size: 15,
              color: AppColors.inkMuted,
            ),
            const SizedBox(width: 7),
            Expanded(
              child: Text(
                strings.importPrivacy,
                style: const TextStyle(color: AppColors.inkMuted, fontSize: 11),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PilotSelector extends StatelessWidget {
  const _PilotSelector({
    required this.selectedPilotId,
    required this.selectedPilot,
    required this.onChanged,
  });

  final String selectedPilotId;
  final PilotCompany selectedPilot;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final strings = state.text;

    return AppCard(
      padding: const EdgeInsets.all(16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final dropdown = DropdownButtonFormField<String>(
            initialValue: selectedPilotId,
            isExpanded: true,
            isDense: true,
            icon: const Icon(Icons.expand_more_rounded, size: 20),
            dropdownColor: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            style: const TextStyle(
              color: AppColors.ink,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
            ),
            items: [
              for (final pilot in state.pilots)
                DropdownMenuItem<String>(
                  value: pilot.id,
                  child: Text(pilot.name),
                ),
            ],
            onChanged: onChanged,
          );

          final label = Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.mint,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.business_outlined,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      strings.importPilotLabel,
                      style: const TextStyle(
                        color: AppColors.ink,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      strings.importPilotHint,
                      style: const TextStyle(
                        color: AppColors.inkMuted,
                        fontSize: 10.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );

          if (constraints.maxWidth < 560) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [label, const SizedBox(height: 12), dropdown],
            );
          }

          return Row(
            children: [
              Expanded(child: label),
              const SizedBox(width: 16),
              SizedBox(
                width: constraints.maxWidth > 760 ? 230 : 190,
                child: dropdown,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SourceCard extends StatelessWidget {
  const _SourceCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.badge,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String description;
  final String badge;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppLayout.radius),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppLayout.radius),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Icon(icon, color: Colors.white, size: 21),
                    ),
                    const Spacer(),
                    Pill(
                      label: badge,
                      color: AppColors.inkSoft,
                      background: AppColors.paperDeep,
                      dense: true,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: const TextStyle(
                    color: AppColors.inkMuted,
                    fontSize: 11.5,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 14),
                const Row(
                  children: [
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 16,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HowItWorksStrip extends StatelessWidget {
  const _HowItWorksStrip();

  @override
  Widget build(BuildContext context) {
    final strings = AppScope.of(context).text;
    final items = [
      (strings.importHow1Title, strings.importHow1Text),
      (strings.importHow2Title, strings.importHow2Text),
      (strings.importHow3Title, strings.importHow3Text),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.paperDeep.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final children = <Widget>[];
          for (var index = 0; index < items.length; index++) {
            children.add(
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.lineStrong),
                      ),
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            items[index].$1,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.ink,
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            items[index].$2,
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
                  ],
                ),
              ),
            );
            if (index < items.length - 1) {
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Icon(
                  Icons.chevron_right_rounded,
                  size: 16,
                  color: AppColors.inkMuted,
                ),
              );
            }
          }

          if (constraints.maxWidth < 620) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var index = 0; index < items.length; index++)
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: index == items.length - 1 ? 0 : 10,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 22,
                          height: 22,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.lineStrong),
                          ),
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 9),
                        Expanded(
                          child: Text(
                            '${items[index].$1} · ${items[index].$2}',
                            style: const TextStyle(
                              color: AppColors.inkSoft,
                              fontSize: 11,
                              height: 1.35,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            );
          }
          return Row(children: children);
        },
      ),
    );
  }
}

class _SampleCard extends StatelessWidget {
  const _SampleCard({
    required this.sample,
    required this.pilotName,
    required this.onTap,
  });

  final SampleDocument sample;
  final String pilotName;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final strings = AppScope.of(context).text;
    final languageColor = sample.language.isArabic
        ? AppColors.amberDeep
        : AppColors.blue;
    final languageBackground = sample.language.isArabic
        ? AppColors.amberSoft
        : AppColors.blueSoft;

    return AppCard(
      padding: EdgeInsets.zero,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppLayout.radius),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppLayout.radius),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Pill(
                      label: strings.importSample,
                      color: AppColors.inkMuted,
                      background: AppColors.paper,
                      dense: true,
                    ),
                    const SizedBox(width: 6),
                    Pill(
                      label: sample.language.toggleLabel,
                      color: languageColor,
                      background: languageBackground,
                      dense: true,
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.arrow_outward_rounded,
                      size: 17,
                      color: AppColors.inkMuted,
                    ),
                  ],
                ),
                const SizedBox(height: 13),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DocumentTypeIcon(kind: sample.kind, size: 40),
                    const SizedBox(width: 11),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            sample.title(strings.language),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.ink,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              height: 1.25,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            strings.fieldsDetected(sample.fields.length),
                            style: const TextStyle(
                              color: AppColors.inkMuted,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  sample.blurb(strings.language),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.inkMuted,
                    fontSize: 11,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(
                      Icons.business_outlined,
                      size: 12,
                      color: AppColors.inkMuted,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        pilotName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.inkSoft,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Text(
                      strings.importSample.toUpperCase(),
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.7,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProcessingPanel extends StatelessWidget {
  const _ProcessingPanel({
    super.key,
    required this.document,
    required this.completedSteps,
  });

  final DocRecord document;
  final int completedSteps;

  @override
  Widget build(BuildContext context) {
    final strings = AppScope.of(context).text;
    final steps = [
      strings.importStep1,
      strings.importStep2,
      strings.importStep3,
      strings.importStep4,
    ];

    final details = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2.2),
            ),
            const SizedBox(width: 9),
            Expanded(
              child: Text(
                strings.importProcessingTitle,
                style: const TextStyle(
                  color: AppColors.ink,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          document.fileName ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: AppColors.inkMuted, fontSize: 11),
        ),
        const SizedBox(height: 20),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: completedSteps / 4,
            minHeight: 6,
            backgroundColor: AppColors.paperDeep,
          ),
        ),
        const SizedBox(height: 22),
        for (var index = 0; index < steps.length; index++) ...[
          _ProcessingStep(
            label: steps[index],
            state: index < completedSteps
                ? _StepState.done
                : index == completedSteps
                ? _StepState.active
                : _StepState.pending,
          ),
          if (index < steps.length - 1) const SizedBox(height: 13),
        ],
        const SizedBox(height: 22),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.paper,
            borderRadius: BorderRadius.circular(11),
            border: Border.all(color: AppColors.line),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.lock_outline_rounded,
                size: 14,
                color: AppColors.inkMuted,
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  strings.importProcessingHint,
                  style: const TextStyle(
                    color: AppColors.inkMuted,
                    fontSize: 10.5,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );

    return AppCard(
      padding: const EdgeInsets.all(22),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 760) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 300,
                  child: _ScanningPreview(document: document),
                ),
                const SizedBox(width: 30),
                Expanded(child: details),
              ],
            );
          }
          return Column(
            children: [
              SizedBox(width: 280, child: _ScanningPreview(document: document)),
              const SizedBox(height: 22),
              details,
            ],
          );
        },
      ),
    );
  }
}

enum _StepState { done, active, pending }

class _ProcessingStep extends StatelessWidget {
  const _ProcessingStep({required this.label, required this.state});

  final String label;
  final _StepState state;

  @override
  Widget build(BuildContext context) {
    final Widget leading;
    switch (state) {
      case _StepState.done:
        leading = Container(
          width: 22,
          height: 22,
          decoration: const BoxDecoration(
            color: AppColors.mint,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check_rounded,
            size: 13,
            color: AppColors.primary,
          ),
        );
      case _StepState.active:
        leading = const SizedBox(
          width: 22,
          height: 22,
          child: Padding(
            padding: EdgeInsets.all(4),
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        );
      case _StepState.pending:
        leading = Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.lineStrong),
          ),
        );
    }

    final color = switch (state) {
      _StepState.done => AppColors.inkSoft,
      _StepState.active => AppColors.ink,
      _StepState.pending => AppColors.inkMuted,
    };

    return Row(
      children: [
        leading,
        const SizedBox(width: 11),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 12.5,
            fontWeight: state == _StepState.active
                ? FontWeight.w600
                : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _ScanningPreview extends StatefulWidget {
  const _ScanningPreview({required this.document});

  final DocRecord document;

  @override
  State<_ScanningPreview> createState() => _ScanningPreviewState();
}

class _ScanningPreviewState extends State<_ScanningPreview>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1700),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppScope.of(context).text;
    return AspectRatio(
      aspectRatio: 0.92,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.paperDeep,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.line),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: SizedBox(
                      width: 300,
                      child: DocumentPreview(
                        document: widget.document,
                        compact: true,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: IgnorePointer(
                child: LayoutBuilder(
                  builder: (context, lineConstraints) {
                    return AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return Stack(
                          children: [
                            Positioned(
                              left: 10,
                              right: 10,
                              top:
                                  20 +
                                  (_controller.value *
                                      (lineConstraints.maxHeight - 40)),
                              child: Container(
                                height: 2,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.primary.withValues(alpha: 0),
                                      const Color(0xFF5EE0B4),
                                      AppColors.primary.withValues(alpha: 0),
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF5EE0B4)
                                          .withValues(alpha: 0.45),
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.ink.withValues(alpha: 0.76),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'OCR · ${widget.document.sourceLanguage.toggleLabel}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 8.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 12,
              bottom: 12,
              child: Row(
                children: [
                  const Icon(
                    Icons.auto_awesome_rounded,
                    size: 12,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    strings.simulated,
                    style: const TextStyle(
                      color: AppColors.primaryDeep,
                      fontSize: 8.5,
                      fontWeight: FontWeight.w600,
                    ),
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
