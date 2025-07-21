import '../models/flow_configuration.dart';
import '../models/question.dart';

final tutelaSaludFlow = FlowConfiguration(
  templateKey: 'generateTutela1',
  questions: [
    Question(
      id: "q1",
      fieldName: 'departamento_ciudad',
      questionText: 'Selecciona tu departamento y ciudad',
      inputType: InputType.custom, // we already have it
    ),
    Question(
      id: 'q2',
      fieldName: 'tutela_para_quien',
      questionText: '¿Para quién es la tutela?',
      inputType: InputType.custom, // dropdown: Para mí, Para un familiar que no puede hacerla por sí mismo
    ),
    Question(
      id: 'q3',
      fieldName: 'relacion_con_familiar',
      questionText: '¿Qué relación tienes con esa persona?',
      inputType: InputType.custom, // dropdown: mamá, papá, hijo, abuelo, hermano, tio
      dependsOn: 'tutela_para_quien',
      visibleWhen: 'Para un familiar que no puede hacerla por sí mismo',
    ),
    Question(
      id: 'q4',
      questionText: '¿Cuál es el nombre del familiar?',
      fieldName: 'nombre_familiar',
      inputType: InputType.text,
      dependsOn: 'tutela_para_quien',
      visibleWhen: 'Para un familiar que no puede hacerla por sí mismo',
    ),
    Question(
      id: 'q5',
      questionText: '¿Número de identificación del familiar?',
      fieldName: 'id_familiar',
      inputType: InputType.text,
      dependsOn: 'tutela_para_quien',
      visibleWhen: 'Para un familiar que no puede hacerla por sí mismo',
    ),
    Question(
      id: 'q6',
      questionText: 'Nombre Completo de quien diligencia',
      fieldName: 'nombre_autor',
      inputType: InputType.text,
    ),

    Question(
      id: 'q7',
      questionText: 'Número de identificación de quien diligencia',
      fieldName: 'id_autor',
      inputType: InputType.text,
    ),

    Question(
      id: 'q8',
      fieldName: 'orden_medica',
      questionText: '¿Qué te ordenó el médico y no te han dado?',
      inputType: InputType.text,
    ),
    Question(
      id: 'q9',
      questionText: '¿Desde cuándo estás esperando ese servicio o medicamento?',
      fieldName: 'fecha_espera',
      inputType: InputType.date, // we already have i think but with other name
    ),

    Question(
      id: "q10",
      fieldName: 'orden_juez',
      questionText: '¿Qué quieres que ordene el juez?',
      inputType: InputType.custom, // dropdown: Que me den el medicamento, Que autoricen la cirugía, Que me atiendan en casa
    ),
    Question(
      id: "q11",
      fieldName: 'eps',
      questionText: 'EPS',
      inputType: InputType.custom, // dropdown: Sura, Nueva EPS
    ),
    Question(
      id: "q12",
      fieldName: 'regimen',
      questionText: 'Regimen',
      inputType: InputType.custom, // dropdown: Régimen contributivo, Régimen subsidiado
    ),
    Question(
      id: 'q13',
      fieldName: 'hechos',
      questionText: 'Cuenta brevemente qué ha pasado (relato de los hechos)',
      inputType: InputType.text,
    ),
    Question(
      id: 'q14',
      fieldName: 'telefono',
      questionText: 'Teléfono',
      inputType: InputType.text,
    ),
    Question(
      id: 'q15',
      fieldName: 'mail',
      questionText: 'Correo',
      inputType: InputType.text,
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