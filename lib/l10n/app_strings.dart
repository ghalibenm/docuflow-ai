import '../models/models.dart';

class AppStrings {
  const AppStrings(this.language);

  final AppLanguage language;

  bool get isAr => language.isArabic;

  String get appName => 'DocuFlow AI';
  String get appTagline =>
      isAr ? 'المستندات إلى بيانات' : 'Documents en données';
  String get brandSubtitle =>
      isAr ? 'استخراج المستندات' : 'Extraction documentaire';

  String get navDashboard => isAr ? 'لوحة التحكم' : 'Tableau de bord';
  String get navImport => isAr ? 'استيراد' : 'Importer';
  String get navRecords => isAr ? 'السجل' : 'Registre';
  String get navPilots => isAr ? 'شركات التجربة' : 'Pilotes';

  String get pilotMode =>
      isAr ? 'وضع التجربة · عرض توضيحي' : 'Mode pilote · démo';
  String get humanValidation =>
      isAr ? 'التحقق البشري مفعّل' : 'Validation humaine active';
  String get humanValidationShort => isAr ? 'تحقق بشري' : 'Validation humaine';
  String get demo => isAr ? 'عرض' : 'Démo';
  String get prototype => isAr ? 'نموذج أولي' : 'Prototype';
  String get simulated => isAr ? 'استخراج تجريبي' : 'Extraction simulée';
  String get localProcessing => isAr ? 'معالجة محلية' : 'Traitement local';

  String get actionImport => isAr ? 'استيراد مستند' : 'Importer un document';
  String get actionViewRecords => isAr ? 'عرض السجل' : 'Voir le registre';
  String get actionCancel => isAr ? 'إلغاء' : 'Annuler';
  String get actionClose => isAr ? 'إغلاق' : 'Fermer';
  String get actionSave => isAr ? 'حفظ' : 'Enregistrer';
  String get actionValidate =>
      isAr ? 'التحقق والحفظ' : 'Valider et enregistrer';
  String get actionReject => isAr ? 'رفض' : 'Rejeter';
  String get actionCopy => isAr ? 'نسخ' : 'Copier';
  String get actionExportCsv => isAr ? 'تصدير CSV' : 'Exporter CSV';
  String get actionReport => isAr ? 'إنشاء تقرير' : 'Générer un rapport';
  String get actionVerify =>
      isAr ? 'التحقق من البيانات' : 'Vérifier les données';
  String get actionViewAll => isAr ? 'عرض الكل' : 'Tout voir';
  String get actionImportAnother =>
      isAr ? 'استيراد مستند آخر' : 'Importer un autre document';
  String get actionViewRegister => isAr ? 'عرض السجل' : 'Voir le registre';

