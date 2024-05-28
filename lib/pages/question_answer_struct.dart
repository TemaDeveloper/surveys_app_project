class QuestionAnswer {
  final String questionId;
  final String question;
  final List<String> answers;
  final List<List<String>>? pairs;
  final int pageIndex;
  final SelectionType selectionType;

  QuestionAnswer({
    required this.questionId,
    required this.question,
    required this.answers,
    this.pairs,
    required this.pageIndex,
    required this.selectionType,
  });

  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'question': question,
      'answers': answers,
      'pairs': pairs,
      'pageIndex': pageIndex,
      'selectionType': selectionType.toString(),
    };
  }

  static QuestionAnswer fromJson(Map<String, dynamic> json) {
    return QuestionAnswer(
      questionId: json['questionId'],
      question: json['question'],
      answers: List<String>.from(json['answers']),
      pairs: json['pairs'] != null
          ? (json['pairs'] as List<dynamic>)
              .map((pair) => List<String>.from(pair))
              .toList()
          : null,
      pageIndex: json['pageIndex'],
      selectionType: SelectionType.values.firstWhere(
          (e) => e.toString() == json['selectionType']),
    );
  }
}

enum SelectionType {
  Single,
  Multiple,
  AtLeastOne,
}
