import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tk8/data/models/chapter.model.dart';
import 'package:tk8/data/models/questions.model.dart';

class ChaptersTestsService {
  Set<String> _questionsAnsweredIds = {};
  Set<String> _completedChapterIds = {};

  final _questionsAnsweredIdsController =
      BehaviorSubject<Set<String>>.seeded({});

  Stream<Set<String>> get questionsAnsweredIdsStream =>
      _questionsAnsweredIdsController.stream;

  ChaptersTestsService() {
    _loadTestsInfo();
  }

  bool isQuestionAnswered(Question question) {
    return _questionsAnsweredIds.contains(question.id);
  }

  bool isChapterCompleted(Chapter chapter) {
    return _completedChapterIds.contains(chapter.id);
  }

  Future<void> setQuestionAnsered(Question question) async {
    if (isQuestionAnswered(question)) return;
    _questionsAnsweredIds.add(question.id);
    _questionsAnsweredIdsController.add(_questionsAnsweredIds);
    await _saveTestsInfo();
  }

  Future<void> setChapterCompleted(Chapter chapter) async {
    if (isChapterCompleted(chapter)) return;
    _completedChapterIds.add(chapter.id);
    await _saveTestsInfo();
  }

  Future<void> reset() async {
    _questionsAnsweredIds = {};
    _completedChapterIds = {};
    await _saveTestsInfo();
  }

  // private api

  Future<void> _saveTestsInfo() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(_questionsAnsweredIdsKey,
        _questionsAnsweredIds.map((id) => id).toList());
    prefs.setStringList(
        _completedChapterIdsKey, _completedChapterIds.map((id) => id).toList());
  }

  Future<void> _loadTestsInfo() async {
    final prefs = await SharedPreferences.getInstance();
    _questionsAnsweredIds =
        Set<String>.from(prefs.getStringList(_questionsAnsweredIdsKey) ?? []);
    _completedChapterIds =
        Set<String>.from(prefs.getStringList(_completedChapterIdsKey) ?? []);
  }
}

const _questionsAnsweredIdsKey = 'com.tk8.chapterTests.questionsAnswered';
const _completedChapterIdsKey = 'com.tk8.chapterTests.chaptersCompleted';
