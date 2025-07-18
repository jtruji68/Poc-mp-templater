// lib/models/question.dart
enum InputType { text, date, boolean }

class Question {
  final String id;
  final String questionText;
  final String fieldName; // For mapping to form state
  final InputType inputType;

  Question({
    required this.id,
    required this.questionText,
    required this.fieldName,
    required this.inputType,
  });
}