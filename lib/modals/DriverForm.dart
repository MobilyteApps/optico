class DriverForm {
  var question;

  var answer;

  var comment;

  DriverForm({this.question, this.answer, this.comment});

  factory DriverForm.fromJson(Map<String, dynamic> parsedJson) {
    return DriverForm(question: parsedJson['question'], answer: parsedJson['answer'], comment: parsedJson['comment']);
  }

  setCheckValue(var value) {
    answer = value;
  }

  setCommentValue(String value){
    comment = value;
  }

  Map<String, dynamic> toJson() => {'question': question, 'answer': answer, 'comment': comment};
}
