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
      Map<String, dynamic> answers, String templateKey) async {
    final doc = pw.Document();

    doc.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Documento generado: $templateKey',
                  style: pw.TextStyle(
                      fontSize: 22, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),

              // Dynamic field rendering
              ...answers.entries.map((entry) {
                final label = _prettifyLabel(entry.key);
                final value = entry.value;

                if (value is Map) {
                  // handle nested fields (like departamento_ciudad)
                  return pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: value.entries.map<pw.Widget>((sub) {
                      final subLabel = _prettifyLabel(sub.key);
                      return pw.Text('$subLabel: ${sub.value}');
                    }).toList(),
                  );
                } else {
                  return pw.Text('$label: $value');
                }
              }),
            ],
          );
        },
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