  String get homeEyebrow => isAr ? 'مساحة التجربة' : 'Espace pilote';
  String get homeGreeting =>
      isAr ? 'مرحباً، فريق التجربة' : 'Bonjour, équipe pilote';
  String get homeTitle => isAr
      ? 'مستنداتكم تتحول إلى بيانات.'
      : 'Vos documents deviennent des données.';
  String get homeSubtitle => isAr
      ? 'استوردوا مستنداً، تحققوا من الحقول المستخرجة، ثم صدّروا جدولاً نظيفاً. الذكاء الاصطناعي يجهّز وأنتم تعتمدون.'
      : "Importez un document, vérifiez les champs extraits, puis exportez un tableau propre. L'IA prépare, vous validez.";
  String get homeHeroBadge =>
      isAr ? 'نموذج أولي تشغيلي' : 'Prototype opérationnel';
  String get homeHeroTitle =>
      isAr ? 'مستند يدخل. جدول يخرج.' : 'Un document entre. Un tableau sort.';
  String get homeHeroText => isAr
      ? 'التقطوا أو استوردوا أي فاتورة أو استمارة. يستخرج DocuFlow الحقول المفيدة ويجهّز بياناتكم لـ Excel أو قاعدة البيانات.'
      : "Photographiez ou importez une facture, un formulaire ou un bon. DocuFlow extrait les champs utiles et prépare vos données pour Excel ou votre base.";
  String get homeStatDocuments => isAr ? 'مستندات معالجة' : 'Documents traités';
  String get homeStatTime => isAr ? 'الوقت الموفّر' : 'Temps économisé';
  String get homeStatAccuracy => isAr ? 'متوسط الثقة' : 'Confiance moyenne';
  String get homeStatPilots => isAr ? 'شركات التجربة' : 'Entreprises pilotes';
  String get homeThisWeek => isAr ? 'هذا الأسبوع' : 'cette semaine';
  String get homeOnValidatedDocs =>
      isAr ? 'على المستندات المعتمدة' : 'sur les documents validés';
  String get homeExtractedFields => isAr ? 'حقول مستخرجة' : 'champs extraits';
  String get homeOneProcess =>
      isAr ? 'عملية واحدة لكل شركة' : 'un processus par entreprise';
  String get homePendingTitle => isAr ? 'بانتظار التحقق' : 'À vérifier';
  String get homePendingEmptyTitle => isAr ? 'كل شيء محدّث' : 'Tout est à jour';
  String get homePendingEmptyText => isAr
      ? 'لا يوجد مستند بانتظار اعتمادكم.'
      : "Aucun document n'attend votre validation.";
  String get homeRecentTitle => isAr ? 'النشاط الأخير' : 'Activité récente';
  String get homeImpactTitle => isAr ? 'أثر التجربة' : 'Impact du pilote';
  String get homeDetails => isAr ? 'التفاصيل' : 'Détails';
  String get homeCapabilitiesTitle =>
      isAr ? 'مصمم للعمل الميداني' : 'Conçu pour le terrain';
  String get homeLanguagesTitle =>
      isAr ? 'الفرنسية + العربية' : 'Français + arabe';
  String get homeLanguagesText => isAr
      ? 'كشف اللغة واحترام اتجاه القراءة، حتى في المستندات المختلطة.'
      : 'Détection de la langue et sens de lecture respecté, même sur les documents mixtes.';
  String get homeValidationTitle =>
      isAr ? 'التحقق البشري' : 'Validation humaine';
  String get homeValidationText => isAr
      ? 'كل حقل قابل للتعديل. لا يُحفظ شيء دون موافقتكم.'
      : "Chaque champ reste modifiable. Rien n'est enregistré sans votre accord.";
  String get homeFooter => isAr
      ? 'نموذج أولي لاختبار تجاري · 3 شركات · بيانات توضيحية'
      : 'Prototype de test commercial · 3 entreprises pilotes · données de démonstration';
  String get homeWeekCount => isAr ? 'هذا الأسبوع' : 'cette semaine';

