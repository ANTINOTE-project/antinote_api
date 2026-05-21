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

class CacheType extends $pb.ProtobufEnum {
  /// SPECIAL CACHE TYPE
  ///
  /// Will simply give out the latest value for each item type put in cache when
  /// asked (this is just a marker where we expect any object that wants to
  /// replace versions of it by putting the same constant visual ID).
  static const CacheType UNIQUE =
      CacheType._(0, _omitEnumNames ? '' : 'UNIQUE');
  static const CacheType PERIOD =
      CacheType._(1, _omitEnumNames ? '' : 'PERIOD');
  static const CacheType DISCUSSION_MESSAGE =
      CacheType._(2, _omitEnumNames ? '' : 'DISCUSSION_MESSAGE');
  static const CacheType FILE_ATTACHMENT =
      CacheType._(3, _omitEnumNames ? '' : 'FILE_ATTACHMENT');
  static const CacheType LINK_ATTACHMENT =
      CacheType._(4, _omitEnumNames ? '' : 'LINK_ATTACHMENT');
  static const CacheType SUBMITTED_FILE_ATTACHMENT =
      CacheType._(5, _omitEnumNames ? '' : 'SUBMITTED_FILE_ATTACHMENT');
  static const CacheType DISCUSSION_NODE =
      CacheType._(6, _omitEnumNames ? '' : 'DISCUSSION_NODE');
  static const CacheType SERVICE =
      CacheType._(7, _omitEnumNames ? '' : 'SERVICE');
  static const CacheType EXAM = CacheType._(8, _omitEnumNames ? '' : 'EXAM');
  static const CacheType THEME = CacheType._(9, _omitEnumNames ? '' : 'THEME');
  static const CacheType MEAL = CacheType._(10, _omitEnumNames ? '' : 'MEAL');
  static const CacheType FOOD = CacheType._(11, _omitEnumNames ? '' : 'FOOD');
  static const CacheType FOOD_LABEL =
      CacheType._(12, _omitEnumNames ? '' : 'FOOD_LABEL');
  static const CacheType FOOD_ALLERGEN =
      CacheType._(13, _omitEnumNames ? '' : 'FOOD_ALLERGEN');
  static const CacheType NEWS = CacheType._(14, _omitEnumNames ? '' : 'NEWS');
  static const CacheType PERSON =
      CacheType._(15, _omitEnumNames ? '' : 'PERSON');
  static const CacheType NEWS_CATEGORY =
      CacheType._(16, _omitEnumNames ? '' : 'NEWS_CATEGORY');
  static const CacheType NEWS_QUESTION =
      CacheType._(17, _omitEnumNames ? '' : 'NEWS_QUESTION');
  static const CacheType NEWS_QUESTION_PICK =
      CacheType._(18, _omitEnumNames ? '' : 'NEWS_QUESTION_PICK');
  static const CacheType NEWS_QUESTION_ANSWER =
      CacheType._(19, _omitEnumNames ? '' : 'NEWS_QUESTION_ANSWER');
  static const CacheType NOTEBOOK_ENTRY =
      CacheType._(20, _omitEnumNames ? '' : 'NOTEBOOK_ENTRY');
  static const CacheType NOTEBOOK_ENTRY_GROUP =
      CacheType._(21, _omitEnumNames ? '' : 'NOTEBOOK_ENTRY_GROUP');
  static const CacheType NOTEBOOK_CONTENT =
      CacheType._(22, _omitEnumNames ? '' : 'NOTEBOOK_CONTENT');
  static const CacheType NOTEBOOK_CONTENT_CATEGORY =
      CacheType._(23, _omitEnumNames ? '' : 'NOTEBOOK_CONTENT_CATEGORY');
  static const CacheType HOMEWORK =
      CacheType._(24, _omitEnumNames ? '' : 'HOMEWORK');
  static const CacheType HANDED_ASSIGNMENT =
      CacheType._(25, _omitEnumNames ? '' : 'HANDED_ASSIGNMENT');
  static const CacheType NOTEBOOK_RESOURCE_ENTRY =
      CacheType._(26, _omitEnumNames ? '' : 'NOTEBOOK_RESOURCE_ENTRY');
  static const CacheType CLAZZ = CacheType._(27, _omitEnumNames ? '' : 'CLAZZ');
  static const CacheType SUBJECT =
      CacheType._(28, _omitEnumNames ? '' : 'SUBJECT');
  static const CacheType NOTEBOOK_ENTRY_PREVIEW =
      CacheType._(29, _omitEnumNames ? '' : 'NOTEBOOK_ENTRY_PREVIEW');
  static const CacheType NOTEBOOK_RESOURCE =
      CacheType._(30, _omitEnumNames ? '' : 'NOTEBOOK_RESOURCE');
  static const CacheType PEDAGOGICAL_FORUM =
      CacheType._(31, _omitEnumNames ? '' : 'PEDAGOGICAL_FORUM');
  static const CacheType MCQ_EXECUTION =
      CacheType._(32, _omitEnumNames ? '' : 'MCQ_EXECUTION');
  static const CacheType MCQ = CacheType._(33, _omitEnumNames ? '' : 'MCQ');
  static const CacheType EXAM_PREVIEW =
      CacheType._(34, _omitEnumNames ? '' : 'EXAM_PREVIEW');
  static const CacheType ROOM = CacheType._(35, _omitEnumNames ? '' : 'ROOM');
  static const CacheType SCHOOL_LIFE_EVENT =
      CacheType._(36, _omitEnumNames ? '' : 'SCHOOL_LIFE_EVENT');
  static const CacheType SCHOOL_LIFE_EVENT_REASON =
      CacheType._(37, _omitEnumNames ? '' : 'SCHOOL_LIFE_EVENT_REASON');
  static const CacheType SCHOOL_LIFE_EVENT_SECTION =
      CacheType._(38, _omitEnumNames ? '' : 'SCHOOL_LIFE_EVENT_SECTION');
  static const CacheType USER_RESOURCE =
      CacheType._(39, _omitEnumNames ? '' : 'USER_RESOURCE');
  static const CacheType HOLIDAY =
      CacheType._(40, _omitEnumNames ? '' : 'HOLIDAY');
  static const CacheType CLASSROOM =
      CacheType._(41, _omitEnumNames ? '' : 'CLASSROOM');
  static const CacheType CLASS_GROUP =
      CacheType._(42, _omitEnumNames ? '' : 'CLASS_GROUP');

