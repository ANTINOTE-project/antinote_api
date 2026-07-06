// This is a generated file - do not edit.
//
// Generated from protos/antinote/session.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports
// ignore_for_file: unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use cacheTypeDescriptor instead')
const CacheType$json = {
  '1': 'CacheType',
  '2': [
    {'1': 'UNIQUE', '2': 0},
    {'1': 'PERIOD', '2': 1},
    {'1': 'DISCUSSION_MESSAGE', '2': 2},
    {'1': 'FILE_ATTACHMENT', '2': 3},
    {'1': 'LINK_ATTACHMENT', '2': 4},
    {'1': 'SUBMITTED_FILE_ATTACHMENT', '2': 5},
    {'1': 'DISCUSSION_NODE', '2': 6},
    {'1': 'SERVICE', '2': 7},
    {'1': 'EXAM', '2': 8},
    {'1': 'THEME', '2': 9},
    {'1': 'MEAL', '2': 10},
    {'1': 'FOOD', '2': 11},
    {'1': 'FOOD_LABEL', '2': 12},
    {'1': 'FOOD_ALLERGEN', '2': 13},
    {'1': 'NEWS', '2': 14},
    {'1': 'PERSON', '2': 15},
    {'1': 'NEWS_CATEGORY', '2': 16},
    {'1': 'NEWS_QUESTION', '2': 17},
    {'1': 'NEWS_QUESTION_PICK', '2': 18},
    {'1': 'NEWS_QUESTION_ANSWER', '2': 19},
    {'1': 'NOTEBOOK_ENTRY', '2': 20},
    {'1': 'NOTEBOOK_ENTRY_GROUP', '2': 21},
    {'1': 'NOTEBOOK_CONTENT', '2': 22},
    {'1': 'NOTEBOOK_CONTENT_CATEGORY', '2': 23},
    {'1': 'HOMEWORK', '2': 24},
    {'1': 'HANDED_ASSIGNMENT', '2': 25},
    {'1': 'NOTEBOOK_RESOURCE_ENTRY', '2': 26},
    {'1': 'CLAZZ', '2': 27},
    {'1': 'SUBJECT', '2': 28},
    {'1': 'NOTEBOOK_ENTRY_PREVIEW', '2': 29},
    {'1': 'NOTEBOOK_RESOURCE', '2': 30},
    {'1': 'PEDAGOGICAL_FORUM', '2': 31},
    {'1': 'MCQ_EXECUTION', '2': 32},
    {'1': 'MCQ', '2': 33},
    {'1': 'EXAM_PREVIEW', '2': 34},
    {'1': 'ROOM', '2': 35},
    {'1': 'SCHOOL_LIFE_EVENT', '2': 36},
    {'1': 'SCHOOL_LIFE_EVENT_REASON', '2': 37},
    {'1': 'SCHOOL_LIFE_EVENT_SECTION', '2': 38},
    {'1': 'USER_RESOURCE', '2': 39},
    {'1': 'HOLIDAY', '2': 40},
    {'1': 'CLASSROOM', '2': 41},
    {'1': 'CLASS_GROUP', '2': 42},
    {'1': 'STUDENT_CLASS', '2': 43},
    {'1': 'CLASS_CONTENT', '2': 44},
  ],
};

