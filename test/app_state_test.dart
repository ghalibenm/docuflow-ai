import 'package:docuflow_ai/core/doc_stats.dart';
import 'package:docuflow_ai/data/extraction_service.dart';
import 'package:docuflow_ai/models/models.dart';
import 'package:docuflow_ai/state/app_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('demo state exposes the seeded pilot metrics', () {
    final state = AppState.demo();

    expect(state.documents.length, 12);
    expect(state.documents.validatedCount, 9);
    expect(state.documents.pendingCount, 2);
    expect(state.documents.rejectedCount, 1);
    expect(state.documents.totalMinutesSaved, closeTo(50.6, 0.001));
    expect(state.pilots.length, 3);
  });

  test('validating a document updates status, saved time and count', () {
    final state = AppState.demo();
    final pending = state.documents.firstWhere(
      (document) => document.status == DocumentStatus.pending,
    );
    final validatedBefore = state.documents.validatedCount;
    final savedBefore = state.documents.totalMinutesSaved;
    final pilot = state.pilotById(pending.pilotId)!;

    state.validateDocument(pending.id, pending.fields);

    final updated = state.documentById(pending.id)!;
    expect(updated.status, DocumentStatus.validated);
    expect(updated.validatedAt, isNotNull);
    expect(updated.minutesSaved, pilot.minutesSavedPerDocument);
    expect(state.documents.validatedCount, validatedBefore + 1);
    expect(
      state.documents.totalMinutesSaved,
      closeTo(savedBefore + pilot.minutesSavedPerDocument, 0.001),
    );
  });

  test('rejecting a document clears its saved time', () {
    final state = AppState.demo();
    final pending = state.documents.firstWhere(
      (document) => document.status == DocumentStatus.pending,
    );

    state.rejectDocument(pending.id);

    final updated = state.documentById(pending.id)!;
    expect(updated.status, DocumentStatus.rejected);
    expect(updated.minutesSaved, 0);
    expect(state.documents.rejectedCount, 2);
  });

  test('custom extraction keeps uncertain values as placeholders', () {
    final document = const ExtractionService().fromFile(
      fileName: 'facture-scan.pdf',
      language: AppLanguage.fr,
      pilotId: 'moreau',
    );

    final placeholders = document.fields.where((field) => field.isPlaceholder);
    expect(placeholders, hasLength(3));
    expect(document.party, isNull);
    expect(document.amount, isNull);
    expect(document.documentDate, isNull);
    expect(document.reference, isNotNull);
  });
}
