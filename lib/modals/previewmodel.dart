class PreviewModel {
  String name;
  String radioValue;
  int check;

  PreviewModel({this.name, this.radioValue, this.check});

  factory PreviewModel.fromJson(Map<String, dynamic> parsedJson) {
    return PreviewModel(
        name: parsedJson['name'],
        radioValue: parsedJson['radioValue'],
        check: parsedJson['check']);
  }

  set radioButtonValue(String value) {
    radioValue = value;
  }

  Map<String, dynamic> toJson() =>
      {'name': name, 'radioValue': radioValue, 'check': check};
}