  String get importTitle => isAr ? 'استيراد مستند' : 'Importer un document';
  String get importSubtitle => isAr
      ? 'التقطوا أو استوردوا ملف PDF أو صورة أو مسحاً ضوئياً. يجهّز DocuFlow الحقول للتحقق.'
      : 'Photographiez ou importez un PDF, une image ou un scan. DocuFlow prépare les champs à vérifier.';
  String get importPilotLabel => isAr ? 'شركة التجربة' : 'Entreprise pilote';
  String get importPilotHint => isAr
      ? 'سيُربط المستند بهذه الشركة.'
      : 'Les documents seront rattachés à ce pilote.';
  String get importPhotoTitle =>
      isAr ? 'التقاط / مسح ضوئي' : 'Photographier / scanner';
  String get importPhotoText => isAr
      ? 'الكاميرا على الهاتف، والمعرض على الحاسوب.'
      : 'Caméra sur mobile, galerie sur ordinateur.';
  String get importFileTitle => isAr ? 'استيراد ملف' : 'Importer un fichier';
  String get importFileText => isAr
      ? 'PDF أو JPG أو PNG أو مسح · 10 ميغابايت كحد أقصى.'
      : 'PDF, JPG, PNG ou scan · 10 Mo max.';
  String get importSamplesTitle =>
      isAr ? 'جرّب مستنداً نموذجياً' : 'Tester avec un document exemple';
  String get importSamplesSubtitle => isAr
      ? 'أربع حالات تمثيلية للتجربة، بالفرنسية والعربية.'
      : 'Quatre cas représentatifs du pilote, en français et en arabe.';
  String get importSample => isAr ? 'نموذج' : 'Exemple';
  String get importProcessingTitle =>
      isAr ? 'جارٍ قراءة المستند…' : 'Lecture du document…';
  String get importStep1 =>
      isAr ? 'الحصول على المستند' : 'Acquisition du document';
  String get importStep2 =>
      isAr ? 'التعرف الضوئي وكشف اللغة' : 'OCR et détection de langue';
  String get importStep3 => isAr ? 'استخراج الحقول' : 'Extraction des champs';
  String get importStep4 => isAr ? 'فحص مستوى الثقة' : 'Contrôle de confiance';
  String get importProcessingHint => isAr
      ? 'في هذا النموذج لا تغادر أي بيانات الجهاز.'
      : "Aucune donnée ne quitte cet appareil dans le prototype.";
  String get importCameraUnavailable => isAr
      ? 'الكاميرا غير متاحة هنا. استخدم «استيراد ملف».'
      : 'Caméra indisponible ici. Utilisez « Importer un fichier ».';
  String get importPhotoError => isAr
      ? 'تعذر فتح الكاميرا أو المعرض.'
      : "Impossible d'ouvrir la caméra ou la galerie.";
  String get importFileTooLarge => isAr
      ? 'الملف كبير جداً (10 ميغابايت كحد أقصى).'
      : 'Fichier trop volumineux (10 Mo max).';
  String get importError => isAr
      ? 'تعذر استيراد المستند. حاول مرة أخرى.'
      : "Impossible d'importer le document. Réessayez.";
  String get importPrivacy => isAr
      ? 'استخراج تجريبي محلي · بدون إرسال إلى خادم.'
      : 'Extraction simulée locale · aucun envoi vers un serveur.';
  String get importHowTitle => isAr ? 'كيف يعمل؟' : 'Comment ça marche ?';
  String get importHow1Title => isAr ? 'استيراد' : 'Importer';
  String get importHow1Text => isAr ? 'صورة أو PDF' : 'Photo ou PDF';
  String get importHow2Title => isAr ? 'استخراج' : 'Extraire';
  String get importHow2Text => isAr ? 'حقول + ثقة' : 'Champs + confiance';
  String get importHow3Title => isAr ? 'تحقق' : 'Valider';
  String get importHow3Text => isAr ? 'أنتم تعتمدون' : 'Vous confirmez';
  String get importCamera => isAr ? 'الكاميرا' : 'Caméra';
  String get importGallery => isAr ? 'المعرض' : 'Galerie';
  String get importPickSource =>
      isAr ? 'اختر مصدر الصورة' : "Choisir la source de l'image";

