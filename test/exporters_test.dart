import 'package:docuflow_ai/core/exporters.dart';
import 'package:docuflow_ai/data/extraction_service.dart';
import 'package:docuflow_ai/l10n/app_strings.dart';
import 'package:docuflow_ai/models/models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('CSV omits provisional values and unknown dates', () {
    const strings = AppStrings(AppLanguage.fr);
    final document = const ExtractionService().fromFile(
      fileName: 'scan.pdf',
      language: AppLanguage.fr,
      pilotId: 'moreau',
    );

    final csv = buildCsv(documents: [document], strings: strings);

    expect(csv, isNot(contains('À compléter')));
    expect(csv, isNot(contains('Date du document')));
    expect(csv, contains('Référence:'));
    expect(csv, contains('scan.pdf'));
  });

  test('CSV guards values that a spreadsheet could execute', () {
    const strings = AppStrings(AppLanguage.fr);
    final document = DocRecord(
      id: 'DF-TEST-1',
      kind: DocumentKind.invoice,
      sourceLanguage: AppLanguage.fr,
      importedAt: DateTime(2026),
      fields: const [
        ExtractedField(
          id: 'supplier',
          labelFr: 'Fournisseur',
          labelAr: 'المورد',
          value: '=1+1',
          confidence: 0.9,
        ),
      ],
      status: DocumentStatus.pending,
      minutesSaved: 0,
    );

    final csv = buildCsv(documents: [document], strings: strings);

    expect(csv, isNot(contains('"=1+1"')));
    expect(csv, contains('"\'=1+1"'));
  });
}
