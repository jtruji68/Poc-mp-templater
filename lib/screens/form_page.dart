import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../cubits/pdf_cubit.dart';
import '../cubits/question_flow_cubit.dart';
import '../cubits/theme_cubit.dart';
import '../models/flow_configuration.dart';
import '../models/question.dart';
import '../utils/web_download.dart';
import '../data/form_flows.dart';

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
              title: const Text('JustDigital'),
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
                final isWeb = MediaQuery.of(context).size.width > 600;

                return Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Center(
                          child: Container(
                        constraints: isWeb
                        ? const BoxConstraints(maxWidth: 1300, maxHeight: 600)
                            : const BoxConstraints(maxWidth: 1400),
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                            child: isWeb
                                ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(child: _buildFormBox(context, config, pdfState)),
                                const SizedBox(width: 24),
                                Expanded(child: _buildInfoBox(context)),
                              ],
                            )
                                : Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _buildFormBox(context, config, pdfState),
                                const SizedBox(height: 24),
                                _buildInfoBox(context),
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

  Widget _buildFormBox(BuildContext context, FlowConfiguration config, PdfState pdfState) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: BlocBuilder<QuestionFlowCubit, QuestionFlowState>(
        builder: (context, state) {
          final flowCubit = context.read<QuestionFlowCubit>();
          final pdfCubit = context.read<PdfCubit>();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (state.isCompleted && pdfState is! PdfSuccess) ...[
                const Text(
                  "Tus respuestas:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 12),
                ...config.questions.map((q) {
                  final answer = state.answers[q.fieldName];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text("• ${q.questionText}: $answer"),
                  );
                }),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text('Generar Documento'),
                  onPressed: () {
                    final answers = state.answers;
                    final templateKey = config.templateKey;
                    pdfCubit.generatePdfFromAnswers(answers, templateKey);
                  },
                ),
              ] else if (pdfState is PdfSuccess) ...[
                const SizedBox(height: 24),
                const Text('✅', textAlign:TextAlign.center,style: TextStyle(fontSize: 64,)),
                const SizedBox(height: 16),
                const Text(
                  'Este es tu documento para descargar, por favor revísalo.',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  icon: const Icon(Icons.download),
                  label: const Text('Descargar PDF'),
                  onPressed: () {
                    downloadFile(
                      Uint8List.fromList(pdfState.pdfBytes),
                      'documento_generado.pdf',
                      'application/pdf',
                    );
                  },
                ),
              ] else ...[
                ...config.questions
                    .asMap()
                    .entries
                    .where((entry) => entry.key < state.currentIndex)
                    .map((entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    "• ${entry.value.questionText}: ${state.answers[entry.value.fieldName]}",
                  ),
                )),
                const SizedBox(height: 16),
                _buildQuestionInput(
                  context,
                  question: config.questions[state.currentIndex],
                  onSubmit: (value) => flowCubit.submitAnswer(value),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildInfoBox(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : const Color(0xFFFFFBE6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('⚖️', style: TextStyle(fontSize: 64)),
          SizedBox(height: 24),
          Text(
            "Generación de Documentos Legales Rápido y Sencillo",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12),
          Text(
            "Este formulario genera documentos legales automáticamente. "
                "Responde las preguntas y descarga tu archivo.",
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionInput(
      BuildContext context, {
        required Question question,
        required Function(dynamic) onSubmit,
      }) {
    final controller = TextEditingController();
    switch (question.inputType) {
      case InputType.text:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(question.questionText, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  final value = controller.text.trim();
                  if (value.isNotEmpty) onSubmit(value);
                },
                child: const Text('Siguiente'),
              ),
            ),
          ],
        );

      case InputType.date:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(question.questionText, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  locale: const Locale('es', ''),
                  initialDate: DateTime(2000),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (picked != null) {
                  onSubmit(picked.toIso8601String().split('T')[0]);
                }
              },
              child: const Text('Seleccionar Fecha'),
            ),
          ],
        );

      case InputType.boolean:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(question.questionText, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => onSubmit(true),
                  child: const Text('Sí'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () => onSubmit(false),
                  child: const Text('No'),
                ),
              ],
            ),
          ],
        );
    }
  }
}