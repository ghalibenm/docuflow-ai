import 'dart:convert';

import 'package:docuflow_ai/app.dart';
import 'package:docuflow_ai/data/extraction_service.dart';
import 'package:docuflow_ai/models/models.dart';
import 'package:docuflow_ai/screens/validation_screen.dart';
import 'package:docuflow_ai/widgets/brand.dart';
import 'package:docuflow_ai/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('dashboard renders and navigation switches tabs', (tester) async {
    tester.view.physicalSize = const Size(1440, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final state = AppState.demo();
    await tester.pumpWidget(DocuFlowApp(state: state));
    await tester.pumpAndSettle();

    expect(find.text('DocuFlow AI'), findsOneWidget);
    expect(find.text('Tableau de bord'), findsWidgets);

    await tester.tap(find.text('Importer').first);
    await tester.pumpAndSettle();

    expect(state.tabIndex, 1);
    expect(find.text('Importer un document'), findsOneWidget);
  });

  testWidgets('language toggle switches the app to Arabic and RTL', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final state = AppState.demo();
    await tester.pumpWidget(DocuFlowApp(state: state));
    await tester.pumpAndSettle();

    await tester.tap(
      find.descendant(
        of: find.byType(LanguageToggle),
        matching: find.text('AR'),
      ),
    );
    await tester.pumpAndSettle();

    expect(state.language, AppLanguage.ar);
    expect(
      Directionality.of(tester.element(find.byType(Scaffold).first)),
      TextDirection.rtl,
    );
    expect(find.text('لوحة التحكم'), findsWidgets);
  });

  testWidgets('all sections render on a phone viewport', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final state = AppState.demo();
    await tester.pumpWidget(DocuFlowApp(state: state));
    await tester.pumpAndSettle();

    for (var tab = 1; tab <= 3; tab++) {
      state.selectTab(tab);
      await tester.pumpAndSettle();
      expect(state.tabIndex, tab);
    }

    state.setLanguage(AppLanguage.ar);
    await tester.pumpAndSettle();
    for (var tab = 0; tab <= 3; tab++) {
      state.selectTab(tab);
      await tester.pumpAndSettle();
      expect(state.tabIndex, tab);
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('sections remain valid around desktop breakpoints', (
    tester,
  ) async {
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    for (final size in const [Size(980, 900), Size(1000, 900)]) {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;

      final state = AppState.demo();
      await tester.pumpWidget(DocuFlowApp(state: state));
      await tester.pumpAndSettle();

      for (final language in AppLanguage.values) {
        state.setLanguage(language);
        for (var tab = 0; tab <= 3; tab++) {
          state.selectTab(tab);
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
        }
      }
    }
  });

  testWidgets('sample import reaches validation and the register', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final state = AppState.demo();
    await tester.pumpWidget(DocuFlowApp(state: state));
    await tester.pumpAndSettle();

    state.selectTab(1);
    await tester.pumpAndSettle();

    final sample = find.text('Facture · Boulangerie Lefèvre');
    await tester.ensureVisible(sample);
    await tester.tap(sample);
    for (var step = 0; step < 5; step++) {
      await tester.pump(const Duration(milliseconds: 600));
    }
    await tester.pumpAndSettle();

    expect(find.text('Vérifier les données extraites'), findsOneWidget);
    expect(state.documents.length, 13);

    final validate = find.text('Valider et enregistrer');
    await tester.ensureVisible(validate);
    await tester.tap(validate);
    await tester.pumpAndSettle();

    expect(find.text('Document enregistré'), findsOneWidget);
    await tester.tap(find.text('Voir le registre'));
    await tester.pumpAndSettle();

    expect(state.tabIndex, 2);
    expect(find.text('Registre des extractions'), findsOneWidget);
  });

  testWidgets('custom import placeholders must be reviewed before validation', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final document = const ExtractionService().fromFile(
      fileName: 'scan.pdf',
      language: AppLanguage.fr,
      pilotId: 'moreau',
    );
    final state = AppState(documents: [document]);

    await tester.pumpWidget(
      AppScope(
        state: state,
        child: MaterialApp(home: ValidationScreen(documentId: document.id)),
      ),
    );
    await tester.pumpAndSettle();

    final validate = find.text('Valider et enregistrer');
    await tester.ensureVisible(validate);
    await tester.tap(validate);
    await tester.pumpAndSettle();

    expect(state.documentById(document.id)!.status, DocumentStatus.pending);
    expect(
      find.text('Remplacez la valeur provisoire par une information vérifiée.'),
      findsNWidgets(3),
    );
  });

  testWidgets('imported image renders in validation without layout errors', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final imageBytes = base64Decode(
      'R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7',
    );
    final document = const ExtractionService().fromFile(
      fileName: 'photo.jpg',
      language: AppLanguage.fr,
      pilotId: 'moreau',
      imageBytes: imageBytes,
    );
    final state = AppState(documents: [document]);

    await tester.pumpWidget(
      AppScope(
        state: state,
        child: MaterialApp(home: ValidationScreen(documentId: document.id)),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(Image), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
