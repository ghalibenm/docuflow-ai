import 'package:flutter/material.dart';

import '../models/models.dart';
import '../screens/validation_screen.dart';
import 'document_detail_sheet.dart';

Future<void> pushValidation(BuildContext context, String documentId) {
  return Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => ValidationScreen(documentId: documentId),
    ),
  );
}

Future<void> openDocumentDetailOrVerify(
  BuildContext context,
  DocRecord document,
) async {
  final verify = await showDocumentDetailSheet(context, document);
  if (verify == true && context.mounted) {
    await pushValidation(context, document.id);
  }
}
