part of 'classes.dart';

final class const Activity({
  required final String title,
  required final List<String> attendants,
  required final String resourceTypeName,
  required final String resourceValue,
  required super.id,
  required super.backgroundColor,
  required super.startDate,
  required super.endDate,
  required super.blockLength,
  required super.blockSlot,
  required super.notes,
  required super.weekNumber,
  required super.studentCountString,
}) extends Class {
  factory Activity.decode(
    ClassMessage classMessage,
    MapJsonNavigator activity,
  ) => .new(
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
    studentCountString: classMessage.studentCountString,
  );

  @override
  String? get status => null;

  @override
  bool get canceled => false;

  @override
  List<ClassContent<dynamic>> get contents => [
    TitleContent(value: title, isTime: false),
    for (final attendant in attendants)
      PersonalContent(
        value: Person(
          name: attendant,
          id: null,
          type: null,
          place: null,
          withDiscussion: false,
        ),
      ),
  ];

  @override
  ClassType get type => .activity;

  @override
  Iterable<Uint8List?> collectVisualIdData() sync* {
    yield title.visualIdData();
    yield* attendants.visualIdData();
    yield resourceTypeName.visualIdData();
    yield resourceValue.visualIdData();
    yield backgroundColor?.colorVisualIdData();
    yield startDate.millisecondsSinceEpoch.bytesVisualIdData();
    yield endDate.millisecondsSinceEpoch.bytesVisualIdData();
  }
}
