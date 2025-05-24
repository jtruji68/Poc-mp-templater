import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/contract_form_state.dart';
import '../services/pdf_service.dart';

abstract class PdfState {}

class PdfInitial extends PdfState {}
class PdfGenerating extends PdfState {}
class PdfSuccess extends PdfState {
  final List<int> pdfBytes;
  PdfSuccess(this.pdfBytes);
}
class PdfFailure extends PdfState {
  final String error;
  PdfFailure(this.error);
}

class PdfCubit extends Cubit<PdfState> {
  PdfCubit() : super(PdfInitial());

  Future<void> generatePdf(ContractFormState formState) async {
    emit(PdfGenerating());
    try {
      final pdfBytes = await PdfService.generateContractPdf(formState);
      emit(PdfSuccess(pdfBytes));
    } catch (e) {
      emit(PdfFailure(e.toString()));
    }
  }
}