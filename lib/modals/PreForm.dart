class PreForm {
  String name;

  int check;

  String comment;

  PreForm({this.name, this.check, this.comment});

  factory PreForm.fromJson(Map<String, dynamic> parsedJson) {
    return PreForm(name: parsedJson['name'], check: parsedJson['check'], comment: parsedJson['comment']);
  }

  setCheckValue(int value) {
    check = value;
  }

  setCommentValue(String value){
    comment = value;
  }

  Map<String, dynamic> toJson() => {'name': name, 'check': check, 'comment' : comment};
}