  String get validationTitle =>
      isAr ? 'التحقق من البيانات المستخرجة' : 'Vérifier les données extraites';
  String get validationSubtitle => isAr
      ? 'الذكاء الاصطناعي يقترح وأنتم تعتمدون. كل حقل قابل للتعديل قبل الحفظ.'
      : "L'IA propose, vous confirmez. Chaque champ est modifiable avant enregistrement.";
  String get validationSource => isAr ? 'المستند المصدر' : 'Document source';
  String get validationLanguage => isAr ? 'اللغة المكتشفة' : 'Langue détectée';
  String get validationFields => isAr ? 'الحقول المستخرجة' : 'Champs extraits';
  String get validationConfidence => isAr ? 'الثقة' : 'Confiance';
  String get validationLowConfidence => isAr ? 'يتطلب التحقق' : 'À vérifier';
  String get validationEdited => isAr ? 'معدّل' : 'Modifié';
  String get validationCheckTitle =>
      isAr ? 'التحقق البشري مطلوب' : 'Contrôle humain requis';
  String get validationCheckText => isAr
      ? 'راجعوا القيم المميزة قبل الاعتماد. أنتم مسؤولون عن عملية الحفظ.'
      : "Vérifiez les valeurs signalées avant de valider. Vous restez responsable de l'enregistrement.";
  String get validationRequiredField => isAr ? 'حقل مطلوب' : 'Champ requis';
  String get validationEmptyField => isAr
      ? 'لا يمكن ترك هذا الحقل فارغاً.'
      : 'Ce champ ne peut pas être vide.';
  String get validationPlaceholderField => isAr
      ? 'استبدلوا القيمة المؤقتة بمعلومة تم التحقق منها.'
      : 'Remplacez la valeur provisoire par une information vérifiée.';
  String get validationIncomplete =>
      isAr ? 'أكملوا الحقول المطلوبة.' : 'Complétez les champs requis.';
  String get validationRejectTitle =>
      isAr ? 'رفض هذا المستند؟' : 'Rejeter ce document ?';
  String get validationRejectText => isAr
      ? 'سيُعلَّم المستند كمرفوض ولن يُحتسب ضمن الوقت الموفّر. يمكنكم استيراده مجدداً.'
      : "Le document sera marqué comme rejeté et ne comptera pas dans les gains mesurés. Vous pourrez l'importer à nouveau.";
  String get validationSuccessTitle =>
      isAr ? 'تم حفظ المستند' : 'Document enregistré';
  String get validationSuccessText => isAr
      ? 'تم التحقق من البيانات وإضافتها إلى السجل، وتم تحديث الوقت الموفّر.'
      : 'Les données ont été validées et ajoutées au registre. Le temps économisé a été mis à jour.';
  String get validationRejected =>
      isAr ? 'تم رفض المستند.' : 'Document rejeté.';
  String get validationFile => isAr ? 'الملف' : 'Fichier';
  String get validationImported => isAr ? 'تم الاستيراد' : 'Importé';
  String get validationFooter => isAr
      ? 'لا تتم مزامنة أي بيانات دون تحقق بشري.'
      : "Aucune donnée n'est synchronisée sans validation humaine.";
  String get validationPreview =>
      isAr ? 'معاينة المصدر' : 'Aperçu de la source';
  String get validationDocPhoto => isAr ? 'صورة المستند' : 'Photo du document';
  String get validationRequiredHint => isAr
      ? 'الحقول المطلوبة مميزة بعلامة *'
      : 'Les champs obligatoires sont marqués *';
  String get validationPhoto => isAr ? 'صورة المستند' : 'Photo du document';
  String get previewUnavailable => isAr
      ? 'المعاينة غير متاحة لهذا الملف.'
      : 'Aperçu indisponible pour ce fichier.';
  String get stampValidated => isAr ? 'معتمد' : 'VÉRIFIÉ';
  String get stampPending => isAr ? 'للتحقق' : 'À VÉRIFIER';
  String get stampRejected => isAr ? 'مرفوض' : 'REJETÉ';

