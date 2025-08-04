import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfService {
  static Future<List<int>> generateFromAnswers(
      Map<String, dynamic> answers,
      String templateKey,
      ) async {
    final doc = pw.Document();
    final cambriaFont = pw.Font.ttf(await rootBundle.load('assets/fonts/cambria.ttf'));
    final calibriFont = pw.Font.ttf(await rootBundle.load('assets/fonts/calibri.ttf'));
    final cambriaBoldFont = pw.Font.ttf(await rootBundle.load('assets/fonts/cambria-bold.ttf'));
    final calibriBoldFont = pw.Font.ttf(await rootBundle.load('assets/fonts/calibri-bold.ttf'));

    final titleStyle = pw.TextStyle(
      fontSize: 14,
      font: calibriFont,
      fontWeight: pw.FontWeight.bold,
    );

    final bodyStyle = pw.TextStyle(
      fontSize: 11,
      font: cambriaFont,
    );
    final subtitleStyle = pw.TextStyle(
      fontSize: 12,
      font: cambriaBoldFont,
    );

    final mainTitleStyle = pw.TextStyle(
      fontSize: 14,
      font: calibriBoldFont,
    );

    // RespuestasEsperadas

    final ciudadTutela = answers["ciudad_tutela"] ?? "CiudadTutela";
    final departamentoTutela = answers['depto_tutela'] ?? 'DepartamentoTutela';
    final bool esTutelaParaAutor = answers['tutela_para_quien'] == 'Para mí';
    final fechaPresentacionTutela = answers['fecha_tutela'] == '';
    final diagnostico = answers['diagnostico'] ?? '';


    //Aqui van las respuestas del autor

    String autorNombre = answers['nombre_autor'] ?? 'Nombre completo autor';
    String autorCedula = answers['id_autor'] ?? 'Número de cédula';
    String autorResidenciaDepto = answers['id_autor_depto_res'] ?? 'depto de residencia del autor';
    String autorResidenciaCiudad = answers['id_autor_ciudad_res'] ?? 'ciudad de residencia del autor';

    //

    final eps = answers['eps'] ?? 'Nombre de la EPS';
    final regimen = answers['regimen'].split(" ")[1].toLowerCase();
    final serviciosExigidos = answers['servicios_medicos_exigidos'] ?? '';
    final grupoEspecialAlQuePertenence = answers['grupo_especial'] ?? '';

    final direccion = answers['direccion_autor'] ?? '';

    final correo = answers['correo_autor'] ?? 'Correo electrónico';
    final telefono = answers['telefono_autor'] ?? 'Número de celular';




    // if estutelaParaAutor

    String afectadoNombre = "";
    String afectadoCedula = "";
    String afectadoCedulaDepto = "";
    String afectadoCedulaCiudad = "";
    String afectadoResidenciaDepto = "";
    String afectadoResidenciaCiudad = "";
    String edadAfectado = "";

    String intro, hechos, peticion1, peticion2, peticion3 = "";

    if(esTutelaParaAutor){
      afectadoNombre = answers['nombre_autor'] ?? 'Nombre completo';
      afectadoCedula = answers['id_autor'] ?? 'Número de cédula';
      afectadoCedulaDepto = answers['id_autor_depto'] ?? 'depto de la cedula del autor';
      afectadoCedulaCiudad = answers['id_autor_ciudad'] ?? 'ciudad de la cedula del autor';
      afectadoResidenciaDepto = answers['id_autor_depto_res'] ?? 'depto de residencia del autor';
      afectadoResidenciaCiudad = answers['id_autor_ciudad_res'] ?? 'ciudad de residencia del autor';
      edadAfectado = answers['edad_afectado'] ?? '99';

      intro = 'Yo, $afectadoNombre, mayor de edad, identificado(a) con cédula de ciudadanía No. $afectadoCedula, domiciliado(a) en la ciudad de $afectadoResidenciaCiudad, actuando en nombre propio, me permito presentar acción de tutela con fundamento en el artículo 86 de la Constitución Política y el Decreto 2591 de 1991, con el fin de obtener la protección urgente de mis derechos fundamentales a la salud, vida digna e integridad personal, los cuales han sido vulnerados por la omisión de mi entidad promotora de salud $eps.';
      hechos = '\n1. Me encuentro afiliado(a) a la EPS $eps, en el régimen $regimen.\n\n2. Tengo $edadAfectado años y fui diagnosticado con $diagnostico.\n\n3. El médico tratante me ordenó la prestación de los siguientes servicios médicos: $serviciosExigidos.\n\n4. Pese a la orden médica y a las múltiples solicitudes realizadas, la EPS no ha materializado oportunamente los servicios médicos requeridos.\n\n5. Esta omisión ha generado un deterioro progresivo de mi salud, afectando mi vida digna, bienestar físico y emocional.\n\n6. No cuento con los recursos económicos para adquirir directamente estos servicios de forma particular, lo que aumenta mi situación de vulnerabilidad.';
      if (grupoEspecialAlQuePertenence.isNotEmpty) {
        hechos += ' Pertenezco a un grupo de especial protección constitucional, soy parte de $grupoEspecialAlQuePertenence, lo cual implica una mayor obligación del Estado en garantizar mis derechos fundamentales. Esta condición refuerza la necesidad de una respuesta urgente y efectiva por parte de la entidad accionada, conforme a los principios de igualdad material y enfoque diferencial consagrados en la Constitución Política y desarrollados por la jurisprudencia constitucional.';
      }
      peticion1 = '\n1. TUTELAR mis derechos fundamentales invocados.';
      peticion2 = '2. ORDENAR a la EPS $eps que, dentro de las cuarenta y ocho (48) horas siguientes, realice todas las gestiones necesarias para autorizar, suministrar y/o entregar efectivamente los servicios médicos requeridos consistentes en $serviciosExigidos en las cantidades y periodicidad ordenadas por el médico tratante.';
      peticion3 = '3. ORDENAR que la entrega de dichos insumos sea continua, prioritaria y sin imponer barreras administrativas que dilaten o interrumpan la atención.';

    }else {

      afectadoNombre = answers['nombre_afectado'] ?? 'Nombre completo de afectado';
      afectadoCedula = answers['id_afectado'] ?? 'Número de cédula afectado';
      afectadoCedulaDepto = answers['id_afectado_depto'] ?? 'depto de la cedula del afectado';
      afectadoCedulaCiudad = answers['id_afectado_ciudad'] ?? 'ciudad de la cedula del afectado';
      afectadoResidenciaDepto = answers['id_afectado_depto_res'] ?? 'depto de residencia del afectado';
      afectadoResidenciaCiudad = answers['id_afectado_ciudad_res'] ?? 'ciudad de residencia del afectado';
      edadAfectado = answers['edad_afectado'] ?? '99';

      intro = 'Yo, $autorNombre, mayor de edad, identificado(a) con cédula de ciudadanía No. $autorCedula, domiciliado(a) en la ciudad de $autorResidenciaCiudad, actuando como agente oficioso de $afectadoNombre, identificado(a) con cédula de ciudadanía No. $afectadoCedula acudo respetuosamente ante su Despacho para promover ACCIÓN DE TUTELA, de conformidad con el artículo 86 de la Constitución Política y los Decretos 2591 de 1991 y 1382 de 2000, con el fin de que se protejan los derechos fundamentales vulnerados por la EPS $eps.';
      hechos = '\n1. Mi agenciado se encuentra afiliado(a) a la EPS $eps, en el régimen $regimen.\n\n2. Tiene $edadAfectado años y fue diagnosticado con $diagnostico.\n\n3. El médico tratante le ordenó la prestación de los siguientes servicios médicos: $serviciosExigidos. Pese a la orden médica y a las múltiples solicitudes realizadas, la EPS no ha materializado oportunamente los servicios médicos requeridos.\n\n4. Esta omisión ha generado un deterioro progresivo en la salud del agenciado, afectando su vida digna, bienestar físico y emocional.\n\n5. No contamos con los recursos económicos para adquirir directamente estos servicios de forma particular, lo que aumenta la situación de vulnerabilidad.';
      if (grupoEspecialAlQuePertenence.isNotEmpty) {
        hechos += ' El afectado pertenece a un grupo de especial protección constitucional, es $grupoEspecialAlQuePertenence, lo cual implica una mayor obligación del Estado en garantizar sus derechos fundamentales. Esta condición refuerza la necesidad de una respuesta urgente y efectiva por parte de la entidad accionada, conforme a los principios de igualdad material y enfoque diferencial consagrados en la Constitución Política y desarrollados por la jurisprudencia constitucional.';
      }
      peticion1 = '1. Que se tutele el derecho fundamental a la salud, vida y dignidad humana de $afectadoNombre.';
      peticion2 = '2. Que se ordene a $eps la entrega de $serviciosExigidos.';
    }

    doc.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Text('ACCIÓN DE TUTELA - DERECHO A LA SALUD', style: mainTitleStyle),
          pw.Text('$ciudadTutela, $fechaPresentacionTutela'),
          pw.Text('Señor(a)', style: bodyStyle),
          pw.Text('JUEZ CONSTITUCIONAL (REPARTO)', style: subtitleStyle),
          pw.Paragraph(
              text: '$ciudadTutela - $departamentoTutela\nE.S.D.\n\nReferencia: ACCIÓN DE TUTELA – Solicitud de protección de derechos fundamentales a la salud, vida digna e integridad personal',
              style: bodyStyle),
          pw.Paragraph(text: intro, style: bodyStyle),
          pw.Center(child: pw.Text('I. HECHOS\n', style: subtitleStyle)),
          pw.Paragraph(text: hechos, style: bodyStyle),
          pw.Center(child: pw.Text('II. DERECHOS VULNERADOS\n', style: subtitleStyle)),
          pw.Paragraph(text: '\nConsidero vulnerados los siguientes derechos fundamentales:', style: bodyStyle),
          pw.Bullet(text: 'Derecho a la salud (arts. 48 y 49 C.P. y Ley Estatutaria 1751 de 2015)', style: bodyStyle),
          pw.Bullet(text: 'Derecho a la vida digna (art. 1 y 11 C.P.)', style: bodyStyle),
          pw.Bullet(text: 'Derecho a la integridad personal (art. 12 C.P.)', style: bodyStyle),
          pw.Center(child: pw.Text( '\nIII. FUNDAMENTOS JURÍDICOS\n', style: subtitleStyle)),
          pw.Paragraph(text: '\nEn el marco del Estado Social de Derecho consagrado por la Constitución Política de Colombia, la salud constituye no solo una aspiración legítima, sino una finalidad esencial del Estado, conforme a lo previsto en el artículo 2º, en concordancia con el artículo 49, inciso primero. En esa medida, el Estado, y por ende las entidades que conforman el Sistema General de Seguridad Social en Salud, están obligadas a garantizar la protección efectiva de este derecho, especialmente cuando su omisión compromete la dignidad humana.', style: bodyStyle), // you can replace with full paragraphs as needed
          pw.Paragraph(text: 'Considero que la conducta omisiva desplegada por la EPS , al abstenerse de garantizar de manera oportuna e integral el servicio médico prescrito por el profesional tratante, configura una vulneración real y/o una amenaza inminente de los derechos constitucionales fundamentales a la salud, reconocido como derecho fundamental autónomo por la Corte Constitucional, en conexidad con los derechos a la vida (art. 11 C.P.), a la integridad física (art. 12).', style: bodyStyle),
          pw.Paragraph(text: 'Tal como lo ha reiterado la jurisprudencia constitucional, el derecho a la salud adquiere carácter fundamental, bien sea de manera autónoma, en tanto existe un marco normativo claro y vinculante para su exigibilidad judicial, o por su conexidad con otros derechos fundamentales, cuando su inobservancia o prestación inadecuada compromete gravemente el goce efectivo de estos últimos.:', style: bodyStyle),
          pw.Paragraph(text: 'En consecuencia, se justifica plenamente la interposición de la presente acción constitucional de tutela como mecanismo preferente e idóneo para obtener el amparo inmediato, efectivo y eficaz de los derechos fundamentales amenazados o vulnerados, y para evitar consecuencias irreparables en la esfera jurídica de una persona que se encuentra en situación de particular vulnerabilidad y requiere con urgencia la intervención del juez constitucional.:', style: bodyStyle),
          pw.Center(child:pw.Text('IV. PETICIÓN\n', style: subtitleStyle) ),
          pw.Paragraph(text: peticion1, style: bodyStyle),
          pw.Paragraph(text: peticion2, style: bodyStyle),
          if (peticion3.isNotEmpty) pw.Paragraph(text: peticion3, style: bodyStyle),
          pw.Center(child: pw.Text('V. JURAMENTO\n', style: subtitleStyle)),
          pw.Paragraph(text: '\nBajo la gravedad de Juramento manifiesto, no haber instaurado otra Acción de Tutela con fundamento en los mismos hechos y derechos y en contra de la misma Entidad a que se contrae la presente, ante ninguna Autoridad Judicial (Artículo 10 Decreto 2591 de 1991).', style: bodyStyle),
          pw.Center(child :(pw.Text('VI. PRUEBAS\n', style: subtitleStyle))),
          pw.Bullet(text: 'Copia de la cédula.', style: bodyStyle),
          pw.Bullet(text: 'Copia de la orden médica.', style: bodyStyle),
          pw.Bullet(text: 'Historia clínica reciente.', style: bodyStyle),
          pw.Center( child: pw.Text('VII. NOTIFICACIONES\n', style: subtitleStyle)),
          pw.Paragraph(text: '\nACCIONANTE:\n\n\n\nDirección: $direccion, $autorResidenciaCiudad $autorResidenciaDepto,\nTeléfono: $telefono\nCorreo electrónico: $correo\n\nRespetuosamente,\n\n_________________________\n$autorNombre\nC.C. No. $autorCedula de $autorResidenciaCiudad, $autorResidenciaDepto', style: bodyStyle),
        ],
      ),
    );

    return doc.save();
  }
}