/// Descriptor for `CacheType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List cacheTypeDescriptor = $convert.base64Decode(
    'CglDYWNoZVR5cGUSCgoGVU5JUVVFEAASCgoGUEVSSU9EEAESFgoSRElTQ1VTU0lPTl9NRVNTQU'
    'dFEAISEwoPRklMRV9BVFRBQ0hNRU5UEAMSEwoPTElOS19BVFRBQ0hNRU5UEAQSHQoZU1VCTUlU'
    'VEVEX0ZJTEVfQVRUQUNITUVOVBAFEhMKD0RJU0NVU1NJT05fTk9ERRAGEgsKB1NFUlZJQ0UQBx'
    'IICgRFWEFNEAgSCQoFVEhFTUUQCRIICgRNRUFMEAoSCAoERk9PRBALEg4KCkZPT0RfTEFCRUwQ'
    'DBIRCg1GT09EX0FMTEVSR0VOEA0SCAoETkVXUxAOEgoKBlBFUlNPThAPEhEKDU5FV1NfQ0FURU'
    'dPUlkQEBIRCg1ORVdTX1FVRVNUSU9OEBESFgoSTkVXU19RVUVTVElPTl9QSUNLEBISGAoUTkVX'
    'U19RVUVTVElPTl9BTlNXRVIQExISCg5OT1RFQk9PS19FTlRSWRAUEhgKFE5PVEVCT09LX0VOVF'
    'JZX0dST1VQEBUSFAoQTk9URUJPT0tfQ09OVEVOVBAWEh0KGU5PVEVCT09LX0NPTlRFTlRfQ0FU'
    'RUdPUlkQFxIMCghIT01FV09SSxAYEhUKEUhBTkRFRF9BU1NJR05NRU5UEBkSGwoXTk9URUJPT0'
    'tfUkVTT1VSQ0VfRU5UUlkQGhIJCgVDTEFaWhAbEgsKB1NVQkpFQ1QQHBIaChZOT1RFQk9PS19F'
    'TlRSWV9QUkVWSUVXEB0SFQoRTk9URUJPT0tfUkVTT1VSQ0UQHhIVChFQRURBR09HSUNBTF9GT1'
    'JVTRAfEhEKDU1DUV9FWEVDVVRJT04QIBIHCgNNQ1EQIRIQCgxFWEFNX1BSRVZJRVcQIhIICgRS'
    'T09NECMSFQoRU0NIT09MX0xJRkVfRVZFTlQQJBIcChhTQ0hPT0xfTElGRV9FVkVOVF9SRUFTT0'
    '4QJRIdChlTQ0hPT0xfTElGRV9FVkVOVF9TRUNUSU9OECYSEQoNVVNFUl9SRVNPVVJDRRAnEgsK'
    'B0hPTElEQVkQKBINCglDTEFTU1JPT00QKRIPCgtDTEFTU19HUk9VUBAqEhEKDVNUVURFTlRfQ0'
    'xBU1MQKxIRCg1DTEFTU19DT05URU5UECw=');

@$core.Deprecated('Use serializedCryptoDescriptor instead')
const SerializedCrypto$json = {
  '1': 'SerializedCrypto',
  '2': [
    {'1': 'iv', '3': 1, '4': 1, '5': 12, '10': 'iv'},
    {'1': 'key', '3': 2, '4': 1, '5': 12, '10': 'key'},
    {
      '1': 'rsa_modulus',
      '3': 3,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'rsaModulus',
      '17': true
    },
    {
      '1': 'rsa_exponent',
      '3': 4,
      '4': 1,
      '5': 9,
      '9': 1,
      '10': 'rsaExponent',
      '17': true
    },
  ],
  '8': [
    {'1': '_rsa_modulus'},
    {'1': '_rsa_exponent'},
  ],
};

/// Descriptor for `SerializedCrypto`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List serializedCryptoDescriptor = $convert.base64Decode(
    'ChBTZXJpYWxpemVkQ3J5cHRvEg4KAml2GAEgASgMUgJpdhIQCgNrZXkYAiABKAxSA2tleRIkCg'
    'tyc2FfbW9kdWx1cxgDIAEoCUgAUgpyc2FNb2R1bHVziAEBEiYKDHJzYV9leHBvbmVudBgEIAEo'
    'CUgBUgtyc2FFeHBvbmVudIgBAUIOCgxfcnNhX21vZHVsdXNCDwoNX3JzYV9leHBvbmVudA==');

@$core.Deprecated('Use serverSignatureDescriptor instead')
const ServerSignature$json = {
  '1': 'ServerSignature',
  '2': [
    {'1': 'exclusiveMode', '3': 1, '4': 1, '5': 8, '10': 'exclusiveMode'},
    {
      '1': 'tab_notification_counts',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.antinote.ServerSignature.TabNotificationCountsEntry',
      '10': 'tabNotificationCounts'
    },
    {
      '1': 'visible_notifications_count',
      '3': 3,
      '4': 1,
      '5': 13,
      '10': 'visibleNotificationsCount'
    },
    {
      '1': 'connection_status',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.antinote.ServerSignature.ConnectionStatus',
      '10': 'connectionStatus'
    },
  ],
  '3': [ServerSignature_TabNotificationCountsEntry$json],
  '4': [ServerSignature_ConnectionStatus$json],
};

