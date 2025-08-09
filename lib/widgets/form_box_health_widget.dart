import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jd_docgen_frontend/widgets/yes_no_conditional_widget.dart';
import '../cubits/pdf_cubit.dart';
import '../cubits/question_flow_cubit.dart';
import '../models/flow_configuration.dart';
import '../models/question.dart';
import '../utils/web_download.dart';
import 'city_dept_widget.dart';
import 'dropdown_widget.dart';

class FormBox extends StatelessWidget {
  final FlowConfiguration config;
  final PdfState pdfState;

  const FormBox({super.key, required this.config, required this.pdfState});

  @override
  Widget build(BuildContext context) {
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

          final visibleQuestions = config.questions.where((q) {
            if (q.dependsOn != null && q.visibleWhen != null) {
              return state.answers[q.dependsOn] == q.visibleWhen;
            }
            return true;
          }).toList();

          final currentVisibleQuestions = visibleQuestions.take(state.currentIndex);

          if (state.isCompleted && pdfState is! PdfSuccess) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text("Tus respuestas:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 12),
                  ...visibleQuestions.map((q) {
                    final answer = () {
                      if (q.multipleFieldNames != null && q.multipleFieldNames!.isNotEmpty) {
                        return q.multipleFieldNames!
                            .map((k) => state.answers[k])
                            .where((v) => v != null)
                            .join(', ');
                      } else {
                        return state.answers[q.fieldName] ?? '—';
                      }
                    }();
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text("\u2022 ${q.questionText}: $answer"),
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
                ],
              ),
            );
          } else if (pdfState is PdfSuccess) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 24),
                const Text('✅', textAlign: TextAlign.center, style: TextStyle(fontSize: 64)),
                const SizedBox(height: 16),
                const Text('Este es tu documento para descargar, por favor revísalo.', style: TextStyle(fontSize: 18), textAlign: TextAlign.center),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  icon: const Icon(Icons.download),
                  label: const Text('Descargar PDF'),
                  onPressed: () {
                    final pdfBytes = (pdfState as PdfSuccess).pdfBytes;
                    downloadFile(Uint8List.fromList(pdfBytes), 'documento_generado.pdf', 'application/pdf');
                  },
                ),
              ],
            );
          } else {
            final currentQuestion = visibleQuestions[state.currentIndex];
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ...currentVisibleQuestions.map((q) {
                    String answer;

                    if (q.multipleFieldNames != null && q.multipleFieldNames!.isNotEmpty) {
                      // Collect each individual field answer
                      answer = q.multipleFieldNames!
                          .map((fieldName) => state.answers[fieldName]?.toString())
                          .where((value) => value != null && value.isNotEmpty)
                          .join(', ');
                    } else {
                      answer = state.answers[q.fieldName]?.toString() ?? '—';
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: SelectableText("• ${q.questionText}: $answer"),
                    );
                  }),
                  const SizedBox(height: 16),




                  _buildQuestionInput(
          context,
          question: currentQuestion,
          onSubmit: (value) {
            if (value is Map<String, dynamic>) {
              flowCubit.submitAnswer(value); // Send all key-value pairs in 1 go
            } else {
              flowCubit.submitAnswer(value);
            }
          print(value);
          },
          ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildQuestionInput(BuildContext context, {
    required Question question,
    required Function(dynamic) onSubmit,
  }) {
    final controller = TextEditingController();

    Widget buildLabelWithHelper(String text, String? helperText) {
      // Inherit the current themed default text style, then tweak the size
      final baseStyle = DefaultTextStyle.of(context).style.copyWith(fontSize: 18);

      // Make the helper badge adapt to theme
      final isDark = Theme.of(context).brightness == Brightness.dark;
      final badgeBg = isDark ? Colors.white24 : Colors.grey.shade300;
      final badgeFg = Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black87;

      return RichText(
        text: TextSpan(
          style: baseStyle, // <- themed color now
          children: [
            TextSpan(text: text),
            if (helperText != null)
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: Tooltip(
                  message: helperText,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: badgeBg,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'i',
                        style: baseStyle.copyWith(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          color: badgeFg,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    }

    switch (question.inputType) {
      case InputType.yesOrNo:
        return YesNoConditionalInput(
          label: question.questionText,
          helper: question.helper,
          onSubmit: onSubmit,
        );
      case InputType.cityDept:
        return DepartamentoCiudadSelector(
          onSubmit: onSubmit,
          label: question.questionText,
          helper: question.helper,
          fieldNames: question.multipleFieldNames ?? ['departamento', 'ciudad'],
        );
      case InputType.dropdown:
        switch (question.fieldName) {
          case 'tutela_para_quien':
            return DropdownSelector(
              label: question.questionText,
              options: ['Para mí', 'Para un familiar que no puede hacerla por sí mismo'],
              onSubmit: onSubmit,
              helper: question.helper,
            );
          case 'relacion_con_familiar':
            return DropdownSelector(
              label: question.questionText,
              options: ['mamá', 'papá', 'hijo', 'abuelo', 'hermano', 'primo', 'tio'],
              onSubmit: onSubmit,
              helper: question.helper,
            );
          case 'orden_juez':
            return DropdownSelector(
              label: question.questionText,
              options: ['Que me den el medicamento', 'Que autoricen la cirugía', 'Que me atiendan en casa'],
              onSubmit: onSubmit,
              helper: question.helper,
            );
          case 'eps':
            return DropdownSelector(
              label: question.questionText,
              options: [
                'Sura', 'Nueva EPS', 'EPS Sanitas', 'Salud Total', 'Coosalud',
                'Savia Salud', 'Emssanar', 'Asmet Salud', 'Famisanar', 'Otro'
              ],
              onSubmit: onSubmit,
              helper: question.helper,
            );
          case 'regimen':
            return DropdownSelector(
              label: question.questionText,
              options: ['Régimen contributivo', 'Régimen subsidiado'],
              onSubmit: onSubmit,
              helper: question.helper,
            );
          default:
            return const Text('Campo dropdown no manejado');
        }
      case InputType.text:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildLabelWithHelper(question.questionText, question.helper),
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
            buildLabelWithHelper(question.questionText, question.helper),
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
            buildLabelWithHelper(question.questionText, question.helper),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: () => onSubmit(true), child: const Text('Sí')),
                const SizedBox(width: 20),
                ElevatedButton(onPressed: () => onSubmit(false), child: const Text('No')),
              ],
            ),
          ],
        );
    }
  }
}