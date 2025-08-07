enum InputType {
  text,
  date,
  boolean,
  cityDept, // NEW
  dropdown,
  yesOrNo,
}

class Question {
  final String id;
  final String questionText;
  final InputType inputType;
  final String fieldName; // for single-field questions
  final List<String>? multipleFieldNames; // for compound inputs like dept/city
  final String? dependsOn;
  final String? visibleWhen;
  final bool allowsOtherAnswer;
  final String? helper;

  Question({
    required this.id,
    required this.questionText,
    required this.inputType,
    this.fieldName = "",
    this.multipleFieldNames,
    this.dependsOn,
    this.visibleWhen,
    this.allowsOtherAnswer = false,
    this.helper,
  });
}