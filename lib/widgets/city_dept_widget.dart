import 'package:flutter/material.dart';

// Import your colombiaGeo map
import '../constants/colombia_geo.dart';

class DepartamentoCiudadSelector extends StatefulWidget {
  final void Function({required String departamento, required String ciudad}) onSubmit;

  const DepartamentoCiudadSelector({super.key, required this.onSubmit});

  @override
  State<DepartamentoCiudadSelector> createState() => _DepartamentoCiudadSelectorState();
}

class _DepartamentoCiudadSelectorState extends State<DepartamentoCiudadSelector> {
  String? selectedDepartamento;
  String? selectedCiudad;

  @override
  Widget build(BuildContext context) {
    final ciudades = selectedDepartamento != null ? colombiaGeo[selectedDepartamento] ?? [] : [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
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
                  constraints: const BoxConstraints(maxWidth: 400, maxHeight: 500,),
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
                  constraints: const BoxConstraints(maxWidth: 400, maxHeight: 400,),
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
                    constraints: const BoxConstraints(maxWidth: 400, maxHeight: 400,),
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
                    constraints: const BoxConstraints(maxWidth: 400,maxHeight: 300),
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
                ? () => widget.onSubmit(
              departamento: selectedDepartamento!,
              ciudad: selectedCiudad!,
            )
                : null,
            child: const Text('Siguiente'),
          ),
        ),
      ],
    );
  }
}