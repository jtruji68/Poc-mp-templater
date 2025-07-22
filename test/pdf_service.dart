import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:jd_docgen_frontend/services/pdf_service.dart';

void main() async {
  // ✅ Inicializa los bindings de Flutter
  TestWidgetsFlutterBinding.ensureInitialized();

  // ✅ Inicializa los datos de fecha para el locale 'es'
  await initializeDateFormatting('es', null);

  test('Generate tutela PDF for user (Para mí)', () async {
    final answers = {
      'tutela_para_quien': 'Para mí',
      'departamento_ciudad': {
        'departamento': 'Antioquia',
        'ciudad': 'Medellín',
      },
      'nombre_autor': 'Juan Pérez',
      'id_autor': '123456789',
      'eps': 'Sura',
      'regimen': 'Régimen contributivo',
      'orden_medica': 'Cirugía de rodilla',
      'fecha_espera': '2024-06-01',
      'telefono': '3001234567',
      'mail': 'juan@example.com',
      'hechos': 'He solicitado en múltiples ocasiones la atención requerida sin recibir respuesta.',
    };

    final pdfBytes = await PdfService.generateFromAnswers(answers, 'generateTutela1');

    final outputFile = File('test_output/tutela_para_mi_test.pdf');
    await outputFile.create(recursive: true);
    await outputFile.writeAsBytes(pdfBytes);

    expect(await outputFile.exists(), isTrue);
    expect(await outputFile.length(), greaterThan(5000));

    print('✅ PDF generado en: ${outputFile.path}');
  });
}