@$core.Deprecated('Use serverSignatureDescriptor instead')
const ServerSignature_TabNotificationCountsEntry$json = {
  '1': 'TabNotificationCountsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 13, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 13, '10': 'value'},
  ],
  '7': {'7': true},
};

@$core.Deprecated('Use serverSignatureDescriptor instead')
const ServerSignature_ConnectionStatus$json = {
  '1': 'ConnectionStatus',
  '2': [
    {'1': 'AVAILABLE', '2': 0},
    {'1': 'IN_CLASS', '2': 1},
    {'1': 'DO_NOT_DISTURB', '2': 2},
    {'1': 'DISCONNECTED', '2': 3},
  ],
};

/// Descriptor for `ServerSignature`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List serverSignatureDescriptor = $convert.base64Decode(
    'Cg9TZXJ2ZXJTaWduYXR1cmUSJAoNZXhjbHVzaXZlTW9kZRgBIAEoCFINZXhjbHVzaXZlTW9kZR'
    'JsChd0YWJfbm90aWZpY2F0aW9uX2NvdW50cxgCIAMoCzI0LmFudGlub3RlLlNlcnZlclNpZ25h'
    'dHVyZS5UYWJOb3RpZmljYXRpb25Db3VudHNFbnRyeVIVdGFiTm90aWZpY2F0aW9uQ291bnRzEj'
    '4KG3Zpc2libGVfbm90aWZpY2F0aW9uc19jb3VudBgDIAEoDVIZdmlzaWJsZU5vdGlmaWNhdGlv'
    'bnNDb3VudBJXChFjb25uZWN0aW9uX3N0YXR1cxgEIAEoDjIqLmFudGlub3RlLlNlcnZlclNpZ2'
    '5hdHVyZS5Db25uZWN0aW9uU3RhdHVzUhBjb25uZWN0aW9uU3RhdHVzGkgKGlRhYk5vdGlmaWNh'
    'dGlvbkNvdW50c0VudHJ5EhAKA2tleRgBIAEoDVIDa2V5EhQKBXZhbHVlGAIgASgNUgV2YWx1ZT'
    'oCOAEiVQoQQ29ubmVjdGlvblN0YXR1cxINCglBVkFJTEFCTEUQABIMCghJTl9DTEFTUxABEhIK'
    'DkRPX05PVF9ESVNUVVJCEAISEAoMRElTQ09OTkVDVEVEEAM=');

@$core.Deprecated('Use clientSignatureDescriptor instead')
const ClientSignature$json = {
  '1': 'ClientSignature',
  '2': [
    {'1': 'tab', '3': 1, '4': 1, '5': 17, '10': 'tab'},
    {
      '1': 'member',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.antinote.ClientSignature.Member',
      '9': 0,
      '10': 'member',
      '17': true
    },
  ],
  '3': [ClientSignature_Member$json],
  '8': [
    {'1': '_member'},
  ],
};

@$core.Deprecated('Use clientSignatureDescriptor instead')
const ClientSignature_Member$json = {
  '1': 'Member',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'type', '3': 2, '4': 1, '5': 13, '10': 'type'},
  ],
};

/// Descriptor for `ClientSignature`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clientSignatureDescriptor = $convert.base64Decode(
    'Cg9DbGllbnRTaWduYXR1cmUSEAoDdGFiGAEgASgRUgN0YWISPQoGbWVtYmVyGAIgASgLMiAuYW'
    '50aW5vdGUuQ2xpZW50U2lnbmF0dXJlLk1lbWJlckgAUgZtZW1iZXKIAQEaLAoGTWVtYmVyEg4K'
    'AmlkGAEgASgJUgJpZBISCgR0eXBlGAIgASgNUgR0eXBlQgkKB19tZW1iZXI=');

