part of 'classes.dart';

final class Activity extends Class {
  final String title;
  final List<String> attendants;
  final String resourceTypeName;
  final String resourceValue;

  @override
  String? get status => null;

  @override
  bool get canceled => false;

  const Activity({
    required this.title,
    required this.attendants,
    required this.resourceTypeName,
    required this.resourceValue,
    required super.id,
    required super.backgroundColor,
    required super.startDate,
    required super.endDate,
    required super.blockLength,
    required super.blockSlot,
    required super.notes,
    required super.weekNumber,
  });

  @override
  ClassType get type => ClassType.activity;

  factory Activity.decode(
    ClassMessage classMessage,
    MapJsonNavigator activity,
  ) {
    return Activity(
      title: activity.get('motif'),
      attendants: activity.getL<String>('accompagnateurs'),
      resourceTypeName: activity.get('strGenreRess'),
      resourceValue: activity.get('strRess'),
      id: classMessage.id,
      backgroundColor: classMessage.backgroundColor,
      startDate: classMessage.startDate,
      endDate: classMessage.endDate,
      blockLength: classMessage.blockLength,
      blockSlot: classMessage.blockSlot,
      notes: classMessage.notes,
      weekNumber: classMessage.weekNumber,
    );
  }

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield title.visualIdData();
    yield* attendants.visualIdData();
    yield resourceTypeName.visualIdData();
    yield resourceValue.visualIdData();
    yield backgroundColor?.colorVisualIdData();
    yield blockLength.byteVisualIdData();
    yield notes?.visualIdData();
  }
}
