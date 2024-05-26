enum SelectionType {
  Single,
  Multiple,
  AtLeastOne,
}

class QuestionAnswer {
  final String question;
  final List<String>? answers;
  final List<List<String>>? pairs; // Add pairs field
  final SelectionType selectionType;
  final String questionId;
  final int? pageIndex;

  QuestionAnswer({
    required this.question,
    required this.answers,
    this.pairs,
    required this.selectionType,
    required this.questionId,
    required this.pageIndex,
  });
}
