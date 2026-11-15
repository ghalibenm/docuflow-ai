import '../models/models.dart';

extension DocRecordStats on Iterable<DocRecord> {
  Iterable<DocRecord> get validatedDocuments =>
      where((document) => document.status == DocumentStatus.validated);

  Iterable<DocRecord> get pendingDocuments =>
      where((document) => document.status == DocumentStatus.pending);

  Iterable<DocRecord> get rejectedDocuments =>
      where((document) => document.status == DocumentStatus.rejected);

  int get validatedCount => validatedDocuments.length;

  int get pendingCount => pendingDocuments.length;

  int get rejectedCount => rejectedDocuments.length;

  double get totalMinutesSaved => validatedDocuments.fold<double>(
    0,
    (total, document) => total + document.minutesSaved,
  );

  int get structuredFieldCount =>
      fold<int>(0, (total, document) => total + document.fields.length);

  double get averageConfidence {
    final documents = validatedDocuments.toList();
    if (documents.isEmpty) return 0;
    final fields = documents.expand((document) => document.fields).toList();
    if (fields.isEmpty) return 0;
    final total = fields.fold<double>(
      0,
      (sum, field) => sum + field.confidence,
    );
    return total / fields.length;
  }

  int validatedCountForPilot(String pilotId) => where(
    (document) =>
        document.pilotId == pilotId &&
        document.status == DocumentStatus.validated,
  ).length;

  double minutesSavedForPilot(String pilotId) => where(
    (document) =>
        document.pilotId == pilotId &&
        document.status == DocumentStatus.validated,
  ).fold<double>(0, (total, document) => total + document.minutesSaved);

  List<DocRecord> get sortedByRecentFirst {
    final documents = toList()
      ..sort((a, b) => b.importedAt.compareTo(a.importedAt));
    return documents;
  }

  Map<DocumentKind, int> get validatedCountByKind {
    final counts = <DocumentKind, int>{};
    for (final document in validatedDocuments) {
      counts.update(document.kind, (value) => value + 1, ifAbsent: () => 1);
    }
    return counts;
  }

  int get importedThisWeek => where((document) {
    final difference = DateTime.now().difference(document.importedAt);
    return difference.inDays < 7;
  }).length;
}

double averageMinutesPerValidatedDocument(Iterable<DocRecord> documents) {
  final validated = documents.validatedDocuments.toList();
  if (validated.isEmpty) return 0;
  return validated.fold<double>(
        0,
        (total, document) => total + document.minutesSaved,
      ) /
      validated.length;
}