  String get recordsTitle =>
      isAr ? 'سجل الاستخراجات' : 'Registre des extractions';
  String get recordsSubtitle => isAr
      ? 'كل مستندات التجربة، مع بيانات معتمدة جاهزة لـ Excel أو تقرير أو قاعدة البيانات.'
      : 'Tous les documents du pilote, avec les données validées prêtes pour Excel, un rapport ou votre base.';
  String get recordsSearchHint => isAr
      ? 'ابحث عن مستند أو مورد…'
      : 'Rechercher un document, un fournisseur…';
  String get filterAll => isAr ? 'الكل' : 'Tous';
  String get filterPending => isAr ? 'بانتظار التحقق' : 'À vérifier';
  String get filterValidated => isAr ? 'معتمدة' : 'Validés';
  String get filterRejected => isAr ? 'مرفوضة' : 'Rejetés';
  String get recordsStatDocuments => isAr ? 'مستندات' : 'documents';
  String get recordsStatValidated => isAr ? 'معتمدة' : 'validés';
  String get recordsStatFields => isAr ? 'حقول منظمة' : 'champs structurés';
  String get recordsStatSaved => isAr ? 'موفّرة' : 'économisées';
  String get recordsEmptyTitle => isAr ? 'لا توجد نتائج' : 'Aucun résultat';
  String get recordsEmptyText => isAr
      ? 'غيّروا البحث أو استوردوا مستنداً جديداً.'
      : 'Modifiez votre recherche ou importez un nouveau document.';
  String get colDocument => isAr ? 'المستند' : 'Document';
  String get colType => isAr ? 'النوع' : 'Type';
  String get colParty => isAr ? 'الطرف' : 'Tiers';
  String get colDate => isAr ? 'التاريخ' : 'Date';
  String get colReference => isAr ? 'المبلغ / المرجع' : 'Montant / Réf.';
  String get colConfidence => isAr ? 'الثقة' : 'Confiance';
  String get colStatus => isAr ? 'الحالة' : 'Statut';
  String get recordsEmptyValue => '—';
  String get exportEmpty =>
      isAr ? 'لا يوجد مستند للتصدير.' : 'Aucun document à exporter.';
  String exportSuccess(int count) => isAr
      ? 'تم نسخ CSV إلى الحافظة ($count سطراً).'
      : 'CSV copié dans le presse-papiers ($count lignes).';
  String get reportTitle => isAr ? 'تقرير التجربة' : 'Rapport de pilote';
  String get reportSubtitle => isAr
      ? 'ملخص للمستندات المعالجة والوقت الموفّر على المستندات المعتمدة.'
      : 'Synthèse des documents traités et des gains mesurés sur les documents validés.';
  String get reportNoData => isAr
      ? 'اعتمدوا مستنداً واحداً على الأقل لإنشاء تقرير.'
      : 'Validez au moins un document pour générer un rapport.';
  String get reportCopied => isAr
      ? 'تم نسخ التقرير إلى الحافظة.'
      : 'Rapport copié dans le presse-papiers.';
  String get reportSinceLaunch => isAr ? 'منذ الإطلاق' : 'Depuis le lancement';
  String get reportByPilot =>
      isAr ? 'حسب شركة التجربة' : 'Par entreprise pilote';
  String get reportByType => isAr ? 'حسب نوع المستند' : 'Par type de document';
  String get reportGenerated => isAr ? 'أُنشئ في' : 'Généré le';
  String get reportAverageTime => isAr
      ? 'متوسط الوقت الموفّر لكل مستند'
      : 'Temps moyen économisé par document';
  String get reportHoursSaved => isAr ? 'الوقت الموفّر' : 'Temps économisé';
  String get reportCsv => isAr ? 'CSV' : 'CSV';
  String get recordsShowing => isAr ? 'معروض' : 'affichés';
  String get recordsSortRecent => isAr ? 'الأحدث أولاً' : 'Plus récents';
  String get csvReference => isAr ? 'المرجع' : 'Référence';
  String get csvAmount => isAr ? 'المبلغ' : 'Montant';
  String get csvTimeSaved =>
      isAr ? 'الوقت الموفّر (د)' : 'Temps économisé (min)';
  String get csvFields => isAr ? 'الحقول المستخرجة' : 'Champs extraits';
  String get docsLabel => isAr ? 'المستندات' : 'Documents';
  String get validatedLabel => isAr ? 'المعتمدة' : 'Validés';
  String get pendingLabel => isAr ? 'بانتظار التحقق' : 'En attente';
  String get fieldsStructured => isAr ? 'حقول منظمة' : 'Champs structurés';
  String get accuracyLabel => isAr ? 'متوسط الثقة' : 'Confiance moyenne';

