// This is a generated file - do not edit.
//
// Generated from protos/antinote/session.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'session.pbenum.dart';
import 'workspace.pb.dart' as $0;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'session.pbenum.dart';

class SerializedCrypto extends $pb.GeneratedMessage {
  factory SerializedCrypto({
    $core.List<$core.int>? iv,
    $core.List<$core.int>? key,
    $core.String? rsaModulus,
    $core.String? rsaExponent,
  }) {
    final result = create();
    if (iv != null) result.iv = iv;
    if (key != null) result.key = key;
    if (rsaModulus != null) result.rsaModulus = rsaModulus;
    if (rsaExponent != null) result.rsaExponent = rsaExponent;
    return result;
  }

  SerializedCrypto._();

  factory SerializedCrypto.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SerializedCrypto.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SerializedCrypto',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'antinote'),
      createEmptyInstance: create)
    ..a<$core.List<$core.int>>(
        1, _omitFieldNames ? '' : 'iv', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(
        2, _omitFieldNames ? '' : 'key', $pb.PbFieldType.OY)
    ..aOS(3, _omitFieldNames ? '' : 'rsaModulus')
    ..aOS(4, _omitFieldNames ? '' : 'rsaExponent')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SerializedCrypto clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SerializedCrypto copyWith(void Function(SerializedCrypto) updates) =>
      super.copyWith((message) => updates(message as SerializedCrypto))
          as SerializedCrypto;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SerializedCrypto create() => SerializedCrypto._();
  @$core.override
  SerializedCrypto createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SerializedCrypto getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SerializedCrypto>(create);
  static SerializedCrypto? _defaultInstance;

  /// 16 bytes for the AES Initialization Vector used in the relevant session.
  @$pb.TagNumber(1)
  $core.List<$core.int> get iv => $_getN(0);
  @$pb.TagNumber(1)
  set iv($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIv() => $_has(0);
  @$pb.TagNumber(1)
  void clearIv() => $_clearField(1);

  /// The unknown-length key given by the remote to communicate with the server.
  @$pb.TagNumber(2)
  $core.List<$core.int> get key => $_getN(1);
  @$pb.TagNumber(2)
  set key($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearKey() => $_clearField(2);

  /// The RSA modulo for the session, if one is given by the remote (else we use the default).
  @$pb.TagNumber(3)
  $core.String get rsaModulus => $_getSZ(2);
  @$pb.TagNumber(3)
  set rsaModulus($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRsaModulus() => $_has(2);
  @$pb.TagNumber(3)
  void clearRsaModulus() => $_clearField(3);

  /// The RSA exponent for the session, if one is given by the remote (else we use the default).
  @$pb.TagNumber(4)
  $core.String get rsaExponent => $_getSZ(3);
  @$pb.TagNumber(4)
  set rsaExponent($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRsaExponent() => $_has(3);
  @$pb.TagNumber(4)
  void clearRsaExponent() => $_clearField(4);
}

class ServerSignature extends $pb.GeneratedMessage {
  factory ServerSignature({
    $core.bool? exclusiveMode,
    $core.Iterable<$core.MapEntry<$core.int, $core.int>>? tabNotificationCounts,
    $core.int? visibleNotificationsCount,
    ServerSignature_ConnectionStatus? connectionStatus,
  }) {
    final result = create();
    if (exclusiveMode != null) result.exclusiveMode = exclusiveMode;
    if (tabNotificationCounts != null)
      result.tabNotificationCounts.addEntries(tabNotificationCounts);
    if (visibleNotificationsCount != null)
      result.visibleNotificationsCount = visibleNotificationsCount;
    if (connectionStatus != null) result.connectionStatus = connectionStatus;
    return result;
  }

  ServerSignature._();

  factory ServerSignature.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ServerSignature.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ServerSignature',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'antinote'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'exclusiveMode', protoName: 'exclusiveMode')
    ..m<$core.int, $core.int>(2, _omitFieldNames ? '' : 'tabNotificationCounts',
        entryClassName: 'ServerSignature.TabNotificationCountsEntry',
        keyFieldType: $pb.PbFieldType.OU3,
        valueFieldType: $pb.PbFieldType.OU3,
        packageName: const $pb.PackageName('antinote'))
    ..aI(3, _omitFieldNames ? '' : 'visibleNotificationsCount',
        fieldType: $pb.PbFieldType.OU3)
    ..aE<ServerSignature_ConnectionStatus>(
        4, _omitFieldNames ? '' : 'connectionStatus',
        enumValues: ServerSignature_ConnectionStatus.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServerSignature clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServerSignature copyWith(void Function(ServerSignature) updates) =>
      super.copyWith((message) => updates(message as ServerSignature))
          as ServerSignature;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ServerSignature create() => ServerSignature._();
  @$core.override
  ServerSignature createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ServerSignature getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ServerSignature>(create);
  static ServerSignature? _defaultInstance;

  /// Whether the app is in the "exclusive" mode. If true, no edit requests can be sent (it is recommended the UI should update accordingly).
  @$pb.TagNumber(1)
  $core.bool get exclusiveMode => $_getBF(0);
  @$pb.TagNumber(1)
  set exclusiveMode($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasExclusiveMode() => $_has(0);
  @$pb.TagNumber(1)
  void clearExclusiveMode() => $_clearField(1);

  /// Tells how many notifications are active for relevant tabs.
  @$pb.TagNumber(2)
  $pb.PbMap<$core.int, $core.int> get tabNotificationCounts => $_getMap(1);

  /// Used to know how many notifications are currently active.
  @$pb.TagNumber(3)
  $core.int get visibleNotificationsCount => $_getIZ(2);
  @$pb.TagNumber(3)
  set visibleNotificationsCount($core.int value) =>
      $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasVisibleNotificationsCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearVisibleNotificationsCount() => $_clearField(3);

  /// The status for the current account (used for communication).
  @$pb.TagNumber(4)
  ServerSignature_ConnectionStatus get connectionStatus => $_getN(3);
  @$pb.TagNumber(4)
  set connectionStatus(ServerSignature_ConnectionStatus value) =>
      $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasConnectionStatus() => $_has(3);
  @$pb.TagNumber(4)
  void clearConnectionStatus() => $_clearField(4);
}

class ClientSignature_Member extends $pb.GeneratedMessage {
  factory ClientSignature_Member({
    $core.String? id,
    $core.int? type,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (type != null) result.type = type;
    return result;
  }

  ClientSignature_Member._();

  factory ClientSignature_Member.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ClientSignature_Member.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ClientSignature.Member',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'antinote'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aI(2, _omitFieldNames ? '' : 'type', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClientSignature_Member clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClientSignature_Member copyWith(
          void Function(ClientSignature_Member) updates) =>
      super.copyWith((message) => updates(message as ClientSignature_Member))
          as ClientSignature_Member;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ClientSignature_Member create() => ClientSignature_Member._();
  @$core.override
  ClientSignature_Member createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ClientSignature_Member getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ClientSignature_Member>(create);
  static ClientSignature_Member? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get type => $_getIZ(1);
  @$pb.TagNumber(2)
  set type($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasType() => $_has(1);
  @$pb.TagNumber(2)
  void clearType() => $_clearField(2);
}

class ClientSignature extends $pb.GeneratedMessage {
  factory ClientSignature({
    $core.int? tab,
    ClientSignature_Member? member,
  }) {
    final result = create();
    if (tab != null) result.tab = tab;
    if (member != null) result.member = member;
    return result;
  }

  ClientSignature._();

  factory ClientSignature.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ClientSignature.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ClientSignature',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'antinote'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'tab', fieldType: $pb.PbFieldType.OS3)
    ..aOM<ClientSignature_Member>(2, _omitFieldNames ? '' : 'member',
        subBuilder: ClientSignature_Member.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClientSignature clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClientSignature copyWith(void Function(ClientSignature) updates) =>
      super.copyWith((message) => updates(message as ClientSignature))
          as ClientSignature;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ClientSignature create() => ClientSignature._();
  @$core.override
  ClientSignature createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ClientSignature getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ClientSignature>(create);
  static ClientSignature? _defaultInstance;

  /// The currently selected tab.
  @$pb.TagNumber(1)
  $core.int get tab => $_getIZ(0);
  @$pb.TagNumber(1)
  set tab($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTab() => $_has(0);
  @$pb.TagNumber(1)
  void clearTab() => $_clearField(1);

  /// The currently selected member.
  @$pb.TagNumber(2)
  ClientSignature_Member get member => $_getN(1);
  @$pb.TagNumber(2)
  set member(ClientSignature_Member value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasMember() => $_has(1);
  @$pb.TagNumber(2)
  void clearMember() => $_clearField(2);
  @$pb.TagNumber(2)
  ClientSignature_Member ensureMember() => $_ensure(1);
}

class SerializedNetworkStack extends $pb.GeneratedMessage {
  factory SerializedNetworkStack({
    SerializedCrypto? crypto,
    $core.String? instanceVersion,
    $core.String? baseUrl,
    $core.Iterable<$core.String>? cookies,
    $0.SerializedWorkspace? tempWorkspace,
    $core.bool? demo,
    $core.bool? rsaFromConstants,
    $core.bool? skipEncryption,
    $core.bool? skipCompression,
    $core.bool? http,
    $core.bool? poll,
    $core.String? username,
    $core.int? sessionId,
    $core.String? tokenId,
    $core.String? tokenKey,
    ClientSignature? clientSignature,
    ServerSignature? serverSignature,
    $core.Iterable<$core.MapEntry<$core.String, $core.int>>? orders,
  }) {
    final result = create();
    if (crypto != null) result.crypto = crypto;
    if (instanceVersion != null) result.instanceVersion = instanceVersion;
    if (baseUrl != null) result.baseUrl = baseUrl;
    if (cookies != null) result.cookies.addAll(cookies);
    if (tempWorkspace != null) result.tempWorkspace = tempWorkspace;
    if (demo != null) result.demo = demo;
    if (rsaFromConstants != null) result.rsaFromConstants = rsaFromConstants;
    if (skipEncryption != null) result.skipEncryption = skipEncryption;
    if (skipCompression != null) result.skipCompression = skipCompression;
    if (http != null) result.http = http;
    if (poll != null) result.poll = poll;
    if (username != null) result.username = username;
    if (sessionId != null) result.sessionId = sessionId;
    if (tokenId != null) result.tokenId = tokenId;
    if (tokenKey != null) result.tokenKey = tokenKey;
    if (clientSignature != null) result.clientSignature = clientSignature;
    if (serverSignature != null) result.serverSignature = serverSignature;
    if (orders != null) result.orders.addEntries(orders);
    return result;
  }

  SerializedNetworkStack._();

  factory SerializedNetworkStack.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SerializedNetworkStack.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SerializedNetworkStack',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'antinote'),
      createEmptyInstance: create)
    ..aOM<SerializedCrypto>(1, _omitFieldNames ? '' : 'crypto',
        subBuilder: SerializedCrypto.create)
    ..aOS(2, _omitFieldNames ? '' : 'instanceVersion')
    ..aOS(3, _omitFieldNames ? '' : 'baseUrl')
    ..pPS(4, _omitFieldNames ? '' : 'cookies')
    ..aOM<$0.SerializedWorkspace>(5, _omitFieldNames ? '' : 'tempWorkspace',
        subBuilder: $0.SerializedWorkspace.create)
    ..aOB(6, _omitFieldNames ? '' : 'demo')
    ..aOB(7, _omitFieldNames ? '' : 'rsaFromConstants')
    ..aOB(8, _omitFieldNames ? '' : 'skipEncryption')
    ..aOB(9, _omitFieldNames ? '' : 'skipCompression')
    ..aOB(10, _omitFieldNames ? '' : 'http')
    ..aOB(11, _omitFieldNames ? '' : 'poll')
    ..aOS(12, _omitFieldNames ? '' : 'username')
    ..aI(13, _omitFieldNames ? '' : 'sessionId', fieldType: $pb.PbFieldType.OU3)
    ..aOS(14, _omitFieldNames ? '' : 'tokenId')
    ..aOS(15, _omitFieldNames ? '' : 'tokenKey')
    ..aOM<ClientSignature>(16, _omitFieldNames ? '' : 'clientSignature',
        subBuilder: ClientSignature.create)
    ..aOM<ServerSignature>(17, _omitFieldNames ? '' : 'serverSignature',
        subBuilder: ServerSignature.create)
    ..m<$core.String, $core.int>(18, _omitFieldNames ? '' : 'orders',
        entryClassName: 'SerializedNetworkStack.OrdersEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS3,
        packageName: const $pb.PackageName('antinote'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SerializedNetworkStack clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SerializedNetworkStack copyWith(
          void Function(SerializedNetworkStack) updates) =>
      super.copyWith((message) => updates(message as SerializedNetworkStack))
          as SerializedNetworkStack;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SerializedNetworkStack create() => SerializedNetworkStack._();
  @$core.override
  SerializedNetworkStack createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SerializedNetworkStack getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SerializedNetworkStack>(create);
  static SerializedNetworkStack? _defaultInstance;

  @$pb.TagNumber(1)
  SerializedCrypto get crypto => $_getN(0);
  @$pb.TagNumber(1)
  set crypto(SerializedCrypto value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCrypto() => $_has(0);
  @$pb.TagNumber(1)
  void clearCrypto() => $_clearField(1);
  @$pb.TagNumber(1)
  SerializedCrypto ensureCrypto() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get instanceVersion => $_getSZ(1);
  @$pb.TagNumber(2)
  set instanceVersion($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasInstanceVersion() => $_has(1);
  @$pb.TagNumber(2)
  void clearInstanceVersion() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get baseUrl => $_getSZ(2);
  @$pb.TagNumber(3)
  set baseUrl($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasBaseUrl() => $_has(2);
  @$pb.TagNumber(3)
  void clearBaseUrl() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<$core.String> get cookies => $_getList(3);

  @$pb.TagNumber(5)
  $0.SerializedWorkspace get tempWorkspace => $_getN(4);
  @$pb.TagNumber(5)
  set tempWorkspace($0.SerializedWorkspace value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasTempWorkspace() => $_has(4);
  @$pb.TagNumber(5)
  void clearTempWorkspace() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.SerializedWorkspace ensureTempWorkspace() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.bool get demo => $_getBF(5);
  @$pb.TagNumber(6)
  set demo($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasDemo() => $_has(5);
  @$pb.TagNumber(6)
  void clearDemo() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get rsaFromConstants => $_getBF(6);
  @$pb.TagNumber(7)
  set rsaFromConstants($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasRsaFromConstants() => $_has(6);
  @$pb.TagNumber(7)
  void clearRsaFromConstants() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get skipEncryption => $_getBF(7);
  @$pb.TagNumber(8)
  set skipEncryption($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasSkipEncryption() => $_has(7);
  @$pb.TagNumber(8)
  void clearSkipEncryption() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.bool get skipCompression => $_getBF(8);
  @$pb.TagNumber(9)
  set skipCompression($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasSkipCompression() => $_has(8);
  @$pb.TagNumber(9)
  void clearSkipCompression() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.bool get http => $_getBF(9);
  @$pb.TagNumber(10)
  set http($core.bool value) => $_setBool(9, value);
  @$pb.TagNumber(10)
  $core.bool hasHttp() => $_has(9);
  @$pb.TagNumber(10)
  void clearHttp() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.bool get poll => $_getBF(10);
  @$pb.TagNumber(11)
  set poll($core.bool value) => $_setBool(10, value);
  @$pb.TagNumber(11)
  $core.bool hasPoll() => $_has(10);
  @$pb.TagNumber(11)
  void clearPoll() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get username => $_getSZ(11);
  @$pb.TagNumber(12)
  set username($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasUsername() => $_has(11);
  @$pb.TagNumber(12)
  void clearUsername() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.int get sessionId => $_getIZ(12);
  @$pb.TagNumber(13)
  set sessionId($core.int value) => $_setUnsignedInt32(12, value);
  @$pb.TagNumber(13)
  $core.bool hasSessionId() => $_has(12);
  @$pb.TagNumber(13)
  void clearSessionId() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.String get tokenId => $_getSZ(13);
  @$pb.TagNumber(14)
  set tokenId($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasTokenId() => $_has(13);
  @$pb.TagNumber(14)
  void clearTokenId() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.String get tokenKey => $_getSZ(14);
  @$pb.TagNumber(15)
  set tokenKey($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasTokenKey() => $_has(14);
  @$pb.TagNumber(15)
  void clearTokenKey() => $_clearField(15);

  @$pb.TagNumber(16)
  ClientSignature get clientSignature => $_getN(15);
  @$pb.TagNumber(16)
  set clientSignature(ClientSignature value) => $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasClientSignature() => $_has(15);
  @$pb.TagNumber(16)
  void clearClientSignature() => $_clearField(16);
  @$pb.TagNumber(16)
  ClientSignature ensureClientSignature() => $_ensure(15);

  @$pb.TagNumber(17)
  ServerSignature get serverSignature => $_getN(16);
  @$pb.TagNumber(17)
  set serverSignature(ServerSignature value) => $_setField(17, value);
  @$pb.TagNumber(17)
  $core.bool hasServerSignature() => $_has(16);
  @$pb.TagNumber(17)
  void clearServerSignature() => $_clearField(17);
  @$pb.TagNumber(17)
  ServerSignature ensureServerSignature() => $_ensure(16);

  @$pb.TagNumber(18)
  $pb.PbMap<$core.String, $core.int> get orders => $_getMap(17);
}

class CacheSection extends $pb.GeneratedMessage {
  factory CacheSection({
    CacheType? type,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? values,
  }) {
    final result = create();
    if (type != null) result.type = type;
    if (values != null) result.values.addEntries(values);
    return result;
  }

  CacheSection._();

  factory CacheSection.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CacheSection.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CacheSection',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'antinote'),
      createEmptyInstance: create)
    ..aE<CacheType>(1, _omitFieldNames ? '' : 'type',
        enumValues: CacheType.values)
    ..m<$core.String, $core.String>(2, _omitFieldNames ? '' : 'values',
        entryClassName: 'CacheSection.ValuesEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('antinote'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CacheSection clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CacheSection copyWith(void Function(CacheSection) updates) =>
      super.copyWith((message) => updates(message as CacheSection))
          as CacheSection;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CacheSection create() => CacheSection._();
  @$core.override
  CacheSection createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CacheSection getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CacheSection>(create);
  static CacheSection? _defaultInstance;

  @$pb.TagNumber(1)
  CacheType get type => $_getN(0);
  @$pb.TagNumber(1)
  set type(CacheType value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbMap<$core.String, $core.String> get values => $_getMap(1);
}

class SerializedSession extends $pb.GeneratedMessage {
  factory SerializedSession({
    SerializedNetworkStack? stack,
    $core.Iterable<CacheSection>? cache,
  }) {
    final result = create();
    if (stack != null) result.stack = stack;
    if (cache != null) result.cache.addAll(cache);
    return result;
  }

  SerializedSession._();

  factory SerializedSession.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SerializedSession.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SerializedSession',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'antinote'),
      createEmptyInstance: create)
    ..aOM<SerializedNetworkStack>(1, _omitFieldNames ? '' : 'stack',
        subBuilder: SerializedNetworkStack.create)
    ..pPM<CacheSection>(2, _omitFieldNames ? '' : 'cache',
        subBuilder: CacheSection.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SerializedSession clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SerializedSession copyWith(void Function(SerializedSession) updates) =>
      super.copyWith((message) => updates(message as SerializedSession))
          as SerializedSession;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SerializedSession create() => SerializedSession._();
  @$core.override
  SerializedSession createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SerializedSession getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SerializedSession>(create);
  static SerializedSession? _defaultInstance;

  @$pb.TagNumber(1)
  SerializedNetworkStack get stack => $_getN(0);
  @$pb.TagNumber(1)
  set stack(SerializedNetworkStack value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasStack() => $_has(0);
  @$pb.TagNumber(1)
  void clearStack() => $_clearField(1);
  @$pb.TagNumber(1)
  SerializedNetworkStack ensureStack() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<CacheSection> get cache => $_getList(1);
}

class SessionOptions extends $pb.GeneratedMessage {
  factory SessionOptions({
    $core.bool? saveNavigationRequests,
    $core.bool? debugMode,
  }) {
    final result = create();
    if (saveNavigationRequests != null)
      result.saveNavigationRequests = saveNavigationRequests;
    if (debugMode != null) result.debugMode = debugMode;
    return result;
  }

  SessionOptions._();

  factory SessionOptions.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SessionOptions.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SessionOptions',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'antinote'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'saveNavigationRequests',
        protoName: 'saveNavigationRequests')
    ..aOB(2, _omitFieldNames ? '' : 'debugMode', protoName: 'debugMode')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SessionOptions clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SessionOptions copyWith(void Function(SessionOptions) updates) =>
      super.copyWith((message) => updates(message as SessionOptions))
          as SessionOptions;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SessionOptions create() => SessionOptions._();
  @$core.override
  SessionOptions createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SessionOptions getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SessionOptions>(create);
  static SessionOptions? _defaultInstance;

  /// When this field is true, Navigation requests won't be sent from ensurePage.
  @$pb.TagNumber(1)
  $core.bool get saveNavigationRequests => $_getBF(0);
  @$pb.TagNumber(1)
  set saveNavigationRequests($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSaveNavigationRequests() => $_has(0);
  @$pb.TagNumber(1)
  void clearSaveNavigationRequests() => $_clearField(1);

  /// Will log every single request sent and received to/from remote.
  @$pb.TagNumber(2)
  $core.bool get debugMode => $_getBF(1);
  @$pb.TagNumber(2)
  set debugMode($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDebugMode() => $_has(1);
  @$pb.TagNumber(2)
  void clearDebugMode() => $_clearField(2);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
