import 'package:mock_data/mock_data.dart';
import 'package:tk8/data/models/questions.model.dart';

MultiChoiceQuestion mockMultiChoiceQuestionModel({
  String id,
  String description,
  List<MultiChoiceQuestionAnswer> answers,
}) {
  return MultiChoiceQuestion(
    id: id ?? mockUUID(),
    description: description ?? mockString(),
    answers: answers ??
        List<MultiChoiceQuestionAnswer>.generate(
            mockInteger(), (_) => mockMultiChoiceQuestionAnswerModel()),
  );
}

MultiChoiceQuestionAnswer mockMultiChoiceQuestionAnswerModel({
  String id,
  String description,
  bool isCorrect,
}) {
  return MultiChoiceQuestionAnswer(
    id: id ?? mockUUID(),
    description: description ?? mockString(),
    isCorrect: isCorrect ?? mockInteger(0, 1) == 1,
  );
}
