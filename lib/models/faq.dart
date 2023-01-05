class FAQ {
  FAQ({
    required this.id,
    required this.question,
    required this.answer,
  });

  late final int id;
  late final String question;
  late final String answer;
  bool isExpanded = false;

  FAQ.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    question = json['question'];
    answer = json['answer'];
    isExpanded = json['is_expanded'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['question'] = question;
    _data['answer'] = answer;
    _data['is_expanded'] = isExpanded;
    return _data;
  }
}
