import 'package:pdf/widgets.dart' as pw;

import '../models/contract_form_state.dart';

class PdfService {
  static Future<List<int>> generateContractPdf(ContractFormState data) async {
    final doc = pw.Document();

    doc.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Contrato PoC', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 20),
            pw.Text('Nombres: ${data.firstName}'),
            pw.Text('Apellidos: ${data.lastName}'),
            pw.Text('Email: ${data.email}'),
            pw.Text('Fecha de nacimiento: ${data.dateOfBirth?.toLocal().toIso8601String().split("T").first}'),
            pw.SizedBox(height: 10),
            pw.Text(data.permissionGiven
                ? 'El usuario ha dado el permiso para X.'
                : 'El usuario NO ha dado el permiso para X.'),
          ],
        ),
      ),
    );

    return doc.save(); // returns as Uint8List (List<int>)
  }
}