  static const $core.List<CacheType> values = <CacheType>[
    UNIQUE,
    PERIOD,
    DISCUSSION_MESSAGE,
    FILE_ATTACHMENT,
    LINK_ATTACHMENT,
    SUBMITTED_FILE_ATTACHMENT,
    DISCUSSION_NODE,
    SERVICE,
    EXAM,
    THEME,
    MEAL,
    FOOD,
    FOOD_LABEL,
    FOOD_ALLERGEN,
    NEWS,
    PERSON,
    NEWS_CATEGORY,
    NEWS_QUESTION,
    NEWS_QUESTION_PICK,
    NEWS_QUESTION_ANSWER,
    NOTEBOOK_ENTRY,
    NOTEBOOK_ENTRY_GROUP,
    NOTEBOOK_CONTENT,
    NOTEBOOK_CONTENT_CATEGORY,
    HOMEWORK,
    HANDED_ASSIGNMENT,
    NOTEBOOK_RESOURCE_ENTRY,
    CLAZZ,
    SUBJECT,
    NOTEBOOK_ENTRY_PREVIEW,
    NOTEBOOK_RESOURCE,
    PEDAGOGICAL_FORUM,
    MCQ_EXECUTION,
    MCQ,
    EXAM_PREVIEW,
    ROOM,
    SCHOOL_LIFE_EVENT,
    SCHOOL_LIFE_EVENT_REASON,
    SCHOOL_LIFE_EVENT_SECTION,
    USER_RESOURCE,
    HOLIDAY,
    CLASSROOM,
    CLASS_GROUP,
  ];

  static final $core.List<CacheType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 42);
  static CacheType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const CacheType._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
