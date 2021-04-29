import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:tk8/util/log.util.dart';

enum QuestionType { multiChoice }

abstract class Question extends Equatable {
  QuestionType get type;
  String get id;

  const Question();

  factory Question.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    try {
      final type = map['type'];
      switch (type) {
        case 'multiple_choice_question':
          return MultiChoiceQuestion.fromMap(map);
        default:
          debugLogError(
              'failed to parse multi choice question due to invalid type $type $map');
          return null;
      }
    } catch (e) {
      debugLogError('failed to parse multi choice question $map', e);
      return null;
    }
  }
}

class MultiChoiceQuestion extends Question {
  @override
  final String id;
  final String description;
  final List<MultiChoiceQuestionAnswer> answers;

  @override
  QuestionType get type => QuestionType.multiChoice;

  @visibleForTesting
  const MultiChoiceQuestion({
    @required this.id,
    @required this.description,
    @required this.answers,
  })  : assert(id != null),
        assert(description != null),
        assert(answers != null);

  factory MultiChoiceQuestion.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    try {
      final answers = map['answers'] as List;
      return MultiChoiceQuestion(
        id: map['id'],
        description: map['description'],
        answers: answers
            .map((x) => MultiChoiceQuestionAnswer.fromMap(x))
            .where((a) => a != null)
            .toList(),
      );
    } on Exception catch (e) {
      debugLogError('failed to parse multi choice question $map', e);
      return null;
    }
  }

  @override
  List<Object> get props => [answers];

  @override
  bool get stringify => true;
}

abstract class QuestionAnswer extends Equatable {
  bool get isCorrect;
  const QuestionAnswer();
}

class MultiChoiceQuestionAnswer extends QuestionAnswer {
  final String id;
  final String description;
  @override
  final bool isCorrect;

  @visibleForTesting
  const MultiChoiceQuestionAnswer({
    this.id,
    this.description,
    this.isCorrect,
  });

  factory MultiChoiceQuestionAnswer.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    try {
      return MultiChoiceQuestionAnswer(
        id: map['id'],
        description: map['description'],
        isCorrect: map['is_correct'],
      );
    } on Exception catch (e) {
      debugLogError('failed to parse multi choice answer $map', e);
      return null;
    }
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [id, description, isCorrect];
}
