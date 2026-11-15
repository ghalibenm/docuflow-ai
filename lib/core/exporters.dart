import 'doc_stats.dart';
import '../l10n/app_strings.dart';
import '../models/models.dart';

String buildCsv({
  required List<DocRecord> documents,
  required AppStrings strings,
}) {
  final rows = <List<String>>[
    <String>[
      'ID',
      strings.colDocument,
      strings.colType,
      strings.colParty,
      strings.colDate,
      strings.csvReference,
      strings.csvAmount,
      strings.colConfidence,
      strings.colStatus,
      strings.detailLanguage,
      strings.validationFile,
      strings.csvFields,
      strings.csvTimeSaved,
    ],
  ];

  for (final document in documents) {
    rows.add(<String>[
      document.id,
      strings.documentTitle(document),
      strings.kindLabel(document.kind),
      document.party ?? strings.recordsEmptyValue,
      document.documentDate ?? strings.recordsEmptyValue,
      document.reference ?? strings.recordsEmptyValue,
      document.amount ?? strings.recordsEmptyValue,
      strings.formatPercent(document.confidence),
      strings.statusLabel(document.status),
      strings.languageLabel(document.sourceLanguage),
      document.fileName ?? strings.recordsEmptyValue,
      document.fields
          .where((field) => !field.isPlaceholder)
          .map((field) => '${field.label(strings.language)}: ${field.value}')
          .join(' | '),
      strings.formatDecimal(document.minutesSaved),
    ]);
  }

  return rows.map(_csvRow).join('\r\n');
}

String _csvRow(List<String> cells) => cells.map(_csvCell).join(';');

String _csvCell(String value) {
  var safe = value.replaceAll(RegExp(r'[\r\n]+'), ' ');
  if (safe.isNotEmpty && '=+-@\t'.contains(safe[0])) {
    safe = "'$safe";
  }
  final escaped = safe.replaceAll('"', '""');
  return '"$escaped"';
}

String buildReportText({
  required List<DocRecord> documents,
  required List<PilotCompany> pilots,
  required AppStrings strings,
  DateTime? generatedAt,
}) {
  final date = generatedAt ?? DateTime.now();
  final buffer = StringBuffer()
    ..writeln('${strings.appName} — ${strings.reportTitle}')
    ..writeln('${strings.reportGenerated} ${strings.formatDate(date)}')
    ..writeln('')
    ..writeln('${strings.docsLabel}: ${documents.length}')
    ..writeln('${strings.validatedLabel}: ${documents.validatedCount}')
    ..writeln('${strings.pendingLabel}: ${documents.pendingCount}')
    ..writeln('${strings.filterRejected}: ${documents.rejectedCount}')
    ..writeln('${strings.fieldsStructured}: ${documents.structuredFieldCount}')
    ..writeln(
      '${strings.accuracyLabel}: ${strings.formatPercent(documents.averageConfidence)}',
    )
    ..writeln(
      '${strings.reportHoursSaved}: ${strings.formatMinutes(documents.totalMinutesSaved)}',
    )
    ..writeln(
      '${strings.reportAverageTime}: ${strings.formatMinutes(averageMinutesPerValidatedDocument(documents))}',
    )
    ..writeln('')
    ..writeln(strings.reportByPilot);

  for (final pilot in pilots) {
    buffer.writeln(
      '- ${pilot.name}: ${documents.validatedCountForPilot(pilot.id)} '
      '${strings.recordsStatValidated} · '
      '${strings.formatMinutes(documents.minutesSavedForPilot(pilot.id))}',
    );
  }

  buffer
    ..writeln('')
    ..writeln(strings.reportByType);

  final counts = documents.validatedCountByKind;
  for (final entry in counts.entries) {
    buffer.writeln('- ${strings.kindLabel(entry.key)}: ${entry.value}');
  }

  return buffer.toString().trimRight();
}
