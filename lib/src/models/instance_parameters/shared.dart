library;

import 'dart:collection';
import 'dart:typed_data';

import 'package:antinote/src/helpers/cache.dart';
import 'package:antinote/src/helpers/colors.dart';
import 'package:antinote/src/helpers/datetime.dart';
import 'package:antinote/src/helpers/json.dart';
import 'package:antinote/src/helpers/visual_id.dart';
import 'package:antinote/src/models/grades/grade.dart';
import 'package:antinote/src/models/holiday.dart';
import 'package:antinote/src/models/language.dart';
import 'package:antinote/src/models/pause.dart';
import 'package:antinote/src/models/period.dart';
import 'package:antinote/src/models/week_frequency.dart';
import 'package:antinote/src/models/workspace/workspace.dart';
import 'package:version/version.dart';

import '../time_slot.dart';

part 'broad.dart';
part 'specific.dart';

final class SharedInstanceParameters {
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

  /// WARNING! The place where it is changes between root.versionPN ([String])
  /// and root.General.tableauVersion ([List<int>])
  final Version version;
  final String currentLanguageCode;
  final int currentLanguageId;
  final List<Language> languages;
  final bool publishMentions;
  final bool nonComplyingAccessibility;
  final Uri? accessibilityDeclarationUrl;
  final String establishmentName;
  final String loginEstablishmentName;
  final String? urlPath;
  final String? schoolYear;

  const SharedInstanceParameters({
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
    required this.currentLanguageCode,
    required this.currentLanguageId,
    required this.languages,
    required this.publishMentions,
    required this.nonComplyingAccessibility,
    required this.accessibilityDeclarationUrl,
    required this.establishmentName,
    required this.loginEstablishmentName,
    required this.urlPath,
    required this.schoolYear,
  });
}

extension AsSharedInstanceParameters on MapJsonNavigator {
  SharedInstanceParameters asSharedInstanceParameters({String? casToken}) {
    final mGen = mGetM('General') ?? this;
    return SharedInstanceParameters(
      casToken: casToken,
      isShownInDW: getB('estAfficheDansENT'),
      fontNames: getLM('listePolices').mapL((e) => e.get<String>('L')),
      withMember: getB('avecMembre'),
      forNewCaledonia: getB('pourNouvelleCaledonie'),
      loginImageType: get('genreImageConnexion'),
      loginImageUrl: Uri.tryParse(get<String>('urlImageConnexion')),
      cssProductLogo: get('logoProduitCss'),
      productLinkLabel: get('labelLienProduit'),
      privacyTermsUrl: Uri.parse(get('urlConfidentialite')),
      publicPageMentionsUrl: Uri.parse(
        go('mentionsPagesPubliques').get('lien'),
      ),
      version: Version.parse(mGen.get('versionPN')),
      currentLanguageCode: mGen.get('langue'),
      currentLanguageId: mGen.get('langID'),
      languages: mGen.getLM('listeLangues').mapL((e) => e.asLanguage()),
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
  @override
  CacheType? get cacheType => .UNIQUE;

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield "InstanceParameters".visualIdData();
  }

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
  final String currentLanguageCode;
  final int currentLanguageId;
  final List<Language> languages;
  final bool publishMentions;
  final bool nonComplyingAccessibility;
  final Uri? accessibilityDeclarationUrl;
  final String establishmentName;
  final String loginEstablishmentName;
  final String? schoolYear;

  const InstanceParameters({
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

  InstanceParameters.shared({required SharedInstanceParameters shared})
    : this(
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

extension AsInstanceParameters on MapJsonNavigator {
  InstanceParameters asInstanceParameters(
    Workspace tempWorkspace, {
    String? casToken,
  }) {
    final shared = asSharedInstanceParameters(casToken: casToken);

    return switch (has('General')) {
      true => asSpecificInstanceParameters(shared, tempWorkspace),
      false => asBroadInstanceParameters(shared),
    };
  }
}
