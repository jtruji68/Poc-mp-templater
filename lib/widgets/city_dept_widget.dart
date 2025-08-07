import 'package:flutter/material.dart';
import '../constants/colombia_geo.dart';

class DepartamentoCiudadSelector extends StatefulWidget {
  final void Function(Map<String, String> result) onSubmit;
  final String label;
  final String? helper;
  final List<String> fieldNames;

  const DepartamentoCiudadSelector({
    super.key,
    required this.onSubmit,
    required this.label,
    required this.fieldNames,
    this.helper,
  });

  @override
  State<DepartamentoCiudadSelector> createState() => _DepartamentoCiudadSelectorState();
}

class _DepartamentoCiudadSelectorState extends State<DepartamentoCiudadSelector> {
  String? selectedDepartamento;
  String? selectedCiudad;

  Widget buildLabelWithHelper(String text, String? helperText) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 18, color: Colors.black),
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
                      color: Colors.grey.shade300,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'i',
                      style: TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
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

  @override
  Widget build(BuildContext context) {
    final ciudades = selectedDepartamento != null ? colombiaGeo[selectedDepartamento] ?? [] : [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        buildLabelWithHelper(widget.label, widget.helper),
        const SizedBox(height: 20),

        const Text('Selecciona tu departamento', style: TextStyle(fontSize: 18)),
        const SizedBox(height: 8),
        Autocomplete<String>(
          optionsBuilder: (text) => colombiaGeo.keys
              .where((dpto) => dpto.toLowerCase().contains(text.text.toLowerCase()))
              .toList(),
          onSelected: (selection) {
            setState(() {
              selectedDepartamento = selection;
              selectedCiudad = null;
            });
          },
          fieldViewBuilder: (context, controller, focusNode, onEditingComplete) =>
              LayoutBuilder(
                builder: (context, constraints) => ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400, maxHeight: 500),
                  child: TextField(
                    controller: controller,
                    focusNode: focusNode,
                    decoration: const InputDecoration(
                      hintText: 'Departamento',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
          optionsViewBuilder: (context, onSelected, options) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 4.0,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400, maxHeight: 400),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
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
                .toList()
                .cast<String>(),
            onSelected: (selection) {
              setState(() {
                selectedCiudad = selection;
              });
            },
            fieldViewBuilder: (context, controller, focusNode, onEditingComplete) =>
                LayoutBuilder(
                  builder: (context, constraints) => ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400, maxHeight: 400),
                    child: TextField(
                      controller: controller,
                      focusNode: focusNode,
                      decoration: const InputDecoration(
                        hintText: 'Ciudad o Municipio',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
            optionsViewBuilder: (context, onSelected, options) {
              return Align(
                alignment: Alignment.topLeft,
                child: Material(
                  elevation: 4.0,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400, maxHeight: 300),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
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
            onPressed: selectedDepartamento != null && selectedCiudad != null
                ? () {
              final result = {
                widget.fieldNames[0]: selectedDepartamento!,
                widget.fieldNames[1]: selectedCiudad!,
              };
              widget.onSubmit(result);
            }
                : null,
            child: const Text('Siguiente'),
          ),
        ),
      ],
    );
  }
}