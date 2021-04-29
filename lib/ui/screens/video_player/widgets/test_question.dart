import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import 'package:tk8/config/styles.config.dart';
import 'package:tk8/data/models/questions.model.dart';
import 'package:tk8/ui/widgets/widgets.dart';

import '../video_player.viewmodel.dart';

class QuestionView extends StatelessWidget {
  final int questionIndex;
  final Question question;

  const QuestionView({
    Key key,
    @required this.questionIndex,
    @required this.question,
  })  : assert(question != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (question.type) {
      case QuestionType.multiChoice:
        return MultiChoiceQuestionView(
          question: question,
          questionIndex: questionIndex,
        );
      default:
        throw Exception('Invalid question type');
    }
  }
}

class MultiChoiceQuestionView extends StatelessWidget {
  final int questionIndex;
  final MultiChoiceQuestion question;

  const MultiChoiceQuestionView({
    Key key,
    this.question,
    this.questionIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<VideoPlayerScreenViewModel>(
      builder: (context, model, child) {
        final size = MediaQuery.of(context).size;
        return Material(
          color: Colors.black,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  translate(
                    'chapterTests.testNumber',
                    args: {'number': questionIndex + 1},
                  ),
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontFamily: "RevxNeue",
                      fontStyle: FontStyle.normal,
                      fontSize: 12.0),
                  textAlign: TextAlign.center,
                ),
                const Space.vertical(12),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width / 8),
                  child: Text(
                    question.description,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontFamily: "RevxNeue",
                        fontStyle: FontStyle.normal,
                        fontSize: 21.0),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Space.vertical(36),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildOptionSelection(context, 'A', question.answers[0]),
                    const Space.horizontal(32),
                    _buildOptionSelection(context, 'B', question.answers[1]),
                  ],
                ),
                const Space.vertical(20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildOptionSelection(context, 'C', question.answers[2]),
                    const Space.horizontal(32),
                    _buildOptionSelection(context, 'D', question.answers[3]),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOptionSelection(
    BuildContext context,
    String name,
    MultiChoiceQuestionAnswer option,
  ) {
    final size = MediaQuery.of(context).size;
    final model = Provider.of<VideoPlayerScreenViewModel>(
      context,
      listen: false,
    );
    final highlight = model.lastAnswer == option;
    return Row(
      children: [
        Text(
          name,
          style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontFamily: "RevxNeue",
              fontStyle: FontStyle.normal,
              fontSize: 14.0),
        ),
        const Space.horizontal(8),
        SizedBox(
          width: size.width / 3,
          child: GestureDetector(
            onTap: () => _onSelectOption(context, option),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(2)),
                color: highlight ? TK8Colors.ocean : Colors.white,
              ),
              child: Center(
                child: Text(
                  option.description,
                  style: TextStyle(
                      color: highlight ? Colors.white : Colors.black,
                      fontWeight: highlight ? FontWeight.w700 : FontWeight.w500,
                      fontFamily: "Gotham",
                      fontStyle: FontStyle.normal,
                      fontSize: 14.0),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _onSelectOption(BuildContext context, MultiChoiceQuestionAnswer option) {
    final model = Provider.of<VideoPlayerScreenViewModel>(
      context,
      listen: false,
    );
    model.onAnswerQuestion(option);
  }
}
