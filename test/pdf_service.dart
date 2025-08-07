import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:jd_docgen_frontend/services/pdf_service.dart';


void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es', null);

  group('PDFService - Tutela generation', () {
    Future<void> runPdfTest({
      required String testName,
      required Map<String, dynamic> answers,
      required String filename,
    }) async {
      final pdfBytes = await PdfService.generateFromAnswers(answers, 'generateTutela1');

      final outputFile = File('test_output/$filename');
      await outputFile.create(recursive: true);
      await outputFile.writeAsBytes(pdfBytes);

      expect(await outputFile.exists(), isTrue);
      expect(await outputFile.length(), greaterThan(5000));
      print('✅ $testName - PDF generado en: ${outputFile.path}');
    }

    test('1. Para mi + grupo especial', () async {
      await runPdfTest(
        testName: 'Para mi + grupo especial',
        filename: 'tutela_para_mi_grupo_especial.pdf',
        answers: {
          'depto_tutela': 'Antioquia',
          'ciudad_tutela': 'Medellín',
          'tutela_para_quien': 'Para mí',
          'nombre_autor': 'Juan Pérez',
          'id_autor': '123456789',
          'id_autor_depto': 'Antioquia',
          'id_autor_ciudad': 'Medellín',
          'id_autor_depto_res': 'Antioquia',
          'id_autor_ciudad_res': 'Medellín',
          'edad_afectado': '34',
          'eps': 'Sura',
          'regimen': 'Régimen contributivo',
          'diagnostico': 'Lesión de rodilla severa',
          'servicios_medicos_exigidos': 'Cirugía de rodilla, rehabilitación, medicamentos',
          'grupo_especial': 'Indígena',
          'direccion_autor': 'Calle Falsa 123',

          'telefono_autor': '3001234567',
          'correo_autor': 'juan@example.com',
        },
      );
    });

    test('2. Para mi + sin grupo especial', () async {
      await runPdfTest(
        testName: 'Para mi + sin grupo especial',
        filename: 'tutela_para_mi_sin_grupo.pdf',
        answers: {
          'tutela_para_quien': 'Para mí',
          'ciudad_tutela': 'Medellín',
          'depto_tutela': 'Antioquia',
          'nombre_autor': 'Juan Pérez',
          'id_autor': '123456789',
          'id_autor_depto': 'Antioquia',
          'id_autor_ciudad': 'Medellín',
          'id_autor_depto_res': 'Antioquia',
          'id_autor_ciudad_res': 'Medellín',
          'eps': 'Sura',
          'regimen': 'Régimen contributivo',
          'edad_afectado': '34',
          'diagnostico': 'Lesión de rodilla severa',
          'servicios_medicos_exigidos': 'Cirugía de rodilla, rehabilitación, medicamentos',
          'grupo_especial': '',
          'direccion_autor': 'Calle Falsa 123',
          'telefono_autor': '3001234567',
          'correo_autor': 'juan@example.com',
        },
      );
    });

    test('3. Para otra persona + grupo especial', () async {
      await runPdfTest(
        testName: 'Para otra persona + grupo especial',
        filename: 'tutela_para_otro_grupo_especial.pdf',
        answers: {
          'tutela_para_quien': 'Para otra persona',
          'ciudad_tutela': 'Medellín',
          'depto_tutela': 'Antioquia',
          'nombre_autor': 'Juan Pérez',
          'id_autor': '123456789',
          'id_autor_depto': 'Antioquia',
          'id_autor_ciudad': 'Medellín',
          'id_autor_depto_res': 'Antioquia',
          'id_autor_ciudad_res': 'Medellín',
          'nombre_afectado': 'Carlos Ruiz',
          'id_afectado': '987654321',
          'id_afectado_depto': 'Antioquia',
          'id_afectado_ciudad': 'Medellín',
          'id_afectado_depto_res': 'Antioquia',
          'id_afectado_ciudad_res': 'Medellín',
          'edad_afectado': '70',
          'eps': 'Sura',
          'regimen': 'Régimen contributivo',
          'diagnostico': 'Insuficiencia renal crónica',
          'servicios_medicos_exigidos': 'Diálisis, medicamentos, atención domiciliaria',
          'grupo_especial': 'Indígena',
          'direccion_autor': 'Calle Falsa 123',
          'telefono_autor': '3001234567',
          'correo_autor': 'juan@example.com',
        },
      );
    });

    test('4. Para otra persona + sin grupo especial', () async {
      await runPdfTest(
        testName: 'Para otra persona + sin grupo especial',
        filename: 'tutela_para_otro_sin_grupo.pdf',
        answers: {
          'tutela_para_quien': 'Para otra persona',
          'ciudad_tutela': 'Medellín',
          'depto_tutela': 'Antioquia',
          'nombre_autor': 'Juan Pérez',
          'id_autor': '123456789',
          'id_autor_depto': 'Antioquia',
          'id_autor_ciudad': 'Medellín',
          'id_autor_depto_res': 'Antioquia',
          'id_autor_ciudad_res': 'Medellín',
          'nombre_afectado': 'Carlos Ruiz',
          'id_afectado': '987654321',
          'id_afectado_depto': 'Antioquia',
          'id_afectado_ciudad': 'Medellín',
          'id_afectado_depto_res': 'Antioquia',
          'id_afectado_ciudad_res': 'Medellín',
          'edad_afectado': '70',
          'eps': 'Sura',
          'regimen': 'Régimen contributivo',
          'diagnostico': 'Insuficiencia renal crónica',
          'servicios_medicos_exigidos': 'Diálisis, medicamentos, atención domiciliaria',
          'grupo_especial': '',
          'direccion_autor': 'Calle Falsa 123',
          'telefono_autor': '3001234567',
          'correo_autor': 'juan@example.com',
        },
      );
    });
  });
}