import 'package:flutter/widgets.dart';

import '../data/sample_data.dart';
import '../l10n/app_strings.dart';
import '../models/models.dart';

class AppState extends ChangeNotifier {
  factory AppState({
    required List<DocRecord> documents,
    List<PilotCompany> pilots = SampleData.pilots,
    AppLanguage language = AppLanguage.fr,
  }) {
    return AppState._(
      List<DocRecord>.of(documents),
      List<PilotCompany>.of(pilots),
      language,
    );
  }

  AppState._(this._documents, this._pilots, this._language);

  factory AppState.demo() {
    return AppState(documents: SampleData.seedDocuments());
  }

  final List<DocRecord> _documents;
  final List<PilotCompany> _pilots;
  AppLanguage _language;
  int _tabIndex = 0;

  AppStrings get text => AppStrings(_language);

  List<DocRecord> get documents => List<DocRecord>.unmodifiable(_documents);
  List<PilotCompany> get pilots => List<PilotCompany>.unmodifiable(_pilots);
  AppLanguage get language => _language;
  int get tabIndex => _tabIndex;

  DocRecord? documentById(String id) {
    for (final document in _documents) {
      if (document.id == id) return document;
    }
    return null;
  }

  PilotCompany? pilotById(String? id) {
    if (id == null) return null;
    for (final pilot in _pilots) {
      if (pilot.id == id) return pilot;
    }
    return null;
  }

  void setLanguage(AppLanguage language) {
    if (_language == language) return;
    _language = language;
    notifyListeners();
  }

  void toggleLanguage() {
    setLanguage(_language == AppLanguage.fr ? AppLanguage.ar : AppLanguage.fr);
  }

  void selectTab(int index) {
    if (_tabIndex == index) return;
    _tabIndex = index;
    notifyListeners();
  }

  void addDocument(DocRecord document) {
    _documents.insert(0, document);
    notifyListeners();
  }

  void validateDocument(String id, List<ExtractedField> fields) {
    final index = _documents.indexWhere((document) => document.id == id);
    if (index == -1) return;

    final document = _documents[index];
    final pilot = pilotById(document.pilotId);
    final saved = pilot?.minutesSavedPerDocument ?? 4.5;

    _documents[index] = document.copyWith(
      status: DocumentStatus.validated,
      fields: List<ExtractedField>.unmodifiable(fields),
      validatedAt: DateTime.now(),
      minutesSaved: saved,
    );
    notifyListeners();
  }

  void rejectDocument(String id) {
    final index = _documents.indexWhere((document) => document.id == id);
    if (index == -1) return;

    _documents[index] = _documents[index].copyWith(
      status: DocumentStatus.rejected,
      minutesSaved: 0,
    );
    notifyListeners();
  }
}

class AppScope extends InheritedNotifier<AppState> {
  const AppScope({super.key, required AppState state, required super.child})
    : super(notifier: state);

  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope introuvable dans le contexte.');
    return scope!.notifier!;
  }
}
