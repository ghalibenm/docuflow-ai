import 'dart:typed_data';

import 'package:flutter/widgets.dart';

enum AppLanguage { fr, ar }

extension AppLanguageInfo on AppLanguage {
  String get code => name;

  bool get isArabic => this == AppLanguage.ar;

  Locale get locale => Locale(code);

  String get toggleLabel => this == AppLanguage.fr ? 'FR' : 'AR';
}

enum DocumentKind { invoice, supplierForm, deliveryNote, custom }

enum DocumentStatus { pending, validated, rejected }

const Set<String> _placeholderValues = {
  '—',
  '-',
  'À compléter',
  'بحاجة إلى إكمال',
};

bool isPlaceholderValue(String? value) {
  final normalized = value?.trim() ?? '';
  return normalized.isEmpty || _placeholderValues.contains(normalized);
}

class ExtractedField {
  const ExtractedField({
    required this.id,
    required this.labelFr,
    required this.labelAr,
    required this.value,
    required this.confidence,
    this.required = true,
  });

  final String id;
  final String labelFr;
  final String labelAr;
  final String value;
  final double confidence;
  final bool required;

  String label(AppLanguage language) => language.isArabic ? labelAr : labelFr;

  bool get isPlaceholder => isPlaceholderValue(value);

  ExtractedField copyWith({String? value, double? confidence}) {
    return ExtractedField(
      id: id,
      labelFr: labelFr,
      labelAr: labelAr,
      value: value ?? this.value,
      confidence: confidence ?? this.confidence,
      required: required,
    );
  }
}

class DocRecord {
  const DocRecord({
    required this.id,
    required this.kind,
    required this.sourceLanguage,
    required this.importedAt,
    required this.fields,
    required this.status,
    required this.minutesSaved,
    this.validatedAt,
    this.fileName,
    this.imageBytes,
    this.pilotId,
  });

  final String id;
  final DocumentKind kind;
  final AppLanguage sourceLanguage;
  final DateTime importedAt;
  final DateTime? validatedAt;
  final List<ExtractedField> fields;
  final DocumentStatus status;
  final String? fileName;
  final Uint8List? imageBytes;
  final String? pilotId;

  /// Measured saving once the record has been validated.
  final double minutesSaved;

  double get confidence {
    if (fields.isEmpty) return 0;
    final total = fields.fold<double>(
      0,
      (sum, field) => sum + field.confidence,
    );
    return total / fields.length;
  }

  ExtractedField? field(String id) {
    for (final field in fields) {
      if (field.id == id) return field;
    }
    return null;
  }

  String? valueOf(String id) {
    final value = field(id)?.value;
    if (isPlaceholderValue(value)) return null;
    return value!.trim();
  }

  String? get party {
    for (final id in const ['supplier', 'company', 'client', 'party']) {
      final value = valueOf(id);
      if (value != null) return value;
    }
    return null;
  }

  String? get amount {
    for (final id in const ['total', 'amountHT', 'amount']) {
      final value = valueOf(id);
      if (value != null) return value;
    }
    return null;
  }

  String? get reference {
    for (final id in const [
      'invoiceNumber',
      'deliveryNumber',
      'reference',
      'siret',
    ]) {
      final value = valueOf(id);
      if (value != null) return value;
    }
    return null;
  }

  String? get documentDate => valueOf('date');

  DocRecord copyWith({
    DocumentStatus? status,
    List<ExtractedField>? fields,
    DateTime? validatedAt,
    double? minutesSaved,
    String? pilotId,
  }) {
    return DocRecord(
      id: id,
      kind: kind,
      sourceLanguage: sourceLanguage,
      importedAt: importedAt,
      validatedAt: validatedAt ?? this.validatedAt,
      fields: fields ?? this.fields,
      status: status ?? this.status,
      fileName: fileName,
      imageBytes: imageBytes,
      pilotId: pilotId ?? this.pilotId,
      minutesSaved: minutesSaved ?? this.minutesSaved,
    );
  }
}

class PilotCompany {
  const PilotCompany({
    required this.id,
    required this.name,
    required this.sectorFr,
    required this.sectorAr,
    required this.city,
    required this.processFr,
    required this.processAr,
    required this.targetDocuments,
    required this.minutesBefore,
    required this.minutesAfter,
    required this.startedDaysAgo,
  });

  final String id;
  final String name;
  final String sectorFr;
  final String sectorAr;
  final String city;
  final String processFr;
  final String processAr;
  final int targetDocuments;
  final double minutesBefore;
  final double minutesAfter;
  final int startedDaysAgo;

  String sector(AppLanguage language) =>
      language.isArabic ? sectorAr : sectorFr;

  String process(AppLanguage language) =>
      language.isArabic ? processAr : processFr;

  double get minutesSavedPerDocument =>
      (minutesBefore - minutesAfter).clamp(0, 999).toDouble();

  double get timeReduction =>
      minutesBefore == 0 ? 0 : minutesSavedPerDocument / minutesBefore;

  String get initials {
    final parts = name
        .split(RegExp(r'\s+'))
        .where((part) => part.trim().isNotEmpty)
        .toList();
    if (parts.isEmpty) return '?';
    return parts.take(2).map((part) => part[0].toUpperCase()).join();
  }
}

class SampleDocument {
  const SampleDocument({
    required this.id,
    required this.kind,
    required this.language,
    required this.titleFr,
    required this.titleAr,
    required this.blurbFr,
    required this.blurbAr,
    required this.fileName,
    required this.pilotId,
    required this.fields,
  });

  final String id;
  final DocumentKind kind;
  final AppLanguage language;
  final String titleFr;
  final String titleAr;
  final String blurbFr;
  final String blurbAr;
  final String fileName;
  final String pilotId;
  final List<ExtractedField> fields;

  String title(AppLanguage language) => language.isArabic ? titleAr : titleFr;

  String blurb(AppLanguage language) => language.isArabic ? blurbAr : blurbFr;
}
