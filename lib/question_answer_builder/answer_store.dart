class AnswerStore {
  static final AnswerStore _instance = AnswerStore._internal();

  factory AnswerStore() {
    return _instance;
  }

  AnswerStore._internal();

  final Map<String, List<String>?> _answers = {};

  void saveAnswer(String questionId, List<String>? answers) {
    _answers[questionId] = answers;
  }

  List<String> getAnswer(String questionId) {
    return _answers[questionId] ?? [];
  }
}