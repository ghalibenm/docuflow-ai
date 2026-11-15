import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/app_theme.dart';
import 'models/models.dart';
import 'screens/app_shell.dart';
import 'state/app_state.dart';

class DocuFlowApp extends StatefulWidget {
  const DocuFlowApp({super.key, required this.state});

  final AppState state;

  @override
  State<DocuFlowApp> createState() => _DocuFlowAppState();
}

class _DocuFlowAppState extends State<DocuFlowApp> {
  @override
  void initState() {
    super.initState();
    widget.state.addListener(_onStateChanged);
  }

  @override
  void didUpdateWidget(DocuFlowApp oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state != widget.state) {
      oldWidget.state.removeListener(_onStateChanged);
      widget.state.addListener(_onStateChanged);
    }
  }

  @override
  void dispose() {
    widget.state.removeListener(_onStateChanged);
    super.dispose();
  }

  void _onStateChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final language = widget.state.language;
    return AppScope(
      state: widget.state,
      child: MaterialApp(
        title: 'DocuFlow AI',
        debugShowCheckedModeBanner: false,
        theme: buildAppTheme(),
        locale: language.locale,
        supportedLocales: const [Locale('fr'), Locale('ar')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: const AppShell(),
      ),
    );
  }
}
