class QuestionAnswer {
  final String question;
  final List<String> answers;
  final bool isMultipleChoice;
  final String questionId;
  final int pageIndex;

  QuestionAnswer({
    required this.question,
    required this.answers,
    required this.isMultipleChoice,
    required this.questionId,
    required this.pageIndex,
  });
}
