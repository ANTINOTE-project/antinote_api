import 'package:antinote/src/helpers/enum_id.dart';

enum NewsQuestionAnswerType implements EnumId {
  receiptAcknowledgment(0),
  textual(1),
  singleChoice(2),
  multipleChoices(3),
  withoutReceiptAcknowledgment(4),
  withoutResponse(5);

  @override
  final int id;

  const NewsQuestionAnswerType(this.id);
}
