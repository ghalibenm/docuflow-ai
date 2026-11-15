import 'dart:typed_data';

import '../models/models.dart';

class ExtractionService {
  const ExtractionService();

  DocRecord fromSample(SampleDocument sample, {required String pilotId}) {
    return DocRecord(
      id: _newId(),
      kind: sample.kind,
      sourceLanguage: sample.language,
      importedAt: DateTime.now(),
      fields: List<ExtractedField>.unmodifiable(sample.fields),
      status: DocumentStatus.pending,
      fileName: sample.fileName,
      pilotId: pilotId,
      minutesSaved: 0,
    );
  }

  DocRecord fromFile({
    required String fileName,
    required AppLanguage language,
    required String pilotId,
    Uint8List? imageBytes,
  }) {
    final placeholder = language.isArabic ? 'بحاجة إلى إكمال' : 'À compléter';
    final reference = _referenceFrom(fileName);

    final fields = <ExtractedField>[
      ExtractedField(
        id: 'reference',
        labelFr: 'Référence',
        labelAr: 'المرجع',
        value: reference,
        confidence: 0.86,
      ),
      ExtractedField(
        id: 'date',
        labelFr: 'Date du document',
        labelAr: 'تاريخ المستند',
        value: placeholder,
        confidence: 0.62,
      ),
      ExtractedField(
        id: 'party',
        labelFr: 'Tiers',
        labelAr: 'الطرف',
        value: placeholder,
        confidence: 0.78,
      ),
      ExtractedField(
        id: 'amount',
        labelFr: 'Montant',
        labelAr: 'المبلغ',
        value: '—',
        confidence: 0.81,
      ),
    ];

    return DocRecord(
      id: _newId(),
      kind: DocumentKind.custom,
      sourceLanguage: language,
      importedAt: DateTime.now(),
      fields: fields,
      status: DocumentStatus.pending,
      fileName: fileName,
      imageBytes: imageBytes,
      pilotId: pilotId,
      minutesSaved: 0,
    );
  }

  String _referenceFrom(String fileName) {
    final cleaned = fileName
        .split('.')
        .first
        .replaceAll(RegExp(r'[^A-Za-z0-9]+'), '-');
    final suffix = DateTime.now().millisecondsSinceEpoch % 1000;
    final base = cleaned.isEmpty ? 'DOC' : cleaned.toUpperCase();
    final trimmed = base.length > 18 ? base.substring(0, 18) : base;
    return '$trimmed-$suffix';
  }

  String _newId() {
    final now = DateTime.now();
    final sequence = (now.millisecondsSinceEpoch % 100000).toString().padLeft(
      5,
      '0',
    );
    return 'DF-${now.year}-$sequence';
  }
}
