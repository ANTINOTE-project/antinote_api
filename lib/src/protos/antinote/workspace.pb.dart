// This is a generated file - do not edit.
//
// Generated from protos/antinote/workspace.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class SerializedWorkspace extends $pb.GeneratedMessage {
  factory SerializedWorkspace({
    $core.int? typeIndex,
    $core.String? label,
    $core.String? pathSegment,
  }) {
    final result = create();
    if (typeIndex != null) result.typeIndex = typeIndex;
    if (label != null) result.label = label;
    if (pathSegment != null) result.pathSegment = pathSegment;
    return result;
  }

  SerializedWorkspace._();

  factory SerializedWorkspace.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SerializedWorkspace.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SerializedWorkspace',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'antinote'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'typeIndex', fieldType: $pb.PbFieldType.OU3)
    ..aOS(2, _omitFieldNames ? '' : 'label')
    ..aOS(3, _omitFieldNames ? '' : 'pathSegment')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SerializedWorkspace clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SerializedWorkspace copyWith(void Function(SerializedWorkspace) updates) =>
      super.copyWith((message) => updates(message as SerializedWorkspace))
          as SerializedWorkspace;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SerializedWorkspace create() => SerializedWorkspace._();
  @$core.override
  SerializedWorkspace createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SerializedWorkspace getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SerializedWorkspace>(create);
  static SerializedWorkspace? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get typeIndex => $_getIZ(0);
  @$pb.TagNumber(1)
  set typeIndex($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTypeIndex() => $_has(0);
  @$pb.TagNumber(1)
  void clearTypeIndex() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get label => $_getSZ(1);
  @$pb.TagNumber(2)
  set label($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLabel() => $_has(1);
  @$pb.TagNumber(2)
  void clearLabel() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get pathSegment => $_getSZ(2);
  @$pb.TagNumber(3)
  set pathSegment($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPathSegment() => $_has(2);
  @$pb.TagNumber(3)
  void clearPathSegment() => $_clearField(3);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
