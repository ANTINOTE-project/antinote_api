// This is a generated file - do not edit.
//
// Generated from protos/antinote/credentials.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'workspace.pb.dart' as $0;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class SerializedTokenCredentials extends $pb.GeneratedMessage {
  factory SerializedTokenCredentials({
    $core.String? username,
    $core.String? token,
    $0.SerializedWorkspace? workspace,
    $core.String? baseUrl,
    $core.Iterable<$core.String>? cookies,
    $core.String? deviceUuid,
    $core.String? navIdentifier,
  }) {
    final result = create();
    if (username != null) result.username = username;
    if (token != null) result.token = token;
    if (workspace != null) result.workspace = workspace;
    if (baseUrl != null) result.baseUrl = baseUrl;
    if (cookies != null) result.cookies.addAll(cookies);
    if (deviceUuid != null) result.deviceUuid = deviceUuid;
    if (navIdentifier != null) result.navIdentifier = navIdentifier;
    return result;
  }

  SerializedTokenCredentials._();

  factory SerializedTokenCredentials.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SerializedTokenCredentials.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SerializedTokenCredentials',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'antinote'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'username')
    ..aOS(2, _omitFieldNames ? '' : 'token')
    ..aOM<$0.SerializedWorkspace>(3, _omitFieldNames ? '' : 'workspace',
        subBuilder: $0.SerializedWorkspace.create)
    ..aOS(4, _omitFieldNames ? '' : 'baseUrl')
    ..pPS(5, _omitFieldNames ? '' : 'cookies')
    ..aOS(6, _omitFieldNames ? '' : 'deviceUuid')
    ..aOS(7, _omitFieldNames ? '' : 'navIdentifier')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SerializedTokenCredentials clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SerializedTokenCredentials copyWith(
          void Function(SerializedTokenCredentials) updates) =>
      super.copyWith(
              (message) => updates(message as SerializedTokenCredentials))
          as SerializedTokenCredentials;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SerializedTokenCredentials create() => SerializedTokenCredentials._();
  @$core.override
  SerializedTokenCredentials createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SerializedTokenCredentials getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SerializedTokenCredentials>(create);
  static SerializedTokenCredentials? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get username => $_getSZ(0);
  @$pb.TagNumber(1)
  set username($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUsername() => $_has(0);
  @$pb.TagNumber(1)
  void clearUsername() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get token => $_getSZ(1);
  @$pb.TagNumber(2)
  set token($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearToken() => $_clearField(2);

  @$pb.TagNumber(3)
  $0.SerializedWorkspace get workspace => $_getN(2);
  @$pb.TagNumber(3)
  set workspace($0.SerializedWorkspace value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasWorkspace() => $_has(2);
  @$pb.TagNumber(3)
  void clearWorkspace() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.SerializedWorkspace ensureWorkspace() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.String get baseUrl => $_getSZ(3);
  @$pb.TagNumber(4)
  set baseUrl($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasBaseUrl() => $_has(3);
  @$pb.TagNumber(4)
  void clearBaseUrl() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<$core.String> get cookies => $_getList(4);

  @$pb.TagNumber(6)
  $core.String get deviceUuid => $_getSZ(5);
  @$pb.TagNumber(6)
  set deviceUuid($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasDeviceUuid() => $_has(5);
  @$pb.TagNumber(6)
  void clearDeviceUuid() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get navIdentifier => $_getSZ(6);
  @$pb.TagNumber(7)
  set navIdentifier($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasNavIdentifier() => $_has(6);
  @$pb.TagNumber(7)
  void clearNavIdentifier() => $_clearField(7);
}

class SerializedPasswordCredentials extends $pb.GeneratedMessage {
  factory SerializedPasswordCredentials({
    $core.String? username,
    $core.String? password,
    $0.SerializedWorkspace? workspace,
    $core.String? baseUrl,
    $core.Iterable<$core.String>? cookies,
    $core.String? deviceUuid,
    $core.String? navIdentifier,
  }) {
    final result = create();
    if (username != null) result.username = username;
    if (password != null) result.password = password;
    if (workspace != null) result.workspace = workspace;
    if (baseUrl != null) result.baseUrl = baseUrl;
    if (cookies != null) result.cookies.addAll(cookies);
    if (deviceUuid != null) result.deviceUuid = deviceUuid;
    if (navIdentifier != null) result.navIdentifier = navIdentifier;
    return result;
  }

  SerializedPasswordCredentials._();

  factory SerializedPasswordCredentials.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SerializedPasswordCredentials.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SerializedPasswordCredentials',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'antinote'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'username')
    ..aOS(2, _omitFieldNames ? '' : 'password')
    ..aOM<$0.SerializedWorkspace>(3, _omitFieldNames ? '' : 'workspace',
        subBuilder: $0.SerializedWorkspace.create)
    ..aOS(4, _omitFieldNames ? '' : 'baseUrl')
    ..pPS(5, _omitFieldNames ? '' : 'cookies')
    ..aOS(6, _omitFieldNames ? '' : 'deviceUuid')
    ..aOS(7, _omitFieldNames ? '' : 'navIdentifier')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SerializedPasswordCredentials clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SerializedPasswordCredentials copyWith(
          void Function(SerializedPasswordCredentials) updates) =>
      super.copyWith(
              (message) => updates(message as SerializedPasswordCredentials))
          as SerializedPasswordCredentials;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SerializedPasswordCredentials create() =>
      SerializedPasswordCredentials._();
  @$core.override
  SerializedPasswordCredentials createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SerializedPasswordCredentials getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SerializedPasswordCredentials>(create);
  static SerializedPasswordCredentials? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get username => $_getSZ(0);
  @$pb.TagNumber(1)
  set username($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUsername() => $_has(0);
  @$pb.TagNumber(1)
  void clearUsername() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get password => $_getSZ(1);
  @$pb.TagNumber(2)
  set password($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPassword() => $_has(1);
  @$pb.TagNumber(2)
  void clearPassword() => $_clearField(2);

  @$pb.TagNumber(3)
  $0.SerializedWorkspace get workspace => $_getN(2);
  @$pb.TagNumber(3)
  set workspace($0.SerializedWorkspace value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasWorkspace() => $_has(2);
  @$pb.TagNumber(3)
  void clearWorkspace() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.SerializedWorkspace ensureWorkspace() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.String get baseUrl => $_getSZ(3);
  @$pb.TagNumber(4)
  set baseUrl($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasBaseUrl() => $_has(3);
  @$pb.TagNumber(4)
  void clearBaseUrl() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<$core.String> get cookies => $_getList(4);

  @$pb.TagNumber(6)
  $core.String get deviceUuid => $_getSZ(5);
  @$pb.TagNumber(6)
  set deviceUuid($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasDeviceUuid() => $_has(5);
  @$pb.TagNumber(6)
  void clearDeviceUuid() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get navIdentifier => $_getSZ(6);
  @$pb.TagNumber(7)
  set navIdentifier($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasNavIdentifier() => $_has(6);
  @$pb.TagNumber(7)
  void clearNavIdentifier() => $_clearField(7);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
