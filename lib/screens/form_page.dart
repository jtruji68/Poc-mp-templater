import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:jd_docgen_frontend/widgets/info_box_widget.dart';
import '../cubits/pdf_cubit.dart';
import '../cubits/question_flow_cubit.dart';
import '../cubits/theme_cubit.dart';
import '../models/flow_configuration.dart';
import '../models/question.dart';
import '../utils/web_download.dart';
import '../data/form_flows.dart';
import '../widgets/form_box_health_widget.dart';

class FormPage extends StatelessWidget {
  final String flowType;

  const FormPage({super.key, required this.flowType});

  @override
  Widget build(BuildContext context) {
    final FlowConfiguration config = getFlowByType(flowType);

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => QuestionFlowCubit(config.questions)),
        BlocProvider(create: (_) => PdfCubit()),
      ],
      child: Builder(
        builder: (context) {
          initializeDateFormatting('es');
          return Scaffold(
            appBar: AppBar(
              title: const Text('Generar Tutelas de Salud'),
              actions: [
                IconButton(
                  icon: Icon(Theme.of(context).brightness == Brightness.dark
                      ? Icons.dark_mode
                      : Icons.light_mode),
                  tooltip: 'Cambiar tema',
                  onPressed: () => context.read<ThemeCubit>().toggleTheme(),
                ),
              ],
            ),
            body: BlocConsumer<PdfCubit, PdfState>(
              listener: (context, state) {
                if (state is PdfFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error generando PDF: ${state.error}')),
                  );
                }
              },
              builder: (context, pdfState) {
                final isWeb = MediaQuery.of(context).size.width > 800;

                return Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Center(
                          child: Container(
                        constraints: isWeb
                        ? const BoxConstraints(maxWidth: 1300, maxHeight: 700)
                            : const BoxConstraints(maxWidth: 1400),
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                            child: isWeb
                                ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(child: FormBox(config: config, pdfState: pdfState)),
                                const SizedBox(width: 24),
                                Expanded(child: const InfoBox()),
                              ],
                            )
                                : Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                FormBox(config: config, pdfState: pdfState),
                                const SizedBox(height: 24),
                                const InfoBox(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text('¿Necesitas ayuda legal? Contáctanos.'),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}