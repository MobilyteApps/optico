class Coupling {
  String name;
  String radioValue;
  int check;

  Coupling({this.name, this.radioValue, this.check});

  factory Coupling.fromJson(Map<String, dynamic> parsedJson) {
    return Coupling(
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