  String get pilotsTitle => isAr ? 'شركات التجربة' : 'Entreprises pilotes';
  String get pilotsSubtitle => isAr
      ? 'عملية واحدة مؤتمتة لكل شركة، ووقت موفّر مقاس.'
      : 'Un processus automatisé par entreprise, un temps économisé mesuré.';
  String get pilotActive => isAr ? 'تجربة نشطة' : 'Pilote actif';
  String get pilotMeasuring => isAr ? 'القياس جارٍ' : 'Mesure en cours';
  String get pilotTarget => isAr ? 'الهدف' : 'Objectif pilote';
  String get pilotDocuments => isAr ? 'مستندات معتمدة' : 'documents validés';
  String get pilotBefore => isAr ? 'قبل' : 'Avant';
  String get pilotAfter => isAr ? 'بعد' : 'Après';
  String get pilotPerDocument => isAr ? '/ مستند' : '/ document';
  String get pilotSaved => isAr ? 'الوقت الموفّر' : 'Temps gagné';
  String get pilotProcess => isAr ? 'العملية المؤتمتة' : 'Processus automatisé';
  String get pilotRoi =>
      isAr ? 'تقليص وقت الإدخال' : 'Réduction du temps de saisie';
  String get pilotProtocolTitle =>
      isAr ? 'بروتوكول الاختبار التجاري' : 'Protocole de test commercial';
  String get pilotStep1Title =>
      isAr ? '1. قياس الوضع الحالي' : '1. Mesurer la base';
  String get pilotStep1Text => isAr
      ? 'توقيت الإدخال اليدوي على عملية واحدة.'
      : 'Chronométrer la saisie manuelle sur un processus unique.';
  String get pilotStep2Title => isAr ? '2. الأتمتة' : '2. Automatiser';
  String get pilotStep2Text => isAr
      ? 'استيراد المستندات الحقيقية والتحقق من الحقول.'
      : 'Importer les documents réels et valider les champs extraits.';
  String get pilotStep3Title => isAr ? '3. المقارنة' : '3. Comparer';
  String get pilotStep3Text => isAr
      ? 'قياس الوقت بعد 15 مستنداً وحساب الفرق.'
      : 'Mesurer le temps après 15 documents et calculer le gain.';
  String get pilotSummaryTitle => isAr ? 'ملخص التجربة' : 'Synthèse du pilote';
  String get pilotTestNote => isAr
      ? 'هدف الاختبار: أتمتة عملية واحدة لكل شركة وقياس الوقت الموفّر فعلياً على المستندات المعتمدة.'
      : 'Objectif du test : automatiser un seul processus par entreprise et mesurer le temps réellement économisé sur les documents validés.';
  String get pilotNoDocs => isAr
      ? 'لا يوجد مستند معتمد لهذه الشركة بعد.'
      : 'Aucun document validé pour ce pilote.';
  String get pilotStarted => isAr ? 'بدأت منذ' : 'Démarré il y a';
  String pilotSince(int days) => isAr ? '$days يوماً' : '$days jours';
  String get pilotUnitsCompanies => isAr ? 'شركات' : 'entreprises';
  String get pilotUnitsProcess => isAr ? 'عمليات' : 'processus';
  String get pilotDocumentsShort => isAr ? 'مستندات' : 'documents';
  String get pilotTimeSavedShort => isAr ? 'موفّرة' : 'économisées';
  String get pilotTargetReached => isAr ? 'تم بلوغ الهدف' : 'Objectif atteint';

  String get detailExtractedFields =>
      isAr ? 'الحقول المستخرجة' : 'Champs extraits';
  String get detailSource => isAr ? 'المصدر' : 'Source';
  String get detailLanguage => isAr ? 'اللغة' : 'Langue';
  String get detailStatus => isAr ? 'الحالة' : 'Statut';
  String get detailTimeSaved => isAr ? 'الوقت الموفّر' : 'Temps économisé';
  String get detailImportedOn => isAr ? 'تاريخ الاستيراد' : 'Importé le';
  String get detailValidatedOn => isAr ? 'تاريخ الاعتماد' : 'Validé le';
  String get detailPilot => isAr ? 'شركة التجربة' : 'Entreprise pilote';
  String get detailNoPilot => isAr ? 'غير مرتبط' : 'Non rattaché';
  String get detailConfidence => isAr ? 'متوسط الثقة' : 'Confiance moyenne';
  String get detailPendingHint => isAr
      ? 'هذا المستند بانتظار تحقق بشري.'
      : 'Ce document attend une validation humaine.';
  String get detailRejectedHint => isAr
      ? 'تم رفض هذا المستند ولا يُحتسب ضمن الوقت الموفّر.'
      : "Ce document a été rejeté et n'est pas compté dans les gains.";
  String get detailId => isAr ? 'المعرّف' : 'Identifiant';
  String get detailFieldsCount => isAr ? 'عدد الحقول' : 'Nombre de champs';

  String get languageFrench => isAr ? 'الفرنسية' : 'Français';
  String get languageArabic => isAr ? 'العربية' : 'Arabe';

  String get statusPending => isAr ? 'بانتظار التحقق' : 'À vérifier';
  String get statusValidated => isAr ? 'معتمد' : 'Validé';
  String get statusRejected => isAr ? 'مرفوض' : 'Rejeté';

  String get justNow => isAr ? 'الآن' : "À l'instant";
  String get today => isAr ? 'اليوم' : "Aujourd'hui";
  String get yesterday => isAr ? 'أمس' : 'Hier';

