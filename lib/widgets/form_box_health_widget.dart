import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jd_docgen_frontend/constants/colombia_geo.dart';

import '../cubits/pdf_cubit.dart';
import '../cubits/question_flow_cubit.dart';
import '../models/flow_configuration.dart';
import '../models/question.dart';
import '../utils/web_download.dart';

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
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text("Tus respuestas:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 12),
                ...visibleQuestions.map((q) {
                  final answer = state.answers[q.fieldName];
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
            );
          } else if (pdfState is PdfSuccess) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 24),
                const Text('✅', textAlign: TextAlign.center, style: TextStyle(fontSize: 64)),
                const SizedBox(height: 16),
                const Text('Este es tu documento para descargar, por favor rev\u00edsalo.', style: TextStyle(fontSize: 18), textAlign: TextAlign.center),
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
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ...currentVisibleQuestions.map((q) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text("\u2022 ${q.questionText}: ${state.answers[q.fieldName] ?? ''}"),
                )),
                const SizedBox(height: 16),
                _buildQuestionInput(context, question: currentQuestion, onSubmit: (value) => flowCubit.submitAnswer(value)),
              ],
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

    switch (question.fieldName) {
      case 'departamento_ciudad':
        String? selectedDepartamento;
        String? selectedCiudad;

        return StatefulBuilder(
          builder: (context, setState) {
            final ciudades = selectedDepartamento != null ? colombiaGeo[selectedDepartamento] ?? [] : [];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Selecciona tu departamento', style: TextStyle(fontSize: 18)),
                const SizedBox(height: 8),
                Autocomplete<String>(
                  optionsBuilder: (text) => colombiaGeo.keys.where((dpto) => dpto.toLowerCase().contains(text.text.toLowerCase())),
                  onSelected: (selection) {
                    setState(() {
                      selectedDepartamento = selection;
                      selectedCiudad = null;
                    });
                  },
                  fieldViewBuilder: (context, controller, focusNode, onEditingComplete) =>
                      TextField(controller: controller, focusNode: focusNode, decoration: const InputDecoration(hintText: 'Departamento', border: OutlineInputBorder())),
                  optionsViewBuilder: (context, onSelected, options) {
                    return Align(
                      alignment: Alignment.topLeft,
                      child: Material(
                        elevation: 4,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 300),
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: options.length,
                            itemBuilder: (context, index) {
                              final option = options.elementAt(index);
                              return ListTile(
                                title: Text(option),
                                onTap: () => onSelected(option),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                if (selectedDepartamento != null) ...[
                  const Text('Selecciona tu ciudad o municipio', style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 8),
                  Autocomplete<String>(
                    optionsBuilder: (text) => ciudades
                        .where((c) => c.toLowerCase().contains(text.text.toLowerCase()))
                        .cast<String>(),                    onSelected: (selection) => setState(() => selectedCiudad = selection),
                    fieldViewBuilder: (context, controller, focusNode, onEditingComplete) =>
                        TextField(controller: controller, focusNode: focusNode, decoration: const InputDecoration(hintText: 'Ciudad o Municipio', border: OutlineInputBorder())),
                    optionsViewBuilder: (context, onSelected, options) {
                      return Align(
                        alignment: Alignment.topLeft,
                        child: Material(
                          elevation: 4,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 300),
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              itemCount: options.length,
                              itemBuilder: (context, index) {
                                final option = options.elementAt(index);
                                return ListTile(
                                  title: Text(option),
                                  onTap: () => onSelected(option),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: selectedDepartamento != null && selectedCiudad != null ? () => onSubmit({ 'departamento': selectedDepartamento, 'ciudad': selectedCiudad }) : null,
                    child: const Text('Siguiente'),
                  ),
                ),
              ],
            );
          },
        );

      case 'tutela_para_quien':
        return _dropdownMenu(question.questionText, ['Para mí', 'Para un familiar que no puede hacerla por sí mismo'], onSubmit);

      case 'relacion_con_familiar':
        return _dropdownMenu(question.questionText, ['mamá', 'papá', 'hijo', 'abuelo', 'hermano', 'primo', 'tio'], onSubmit);

      case 'orden_juez':
        return _dropdownMenu(question.questionText, ['Que me den el medicamento', 'Que autoricen la cirugía', 'Que me atiendan en casa'], onSubmit);

      case 'eps':
        return _dropdownMenu(question.questionText, ['Sura', 'Nueva EPS'], onSubmit);

      case 'regimen':
        return _dropdownMenu(question.questionText, ['Régimen contributivo', 'Régimen subsidiado'], onSubmit);

      default:
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
          case InputType.custom:
            return const Text('Custom field not handled');
        }
    }
  }

  Widget _dropdownMenu(String label, List<String> options, Function(String) onSubmit) {
    String? selectedOption;

    return StatefulBuilder(
      builder: (context, setState) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(label, style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 12),
          DropdownMenu<String>(
            width: 400,
            initialSelection: selectedOption,
            onSelected: (value) => setState(() => selectedOption = value),
            dropdownMenuEntries: options.map((opt) => DropdownMenuEntry(value: opt, label: opt)).toList(),
          ),
          const SizedBox(height: 24),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: selectedOption != null ? () => onSubmit(selectedOption!) : null,
              child: const Text('Siguiente'),
            ),
          ),
        ],
      ),
    );
  }
}