@$core.Deprecated('Use serializedNetworkStackDescriptor instead')
const SerializedNetworkStack$json = {
  '1': 'SerializedNetworkStack',
  '2': [
    {
      '1': 'crypto',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.antinote.SerializedCrypto',
      '10': 'crypto'
    },
    {'1': 'instance_version', '3': 2, '4': 1, '5': 9, '10': 'instanceVersion'},
    {'1': 'base_url', '3': 3, '4': 1, '5': 9, '10': 'baseUrl'},
    {'1': 'cookies', '3': 4, '4': 3, '5': 9, '10': 'cookies'},
    {
      '1': 'temp_workspace',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.antinote.SerializedWorkspace',
      '10': 'tempWorkspace'
    },
    {'1': 'demo', '3': 6, '4': 1, '5': 8, '10': 'demo'},
    {
      '1': 'rsa_from_constants',
      '3': 7,
      '4': 1,
      '5': 8,
      '10': 'rsaFromConstants'
    },
    {'1': 'skip_encryption', '3': 8, '4': 1, '5': 8, '10': 'skipEncryption'},
    {'1': 'skip_compression', '3': 9, '4': 1, '5': 8, '10': 'skipCompression'},
    {'1': 'http', '3': 10, '4': 1, '5': 8, '10': 'http'},
    {'1': 'poll', '3': 11, '4': 1, '5': 8, '10': 'poll'},
    {'1': 'username', '3': 12, '4': 1, '5': 9, '10': 'username'},
    {'1': 'session_id', '3': 13, '4': 1, '5': 13, '10': 'sessionId'},
    {
      '1': 'token_id',
      '3': 14,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'tokenId',
      '17': true
    },
    {
      '1': 'token_key',
      '3': 15,
      '4': 1,
      '5': 9,
      '9': 1,
      '10': 'tokenKey',
      '17': true
    },
    {
      '1': 'client_signature',
      '3': 16,
      '4': 1,
      '5': 11,
      '6': '.antinote.ClientSignature',
      '9': 2,
      '10': 'clientSignature',
      '17': true
    },
    {
      '1': 'server_signature',
      '3': 17,
      '4': 1,
      '5': 11,
      '6': '.antinote.ServerSignature',
      '9': 3,
      '10': 'serverSignature',
      '17': true
    },
    {
      '1': 'orders',
      '3': 18,
      '4': 3,
      '5': 11,
      '6': '.antinote.SerializedNetworkStack.OrdersEntry',
      '10': 'orders'
    },
  ],
  '3': [SerializedNetworkStack_OrdersEntry$json],
  '8': [
    {'1': '_token_id'},
    {'1': '_token_key'},
    {'1': '_client_signature'},
    {'1': '_server_signature'},
  ],
};

@$core.Deprecated('Use serializedNetworkStackDescriptor instead')
const SerializedNetworkStack_OrdersEntry$json = {
  '1': 'OrdersEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 17, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `SerializedNetworkStack`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List serializedNetworkStackDescriptor = $convert.base64Decode(
    'ChZTZXJpYWxpemVkTmV0d29ya1N0YWNrEjIKBmNyeXB0bxgBIAEoCzIaLmFudGlub3RlLlNlcm'
    'lhbGl6ZWRDcnlwdG9SBmNyeXB0bxIpChBpbnN0YW5jZV92ZXJzaW9uGAIgASgJUg9pbnN0YW5j'
    'ZVZlcnNpb24SGQoIYmFzZV91cmwYAyABKAlSB2Jhc2VVcmwSGAoHY29va2llcxgEIAMoCVIHY2'
    '9va2llcxJECg50ZW1wX3dvcmtzcGFjZRgFIAEoCzIdLmFudGlub3RlLlNlcmlhbGl6ZWRXb3Jr'
    'c3BhY2VSDXRlbXBXb3Jrc3BhY2USEgoEZGVtbxgGIAEoCFIEZGVtbxIsChJyc2FfZnJvbV9jb2'
    '5zdGFudHMYByABKAhSEHJzYUZyb21Db25zdGFudHMSJwoPc2tpcF9lbmNyeXB0aW9uGAggASgI'
    'Ug5za2lwRW5jcnlwdGlvbhIpChBza2lwX2NvbXByZXNzaW9uGAkgASgIUg9za2lwQ29tcHJlc3'
    'Npb24SEgoEaHR0cBgKIAEoCFIEaHR0cBISCgRwb2xsGAsgASgIUgRwb2xsEhoKCHVzZXJuYW1l'
    'GAwgASgJUgh1c2VybmFtZRIdCgpzZXNzaW9uX2lkGA0gASgNUglzZXNzaW9uSWQSHgoIdG9rZW'
    '5faWQYDiABKAlIAFIHdG9rZW5JZIgBARIgCgl0b2tlbl9rZXkYDyABKAlIAVIIdG9rZW5LZXmI'
    'AQESSQoQY2xpZW50X3NpZ25hdHVyZRgQIAEoCzIZLmFudGlub3RlLkNsaWVudFNpZ25hdHVyZU'
    'gCUg9jbGllbnRTaWduYXR1cmWIAQESSQoQc2VydmVyX3NpZ25hdHVyZRgRIAEoCzIZLmFudGlu'
    'b3RlLlNlcnZlclNpZ25hdHVyZUgDUg9zZXJ2ZXJTaWduYXR1cmWIAQESRAoGb3JkZXJzGBIgAy'
    'gLMiwuYW50aW5vdGUuU2VyaWFsaXplZE5ldHdvcmtTdGFjay5PcmRlcnNFbnRyeVIGb3JkZXJz'
    'GjkKC09yZGVyc0VudHJ5EhAKA2tleRgBIAEoCVIDa2V5EhQKBXZhbHVlGAIgASgRUgV2YWx1ZT'
    'oCOAFCCwoJX3Rva2VuX2lkQgwKCl90b2tlbl9rZXlCEwoRX2NsaWVudF9zaWduYXR1cmVCEwoR'
    'X3NlcnZlcl9zaWduYXR1cmU=');