  String get errorGeneric => isAr
      ? 'حدث خطأ. حاولوا مرة أخرى.'
      : 'Une erreur est survenue. Réessayez.';
  String get copiedToClipboard =>
      isAr ? 'تم النسخ إلى الحافظة.' : 'Copié dans le presse-papiers.';
  String get clipboardCopyError => isAr
      ? 'تعذّر النسخ إلى الحافظة.'
      : 'Impossible de copier dans le presse-papiers.';
  String get copiedShort => isAr ? 'تم النسخ' : 'Copié';
  String get documentFallback => isAr ? 'مستند' : 'Document';

  String kindLabel(DocumentKind kind) {
    switch (kind) {
      case DocumentKind.invoice:
        return isAr ? 'فاتورة مورد' : 'Facture fournisseur';
      case DocumentKind.supplierForm:
        return isAr ? 'استمارة مورد' : 'Formulaire fournisseur';
      case DocumentKind.deliveryNote:
        return isAr ? 'سند تسليم' : 'Bon de livraison';
      case DocumentKind.custom:
        return isAr ? 'مستند مستورد' : 'Document importé';
    }
  }

  String statusLabel(DocumentStatus status) {
    switch (status) {
      case DocumentStatus.pending:
        return statusPending;
      case DocumentStatus.validated:
        return statusValidated;
      case DocumentStatus.rejected:
        return statusRejected;
    }
  }

  String languageLabel(AppLanguage value) =>
      value.isArabic ? languageArabic : languageFrench;

  String fieldsDetected(int count) =>
      isAr ? '$count حقول مكتشفة' : '$count champs détectés';

  String documentTitle(DocRecord document) {
    if (document.kind == DocumentKind.custom) {
      return document.fileName ?? kindLabel(document.kind);
    }
    final party = document.party;
    if (party == null) return kindLabel(document.kind);
    return '${kindLabel(document.kind)} · $party';
  }

  String formatDate(DateTime date, {bool short = false}) {
    const monthsFr = [
      'janvier',
      'février',
      'mars',
      'avril',
      'mai',
      'juin',
      'juillet',
      'août',
      'septembre',
      'octobre',
      'novembre',
      'décembre',
    ];
    const monthsFrShort = [
      'janv.',
      'févr.',
      'mars',
      'avr.',
      'mai',
      'juin',
      'juil.',
      'août',
      'sept.',
      'oct.',
      'nov.',
      'déc.',
    ];
    const monthsAr = [
      'يناير',
      'فبراير',
      'مارس',
      'أبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر',
    ];
    final month = isAr
        ? monthsAr[date.month - 1]
        : (short ? monthsFrShort : monthsFr)[date.month - 1];
    return '${date.day} $month ${date.year}';
  }

  String relativeTime(DateTime date, {DateTime? now}) {
    final reference = now ?? DateTime.now();
    final difference = reference.difference(date);
    if (difference.inMinutes < 1) return justNow;
    if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return isAr ? 'منذ $minutes دقيقة' : 'Il y a $minutes min';
    }
    if (difference.inHours < 24) {
      final hours = difference.inHours;
      return isAr ? 'منذ $hours ساعة' : 'Il y a $hours h';
    }
    if (difference.inDays < 7) {
      final days = difference.inDays;
      return isAr ? 'منذ $days يوم' : 'Il y a $days j';
    }
    return formatDate(date, short: true);
  }

  String formatMinutes(double value) {
    final total = value.round();
    if (total < 60) {
      return isAr ? '$total دقيقة' : '$total min';
    }
    final hours = total ~/ 60;
    final minutes = total % 60;
    if (minutes == 0) {
      return isAr ? '$hours س' : '$hours h';
    }
    return isAr
        ? '$hours س $minutes د'
        : '${hours}h${minutes.toString().padLeft(2, '0')}';
  }

  String formatPreciseMinutes(double value) {
    final formatted = value
        .toStringAsFixed(value == value.roundToDouble() ? 0 : 1)
        .replaceAll('.', ',');
    return isAr ? '$formatted د' : '$formatted min';
  }

  String formatDecimal(double value, {int decimals = 1}) =>
      value.toStringAsFixed(decimals).replaceAll('.', ',');

  String formatPercent(double ratio) =>
      '${(ratio * 100).toStringAsFixed(1).replaceAll('.', ',')} %';

  String successSaved(String time) => isAr
      ? '+$time موفّرة على هذا المستند'
      : '+$time économisées sur ce document';
}
