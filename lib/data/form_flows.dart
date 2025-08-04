import '../models/flow_configuration.dart';
import '../models/question.dart';

final tutelaSaludFlow = FlowConfiguration(
  templateKey: 'generateTutela1',
  questions: [

    Question(
      id: "q0",
      questionText: 'Selecciona el departamento y ciudad donde se va a presentar la tutela',
      inputType: InputType.cityDept,
      multipleFieldNames: ['depto_tutela', 'ciudad_tutela'],
    ),

    Question(
      id: 'q1',
      fieldName: 'tutela_para_quien',
      questionText: '¿Para quién es la tutela?',
      inputType: InputType.custom,
    ),

    //  si selecciona Para mi
    Question(
      id: 'q2',
      fieldName: 'nombre_autor',
      questionText: 'Escribe tu nombre completo',
      inputType: InputType.text,
      dependsOn: 'tutela_para_quien',
      visibleWhen: 'Para mí',
    ),
    Question(
      id: 'q3',
      fieldName: 'nombre_autor',
      questionText: 'Escribe tu nombre completo',
      inputType: InputType.text,
      dependsOn: 'tutela_para_quien',
      visibleWhen: 'Para mí',
    ),
    Question(
      id: 'q4',
      questionText: 'Escribe to número de identificación',
      fieldName: 'id_autor',
      inputType: InputType.text,
      dependsOn: 'tutela_para_quien',
      visibleWhen: 'Para mí',
    ),
    Question(
      id: "q5",
      questionText: 'Selecciona el departamento y ciudad donde solicitaste tu documento de identificación',
      inputType: InputType.cityDept,
      multipleFieldNames: ['id_autor_depto', 'id_autor_ciudad'],
      dependsOn: 'tutela_para_quien',
      visibleWhen: 'Para mí',
    ),
    Question(
      id: "q6",
      questionText: 'Selecciona el departamento y ciudad donde resides actualmente',
      inputType: InputType.cityDept,
      multipleFieldNames: ['id_autor_depto_res', 'id_autor_ciudad_res'],
      dependsOn: 'tutela_para_quien',
      visibleWhen: 'Para mí',
    ),
    Question(
      id: "q7",
      fieldName: 'edad_afectado',
      questionText: 'Escribe tu edad',
      inputType: InputType.text,
      dependsOn: 'tutela_para_quien',
      visibleWhen: 'Para mí',
    ),
    Question(
      id: "q8",
      fieldName: 'telefono_autor',
      questionText: 'Escribe tu telefono de contacto',
      inputType: InputType.text,
      dependsOn: 'tutela_para_quien',
      visibleWhen: 'Para mí',
    ),
    Question(
      id: "q9",
      fieldName: 'correo_autor',
      questionText: 'Escribe tu correo electrónico',
      inputType: InputType.text,
      dependsOn: 'tutela_para_quien',
      visibleWhen: 'Para mí',
    ),

    // fin de preguntas para mi

    Question(
      id: 'q10',
      questionText: '¿Cuál es el nombre del familiar?',
      fieldName: 'nombre_familiar',
      inputType: InputType.text,
      dependsOn: 'tutela_para_quien',
      visibleWhen: 'Para un familiar que no puede hacerla por sí mismo',
    ),
    Question(
      id: 'q11',
      questionText: '¿Número de identificación del familiar?',
      fieldName: 'id_familiar',
      inputType: InputType.text,
      dependsOn: 'tutela_para_quien',
      visibleWhen: 'Para un familiar que no puede hacerla por sí mismo',
    ),

    //Preguntas restantes

    Question(
      id: "q12",
      fieldName: 'eps',
      questionText: 'EPS',
      inputType: InputType.custom,
      allowsOtherAnswer: true
    ),
    Question(
      id: "q13",
      fieldName: 'regimen',
      questionText: '¿Cual es el regimen de afiliación de la EPS?',
      inputType: InputType.custom,
    ),

    Question(
      id: 'q14',
      fieldName: 'diagnostico',
      questionText: 'Cual es tu diagnostico',
      inputType: InputType.text,
    ),
    Question(
      id: 'q15',
      fieldName: 'servicios_medicos_exigidos',
      questionText: '¿Qué tratamiento, procedimiento o suministro '
          'de medicamento necesita actualmente y que fue ordenado '
          'por su médico tratante?',
      inputType: InputType.text,
    ),
    Question(
      id: 'q16',
      fieldName: 'grupo_especial',
      questionText: '¿Es usted adulto mayor, menor de edad, '
          'persona con discapacidad, víctima del conflicto o '
          'pertenece a población vulnerable?',
      inputType: InputType.custom,
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