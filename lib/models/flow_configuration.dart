import 'question.dart';

class FlowConfiguration {
  final List<Question> questions;
  final String templateKey; // Used to select the correct PDF generator later

  FlowConfiguration({
    required this.questions,
    required this.templateKey,
  });
}