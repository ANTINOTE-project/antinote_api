import 'package:version/version.dart';

class ApiVocabulary {
  final String data;
  final String requestId;
  final String signature;
  final String orderNumber;
  final String sessionNumber;
  final String secureData;
  final String nonSecureData;
  final String session;

  final String fileUploadOrderNumber;
  final String fileUploadSessionNumber;
  final String fileUploadRequestId;
  final String fileUploadFileId;
  final String fileUploadMd5;

  const ApiVocabulary({
    required this.data,
    required this.requestId,
    required this.signature,
    required this.orderNumber,
    required this.sessionNumber,
    required this.secureData,
    required this.nonSecureData,
    required this.session,
    required this.fileUploadOrderNumber,
    required this.fileUploadSessionNumber,
    required this.fileUploadRequestId,
    required this.fileUploadFileId,
    required this.fileUploadMd5,
  });

  static ApiVocabulary forVersion(Version version) {
    if (version >= Version(2025, 1, 3)) {
      return _for2025_1_3;
    }
    if (version >= Version(2024, 3, 9)) {
      return _for2024_3_9;
    }

    return _older;
  }
}

const _for2025_1_3 = ApiVocabulary(
  data: 'data',
  requestId: 'id',
  signature: 'Signature',
  orderNumber: 'no',
  sessionNumber: 'ns',
  secureData: 'dataSec',
  nonSecureData: 'dataNonSec',
  session: 'session',
  fileUploadOrderNumber: 'u_no',
  fileUploadSessionNumber: 'u_ns',
  fileUploadRequestId: 'u_idR',
  fileUploadFileId: 'u_idF',
  fileUploadMd5: 'u_md5',
);

const _for2024_3_9 = ApiVocabulary(
  data: 'data',
  requestId: "nom",
  signature: 'Signature',
  orderNumber: "numeroOrdre",
  sessionNumber: "numeroSession",
  secureData: "donneesSec",
  nonSecureData: 'donneesNonSec',
  session: "session",
  fileUploadOrderNumber: "numeroOrdre",
  fileUploadSessionNumber: "numeroSession",
  fileUploadRequestId: "nomRequete",
  fileUploadFileId: "idFichier",
  fileUploadMd5: "md5",
);

const _older = ApiVocabulary(
  data: "donnees",
  requestId: "nom",
  signature: "_Signature_",
  orderNumber: "numeroOrdre",
  sessionNumber: "numeroSession",
  secureData: "donneesSec",
  nonSecureData: 'donneesNonSec',
  session: "session",
  fileUploadOrderNumber: "numeroOrdre",
  fileUploadSessionNumber: "numeroSession",
  fileUploadRequestId: "nomRequete",
  fileUploadFileId: "idFichier",
  fileUploadMd5: "md5",
);
