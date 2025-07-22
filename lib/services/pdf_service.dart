import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../models/contract_form_state.dart';

class PdfService {
  /// Original static method for fixed contract model


  static Future<List<int>> generateContractPdf(ContractFormState data) async {
    final doc = pw.Document();

    doc.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Contrato PoC',
                style: pw.TextStyle(
                    fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 20),
            pw.Text('Nombres: ${data.firstName}'),
            pw.Text('Apellidos: ${data.lastName}'),
            pw.Text('Email: ${data.email}'),
            pw.Text(
              'Fecha de nacimiento: ${data.dateOfBirth?.toLocal().toIso8601String().split("T").first}',
            ),
            pw.SizedBox(height: 10),
            pw.Text(data.permissionGiven
                ? 'El usuario ha dado el permiso para X.'
                : 'El usuario NO ha dado el permiso para X.'),
          ],
        ),
      ),
    );

    return doc.save();
  }

  static Future<List<int>> generateFromAnswers(
      Map<String, dynamic> answers,
      String templateKey,
      ) async {


    final doc = pw.Document();
    final cambriaFont = pw.Font.ttf(await rootBundle.load('assets/fonts/cambria.ttf'));
    final calibriFont = pw.Font.ttf(await rootBundle.load('assets/fonts/calibri.ttf'));

    final pw.TextStyle textStyleTitle = pw.TextStyle(
      fontSize: 14,font: calibriFont, fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex('#366091')
    );

    final pw.TextStyle textStyleParag = pw.TextStyle(
      fontSize: 11,font: cambriaFont,
    );

    // Only build this template if it's for the person themselves
    if (answers['tutela_para_quien'] != 'Para mí') {
      doc.addPage(
        pw.Page(
          build: (_) => pw.Center(
            child: pw.Text('Este documento solo aplica si la tutela es para ti.'),
          ),
        ),
      );
      return doc.save();
    }

    final ciudad = answers['departamento_ciudad']?['ciudad'] ?? 'Ciudad';
    final departamento = answers['departamento_ciudad']?['departamento'] ?? 'Departamento';
    final nombre = answers['nombre_autor'] ?? 'Nombre completo';
    final cedula = answers['id_autor'] ?? 'Número de cédula';
    final eps = answers['eps'] ?? 'Nombre de la EPS';
    final regimen = answers['regimen'] ?? '[contributivo/subsidiado]';
    final orden = answers['orden_medica'] ?? '[Describe lo ordenado]';
    final fechaEspera = answers['fecha_espera'] ?? 'Fecha exacta o aproximada';
    final correo = answers['mail'] ?? 'Correo electrónico';
    final telefono = answers['telefono'] ?? 'Número de celular';
    final hechos = answers['hechos'] ?? 'Relato de los hechos';
    final formattedDate = DateFormat('d \'de\' MMMM \'de\' y', 'es').format(DateTime.now());
    final String epsCorreo = answers['eps_correo'] ?? '';



    doc.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Paragraph(text: "ACCIÓN DE TUTELA - DERECHO A LA SALUD\n",style: textStyleTitle),
          pw.Paragraph(
            text: '$ciudad, $formattedDate',
            style: textStyleParag,
          ),
          pw.Paragraph(text: '''
          

Señor(a)
JUEZ CONSTITUCIONAL (REPARTO)
$ciudad - $departamento
E.S.D.

Referencia: ACCIÓN DE TUTELA – Solicitud de protección de derechos fundamentales a la salud, vida digna e integridad personal
        ''', style: textStyleParag),
          pw.Paragraph(text: '''
Yo, $nombre, mayor de edad, identificado(a) con cédula de ciudadanía No. $cedula, domiciliado(a) en la ciudad de $ciudad, actuando en nombre propio, me permito presentar acción de tutela con fundamento en el artículo 86 de la Constitución Política y el Decreto 2591 de 1991, con el fin de obtener la protección urgente de mis derechos fundamentales a la salud, a la vida digna, y a la integridad física, los cuales han sido vulnerados por la omisión de mi entidad promotora de salud (EPS).
        ''', style: textStyleParag),
          pw.Header(level: 1, text: 'I. HECHOS', textStyle: textStyleTitle),
          pw.Paragraph(text: '1. Me encuentro afiliado(a) a la EPS $eps, en el régimen $regimen.', style: textStyleParag),
          pw.Paragraph(text: '2. Me fue ordenado el siguiente tratamiento/servicio/procedimiento: $orden.', style: textStyleParag),
          pw.Paragraph(text: '3. Desde el $fechaEspera estoy esperando que me entreguen dicho servicio, sin respuesta oportuna.', style: textStyleParag),
          pw.Paragraph(text: '4. He intentado obtener respuesta pero no he recibido solución, lo cual ha deteriorado mi salud y bienestar.', style: textStyleParag),
          pw.Paragraph(text: '5. Esta situación afecta gravemente mi calidad de vida.', style: textStyleParag),
          pw.Paragraph(text: hechos, style: textStyleParag),

          pw.Header(level: 1, text: 'II. DERECHOS VULNERADOS', textStyle: textStyleTitle),
          pw.Paragraph(text: '1. Derecho a la salud (arts. 48 y 49 C.P)', style: textStyleParag),
          pw.Paragraph(text: '2. Derecho a la vida digna (art. 1 y 11 C.P.)', style: textStyleParag),
          pw.Paragraph(text: '3. Derecho a la integridad personal (art. 12 C.P.)', style: textStyleParag),
          pw.Paragraph(text: '4. Derecho a la seguridad social (art. 48 C.P.)', style: textStyleParag),

          pw.Header(level: 1, text: 'III. PETICIÓN', textStyle: textStyleTitle),
          pw.Paragraph(text: '1. Tutele mis derechos fundamentales invocados.', style: textStyleParag),
          pw.Paragraph(text: '2. Ordene a la EPS $eps que en un plazo no mayor a 48 horas me autorice y entregue el siguiente servicio: $orden.', style: textStyleParag),
          pw.Paragraph(text: '3. Ordene que se garantice la prestación integral del servicio de salud.', style: textStyleParag),

          pw.Header(level: 1, text: 'IV. JURAMENTO', textStyle: textStyleTitle),
          pw.Paragraph(text: 'Declaro bajo juramento que no he presentado otra acción de tutela por los mismos hechos y derechos.', style: textStyleParag),

          pw.Header(level: 1, text: 'V. PRUEBAS', textStyle: textStyleTitle),
          pw.Paragraph(text: '1. Copia de la cédula.', style: textStyleParag),
          pw.Paragraph(text: '2. Copia de la orden médica.', style: textStyleParag),
          pw.Paragraph(text: '3. Historia clínica reciente.', style: textStyleParag),
          pw.Paragraph(text: '4. Derecho de petición presentado (si lo hay).', style: textStyleParag),
          pw.Paragraph(text: '5. Respuesta de la EPS (si existe).', style: textStyleParag),
          pw.Header(level: 1, text: 'VI. NOTIFICACIONES', textStyle: textStyleTitle),

          if (epsCorreo.isNotEmpty)
            pw.Paragraph(text: '''
EPS ACCIONADA:
$epsCorreo
''', style: textStyleParag),
          pw.Paragraph(text: '''


ACCIONANTE:
$nombre
Dirección: $ciudad, $departamento
Teléfono: $telefono
Correo electrónico: $correo

Respetuosamente,

_________________________
$nombre
C.C. No. $cedula de $ciudad
        ''', style: textStyleParag),
        ],
      ),
    );

    return doc.save();
  }

  /// Helper to make field names look nicer
  static String _prettifyLabel(String key) {
    return key
        .replaceAll('_', ' ')
        .replaceAllMapped(RegExp(r'(^\w|\s\w)'), (m) => m.group(0)!.toUpperCase());
  }
}