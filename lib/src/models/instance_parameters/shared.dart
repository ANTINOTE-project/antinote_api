library;

import 'dart:collection';
import 'dart:typed_data';

import 'package:antinote_api/antinote_api.dart';
import 'package:antinote_api/src/models/language.dart';
import 'package:intl/intl.dart';
import 'package:version/version.dart';

part 'broad.dart';
part 'specific.dart';

final class const SharedInstanceParameters({
  required final String? casToken,
  required final bool isShownInDW,
  required final List<String> fontNames,
  required final bool withMember,
  required final bool forNewCaledonia,
  required final int loginImageType,
  required final Uri? loginImageUrl,
  required final String cssProductLogo,
  required final String productLinkLabel,
  required final Uri privacyTermsUrl,
  required final Uri publicPageMentionsUrl,

  /// WARNING! The place where it is changes between root.versionPN ([String])
  /// and root.General.tableauVersion ([List<int>])
  required final Version version,
  required final String rawVersion,
  required final String currentLanguageCode,
  required final int currentLanguageId,
  required final List<Language> languages,
  required final bool publishMentions,
  required final bool nonComplyingAccessibility,
  required final Uri? accessibilityDeclarationUrl,
  required final String establishmentName,
  required final String loginEstablishmentName,
  required final String? urlPath,
  required final String? schoolYear,
}) {
  factory decode(Map<String, dynamic> nav, {String? casToken}) {
    final mGen = nav.mGetM('General') ?? nav;
    return .new(
      casToken: casToken,
      isShownInDW: nav.getB('estAfficheDansENT'),
      fontNames: nav.getLM('listePolices').mapL((e) => e.get<String>('L')),
      withMember: nav.getB('avecMembre'),
      forNewCaledonia: nav.getB('pourNouvelleCaledonie'),
      loginImageType: nav.get('genreImageConnexion'),
      loginImageUrl: Uri.tryParse(nav.get<String>('urlImageConnexion')),
      cssProductLogo: nav.get('logoProduitCss'),
      productLinkLabel: nav.get('labelLienProduit'),
      privacyTermsUrl: Uri.parse(nav.get('urlConfidentialite')),
      publicPageMentionsUrl: Uri.parse(
        nav.go('mentionsPagesPubliques').get('lien'),
      ),
      version: Version.parse(mGen.get('versionPN')),
      rawVersion:
          mGen.mGetL<int>('tableauVersion')?.join('.') ?? mGen.get('versionPN'),
      currentLanguageCode: mGen.get('langue'),
      currentLanguageId: mGen.get('langID'),
      languages: mGen.getLM('listeLangues').mapL((e) => .decode(e)),
      publishMentions: mGen.getB('publierMentions'),
      nonComplyingAccessibility: mGen.getB('accessibiliteNonConforme'),
      accessibilityDeclarationUrl: mGen.has('urlDeclarationAccessibilite')
          ? Uri.tryParse(mGen.get('urlDeclarationAccessibilite'))
          : null,
      establishmentName: mGen.get<String>('NomEtablissement').trim(),
      loginEstablishmentName: mGen
          .get<String>('NomEtablissementConnexion')
          .trim(),
      urlPath: mGen.get('urlLogo'),
      schoolYear: mGen.eGet(['AnneeScolaire', 'anneeScolaire']),
    );
  }
}

sealed class InstanceParameters with VisualIdMixin {
  factory decode(
    Map<String, dynamic> nav,
    Workspace tempWorkspace, {
    String? casToken,
  }) {
    final shared = SharedInstanceParameters.decode(nav, casToken: casToken);
    return switch (nav.has('General')) {
      true => SpecificInstanceParameters.decode(nav, shared, tempWorkspace),
      false => BroadInstanceParameters.decode(nav, shared),
    };
  }

  @override
  CacheType? get cacheType => .UNIQUE;

  @override
  SerialObjectId? get overrideSerialId => .instanceParameters;

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {}

  final String? casToken;
  final bool isShownInDW;
  final List<String> fontNames;
  final bool withMember;
  final bool forNewCaledonia;
  final int loginImageType;
  final Uri? loginImageUrl;
  final String cssProductLogo;
  final String productLinkLabel;
  final Uri privacyTermsUrl;
  final Uri publicPageMentionsUrl;
  final Version version;
  final List<int> rawVersion;
  final String currentLanguageCode;
  final int currentLanguageId;
  final List<Language> languages;
  final bool publishMentions;
  final bool nonComplyingAccessibility;
  final Uri? accessibilityDeclarationUrl;
  final String establishmentName;
  final String loginEstablishmentName;
  final String? schoolYear;

  const InstanceParameters.full({
    required this.casToken,
    required this.isShownInDW,
    required this.fontNames,
    required this.withMember,
    required this.forNewCaledonia,
    required this.loginImageType,
    required this.loginImageUrl,
    required this.cssProductLogo,
    required this.productLinkLabel,
    required this.privacyTermsUrl,
    required this.publicPageMentionsUrl,
    required this.version,
    required this.rawVersion,
    required this.currentLanguageCode,
    required this.currentLanguageId,
    required this.languages,
    required this.publishMentions,
    required this.nonComplyingAccessibility,
    required this.accessibilityDeclarationUrl,
    required this.establishmentName,
    required this.loginEstablishmentName,
    required this.schoolYear,
  });

  InstanceParameters({required SharedInstanceParameters shared})
    : this.full(
        casToken: shared.casToken,
        isShownInDW: shared.isShownInDW,
        fontNames: shared.fontNames,
        withMember: shared.withMember,
        forNewCaledonia: shared.forNewCaledonia,
        loginImageType: shared.loginImageType,
        loginImageUrl: shared.loginImageUrl,
        cssProductLogo: shared.cssProductLogo,
        productLinkLabel: shared.productLinkLabel,
        privacyTermsUrl: shared.privacyTermsUrl,
        publicPageMentionsUrl: shared.publicPageMentionsUrl,
        version: shared.version,
        rawVersion: shared.rawVersion
            .split('.')
            .map((e) => int.parse(e))
            .toList(growable: false),
        currentLanguageCode: shared.currentLanguageCode,
        currentLanguageId: shared.currentLanguageId,
        languages: shared.languages,
        publishMentions: shared.publishMentions,
        nonComplyingAccessibility: shared.nonComplyingAccessibility,
        accessibilityDeclarationUrl: shared.accessibilityDeclarationUrl,
        establishmentName: shared.establishmentName,
        loginEstablishmentName: shared.loginEstablishmentName,
        schoolYear: shared.schoolYear,
      );
}