@$core.Deprecated('Use cacheSectionDescriptor instead')
const CacheSection$json = {
  '1': 'CacheSection',
  '2': [
    {
      '1': 'type',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.antinote.CacheType',
      '10': 'type'
    },
    {
      '1': 'values',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.antinote.CacheSection.ValuesEntry',
      '10': 'values'
    },
  ],
  '3': [CacheSection_ValuesEntry$json],
};

@$core.Deprecated('Use cacheSectionDescriptor instead')
const CacheSection_ValuesEntry$json = {
  '1': 'ValuesEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `CacheSection`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cacheSectionDescriptor = $convert.base64Decode(
    'CgxDYWNoZVNlY3Rpb24SJwoEdHlwZRgBIAEoDjITLmFudGlub3RlLkNhY2hlVHlwZVIEdHlwZR'
    'I6CgZ2YWx1ZXMYAiADKAsyIi5hbnRpbm90ZS5DYWNoZVNlY3Rpb24uVmFsdWVzRW50cnlSBnZh'
    'bHVlcxo5CgtWYWx1ZXNFbnRyeRIQCgNrZXkYASABKAlSA2tleRIUCgV2YWx1ZRgCIAEoCVIFdm'
    'FsdWU6AjgB');

@$core.Deprecated('Use serializedSessionDescriptor instead')
const SerializedSession$json = {
  '1': 'SerializedSession',
  '2': [
    {
      '1': 'stack',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.antinote.SerializedNetworkStack',
      '10': 'stack'
    },
    {
      '1': 'cache',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.antinote.CacheSection',
      '10': 'cache'
    },
  ],
};

/// Descriptor for `SerializedSession`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List serializedSessionDescriptor = $convert.base64Decode(
    'ChFTZXJpYWxpemVkU2Vzc2lvbhI2CgVzdGFjaxgBIAEoCzIgLmFudGlub3RlLlNlcmlhbGl6ZW'
    'ROZXR3b3JrU3RhY2tSBXN0YWNrEiwKBWNhY2hlGAIgAygLMhYuYW50aW5vdGUuQ2FjaGVTZWN0'
    'aW9uUgVjYWNoZQ==');

@$core.Deprecated('Use sessionOptionsDescriptor instead')
const SessionOptions$json = {
  '1': 'SessionOptions',
  '2': [
    {
      '1': 'saveNavigationRequests',
      '3': 1,
      '4': 1,
      '5': 8,
      '10': 'saveNavigationRequests'
    },
  ],
};

/// Descriptor for `SessionOptions`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sessionOptionsDescriptor = $convert.base64Decode(
    'Cg5TZXNzaW9uT3B0aW9ucxI2ChZzYXZlTmF2aWdhdGlvblJlcXVlc3RzGAEgASgIUhZzYXZlTm'
    'F2aWdhdGlvblJlcXVlc3Rz');
