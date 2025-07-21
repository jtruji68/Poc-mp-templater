enum InputType {
  text,
  date,
  boolean,
  custom,
}

class Question {
  final String id;
  final String questionText;
  final String fieldName;
  final InputType inputType;

  final String? dependsOn; // 👈 New: fieldName of the dependency
  final dynamic visibleWhen; // 👈 New: condition for showing the question

  Question({
    required this.id,
    required this.questionText,
    required this.fieldName,
    required this.inputType,
    this.dependsOn,
    this.visibleWhen,
  });
}