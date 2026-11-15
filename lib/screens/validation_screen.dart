import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import '../widgets/brand.dart';
import '../widgets/common.dart';
import '../widgets/document_preview.dart';

class ValidationScreen extends StatefulWidget {
  const ValidationScreen({super.key, required this.documentId});

  final String documentId;

  @override
  State<ValidationScreen> createState() => _ValidationScreenState();
}

class _ValidationScreenState extends State<ValidationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};
  bool _initialized = false;
  bool _saving = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    final document = AppScope.of(context).documentById(widget.documentId);
    if (document == null) return;
    for (final field in document.fields) {
      _controllers[field.id] = TextEditingController(text: field.value);
    }
    _initialized = true;
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  List<ExtractedField> _updatedFields(DocRecord document) {
    return document.fields
        .map((field) {
          final controller = _controllers[field.id];
          return field.copyWith(value: controller?.text.trim() ?? field.value);
        })
        .toList(growable: false);
  }

  bool _isEdited(ExtractedField field) {
    final controller = _controllers[field.id];
    return controller != null && controller.text.trim() != field.value.trim();
  }

  Future<void> _validate(DocRecord document) async {
    if (_saving) return;
    if (!(_formKey.currentState?.validate() ?? false)) {
      showAppSnackBar(
        context,
        AppScope.of(context).text.validationIncomplete,
        error: true,
      );
      return;
    }

    setState(() => _saving = true);
    final state = AppScope.of(context);
    state.validateDocument(document.id, _updatedFields(document));
    if (!mounted) return;
    final validated = state.documentById(document.id) ?? document;
    setState(() => _saving = false);
    await _showSuccessDialog(validated);
  }

  Future<void> _reject(DocRecord document) async {
    final strings = AppScope.of(context).text;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: Text(
          strings.validationRejectTitle,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        content: Text(
          strings.validationRejectText,
          style: const TextStyle(
            fontSize: 13,
            height: 1.5,
            color: AppColors.inkSoft,
          ),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(strings.actionCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
            child: Text(strings.actionReject),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;
    final state = AppScope.of(context);
    state.rejectDocument(document.id);
    showAppSnackBar(context, strings.validationRejected);
    Navigator.of(context).pop();
  }

  Future<void> _showSuccessDialog(DocRecord document) async {
    final state = AppScope.of(context);
    final strings = state.text;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(26, 28, 26, 22),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 68,
                    height: 68,
                    decoration: BoxDecoration(
                      color: AppColors.mint,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.mintDeep, width: 1.5),
                    ),
                    child: const Icon(
                      Icons.verified_rounded,
                      color: AppColors.primary,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    strings.validationSuccessTitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                      letterSpacing: -0.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    strings.validationSuccessText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12.5,
                      height: 1.5,
                      color: AppColors.inkMuted,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Pill(
                    label: strings.successSaved(
                      strings.formatPreciseMinutes(document.minutesSaved),
                    ),
                    color: AppColors.primary,
                    background: AppColors.mint,
                    icon: Icons.bolt_rounded,
                  ),
                  const SizedBox(height: 22),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                        state.selectTab(2);
                      },
                      icon: const Icon(Icons.table_rows_outlined, size: 18),
                      label: Text(strings.actionViewRegister),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                        state.selectTab(1);
                      },
                      child: Text(strings.actionImportAnother),
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

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final strings = state.text;
    final document = state.documentById(widget.documentId);

    if (document == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.paper,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_rounded),
          ),
        ),
        body: Center(
          child: EmptyState(
            icon: Icons.search_off_rounded,
            title: strings.recordsEmptyTitle,
            text: strings.recordsEmptyText,
          ),
        ),
      );
    }

    final pilot = state.pilotById(document.pilotId);
    final wide = MediaQuery.sizeOf(context).width >= 980;

    return Scaffold(
      backgroundColor: AppColors.paper,
      appBar: AppBar(
        backgroundColor: AppColors.paper,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leadingWidth: 66,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: IconButton(
            tooltip: strings.actionClose,
            onPressed: () => Navigator.of(context).pop(),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.surface,
              side: const BorderSide(color: AppColors.line),
            ),
            icon: const Icon(Icons.arrow_back_rounded, size: 19),
          ),
        ),
        titleSpacing: 12,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              strings.validationTitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.ink,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.2,
              ),
            ),
            Text(
              document.id,
              style: const TextStyle(
                color: AppColors.inkMuted,
                fontSize: 10,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
        actions: [
          if (MediaQuery.sizeOf(context).width > 720)
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 10),
              child: Pill(
                label: strings.simulated,
                color: AppColors.amberDeep,
                background: AppColors.amberSoft,
                icon: Icons.auto_awesome_rounded,
              ),
            ),
          const Padding(
            padding: EdgeInsetsDirectional.only(end: 16),
            child: LanguageToggle(compact: true),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(wide ? 28 : 16, 18, wide ? 28 : 16, 34),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1220),
            child: wide
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 390,
                        child: _SourcePanel(document: document, pilot: pilot),
                      ),
                      const SizedBox(width: 22),
                      Expanded(
                        child: _FormPanel(
                          document: document,
                          formKey: _formKey,
                          controllers: _controllers,
                          isEdited: _isEdited,
                          saving: _saving,
                          onValidate: () => _validate(document),
                          onReject: () => _reject(document),
                          onChanged: () => setState(() {}),
                        ),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 520),
                        child: _SourcePanel(document: document, pilot: pilot),
                      ),
                      const SizedBox(height: 16),
                      _FormPanel(
                        document: document,
                        formKey: _formKey,
                        controllers: _controllers,
                        isEdited: _isEdited,
                        saving: _saving,
                        onValidate: () => _validate(document),
                        onReject: () => _reject(document),
                        onChanged: () => setState(() {}),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class _SourcePanel extends StatelessWidget {
  const _SourcePanel({required this.document, required this.pilot});

  final DocRecord document;
  final PilotCompany? pilot;

  @override
  Widget build(BuildContext context) {
    final strings = AppScope.of(context).text;

    return Column(
      children: [
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      strings.validationSource,
                      style: const TextStyle(
                        color: AppColors.ink,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Pill(
                    label: strings.languageLabel(document.sourceLanguage),
                    color: AppColors.blue,
                    background: AppColors.blueSoft,
                    icon: Icons.translate_rounded,
                    dense: true,
                  ),
                ],
              ),
              const SizedBox(height: 14),
              DocumentPreview(document: document),
              const SizedBox(height: 16),
              _MetaRow(
                icon: Icons.business_outlined,
                label: strings.detailPilot,
                value: pilot?.name ?? strings.detailNoPilot,
              ),
              const SizedBox(height: 9),
              _MetaRow(
                icon: Icons.schedule_rounded,
                label: strings.validationImported,
                value: strings.relativeTime(document.importedAt),
              ),
              const SizedBox(height: 9),
              _MetaRow(
                icon: Icons.verified_outlined,
                label: strings.detailConfidence,
                value: strings.formatPercent(document.confidence),
              ),
              if (pilot != null) ...[
                const SizedBox(height: 9),
                _MetaRow(
                  icon: Icons.account_tree_outlined,
                  label: strings.pilotProcess,
                  value: pilot!.process(strings.language),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 14),
        AppCard(
          color: AppColors.amberSoft,
          border: false,
          shadow: false,
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.55),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.fact_check_outlined,
                  color: AppColors.amberDeep,
                  size: 18,
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      strings.validationCheckTitle,
                      style: const TextStyle(
                        color: AppColors.amberDeep,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      strings.validationCheckText,
                      style: const TextStyle(
                        color: AppColors.amberDeep,
                        fontSize: 10.5,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14, color: AppColors.inkMuted),
        const SizedBox(width: 7),
        Text(
          '$label · ',
          style: const TextStyle(color: AppColors.inkMuted, fontSize: 10.5),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: AppColors.inkSoft,
              fontSize: 10.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class _FormPanel extends StatelessWidget {
  const _FormPanel({
    required this.document,
    required this.formKey,
    required this.controllers,
    required this.isEdited,
    required this.saving,
    required this.onValidate,
    required this.onReject,
    required this.onChanged,
  });

  final DocRecord document;
  final GlobalKey<FormState> formKey;
  final Map<String, TextEditingController> controllers;
  final bool Function(ExtractedField) isEdited;
  final bool saving;
  final VoidCallback onValidate;
  final VoidCallback onReject;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final strings = AppScope.of(context).text;
    final lowConfidenceCount = document.fields
        .where((field) => field.confidence < 0.85)
        .length;

    return AppCard(
      padding: const EdgeInsets.all(22),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionTitle(
              title: strings.validationFields,
              subtitle: strings.validationRequiredHint,
              count: document.fields.length,
            ),
            const SizedBox(height: 14),
            Text(
              strings.validationSubtitle,
              style: const TextStyle(
                color: AppColors.inkMuted,
                fontSize: 11.5,
                height: 1.45,
              ),
            ),
            if (lowConfidenceCount > 0) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: AppColors.amberSoft,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: AppColors.amberDeep,
                      size: 16,
                    ),
                    const SizedBox(width: 7),
                    Text(
                      '$lowConfidenceCount ${strings.validationLowConfidence.toLowerCase()}',
                      style: const TextStyle(
                        color: AppColors.amberDeep,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 18),
            for (var index = 0; index < document.fields.length; index++) ...[
              _FieldEditor(
                field: document.fields[index],
                document: document,
                controller: controllers[document.fields[index].id]!,
                edited: isEdited(document.fields[index]),
                onChanged: onChanged,
              ),
              if (index < document.fields.length - 1)
                const SizedBox(height: 16),
            ],
            const SizedBox(height: 22),
            const Divider(height: 1, color: AppColors.line),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                final buttons = [
                  OutlinedButton.icon(
                    onPressed: saving ? null : onReject,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.danger,
                      side: BorderSide(
                        color: AppColors.danger.withValues(alpha: 0.3),
                      ),
                    ),
                    icon: const Icon(Icons.close_rounded, size: 17),
                    label: Text(strings.actionReject),
                  ),
                  FilledButton.icon(
                    onPressed: saving ? null : onValidate,
                    icon: saving
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.check_rounded, size: 18),
                    label: Text(strings.actionValidate),
                  ),
                ];

                if (constraints.maxWidth < 460) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      buttons[1],
                      const SizedBox(height: 8),
                      buttons[0],
                    ],
                  );
                }
                return Row(
                  children: [
                    buttons[0],
                    const SizedBox(width: 10),
                    Expanded(child: buttons[1]),
                  ],
                );
              },
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  Icons.lock_outline_rounded,
                  size: 13,
                  color: AppColors.inkMuted,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    strings.validationFooter,
                    style: const TextStyle(
                      color: AppColors.inkMuted,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FieldEditor extends StatelessWidget {
  const _FieldEditor({
    required this.field,
    required this.document,
    required this.controller,
    required this.edited,
    required this.onChanged,
  });

  final ExtractedField field;
  final DocRecord document;
  final TextEditingController controller;
  final bool edited;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final strings = AppScope.of(context).text;
    final rtl = document.sourceLanguage.isArabic;
    final lowConfidence = field.confidence < 0.85;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: RichText(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                  style: const TextStyle(
                    color: AppColors.inkSoft,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                  ),
                  children: [
                    TextSpan(text: field.label(strings.language)),
                    if (field.required)
                      const TextSpan(
                        text: ' *',
                        style: TextStyle(color: AppColors.danger),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            ConfidencePill(confidence: field.confidence, dense: true),
            if (edited) ...[
              const SizedBox(width: 6),
              Pill(
                label: strings.validationEdited,
                color: AppColors.blue,
                background: AppColors.blueSoft,
                dense: true,
              ),
            ],
            if (lowConfidence) ...[
              const SizedBox(width: 5),
              const Icon(
                Icons.error_outline_rounded,
                size: 14,
                color: AppColors.amberDeep,
              ),
            ],
          ],
        ),
        const SizedBox(height: 7),
        TextFormField(
          controller: controller,
          textDirection: rtl ? TextDirection.rtl : TextDirection.ltr,
          textAlign: rtl ? TextAlign.right : TextAlign.left,
          style: const TextStyle(
            color: AppColors.ink,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: lowConfidence
                ? AppColors.amberSoft.withValues(alpha: 0.35)
                : AppColors.surface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 13,
            ),
          ),
          onChanged: (_) => onChanged(),
          validator: (value) {
            if (!field.required) return null;
            if (value == null || value.trim().isEmpty) {
              return strings.validationEmptyField;
            }
            if (isPlaceholderValue(value)) {
              return strings.validationPlaceholderField;
            }
            return null;
          },
        ),
      ],
    );
  }
}
