import '../models/flow_configuration.dart';
import '../models/question.dart';

final tutelaSaludFlow = FlowConfiguration(
  templateKey: 'generateTutela1',
  questions: [
    Question(
      id: 'q1',
      questionText: '¿Cuál es tu nombre completo?',
      fieldName: 'nombre',
      inputType: InputType.text,
    ),
    Question(
      id: 'q2',
      questionText: '¿Cuál es tu fecha de nacimiento?',
      fieldName: 'fechaNacimiento',
      inputType: InputType.date,
    ),
    Question(
      id: 'q3',
      questionText: '¿Das permiso?',
      fieldName: 'permiso',
      inputType: InputType.boolean,
    ),
  ],
);

FlowConfiguration getFlowByType(String type) {
  switch (type) {
    case 'tutela_salud':
      return tutelaSaludFlow;
    default:
      throw Exception('Unknown flow: $type');
  }
}