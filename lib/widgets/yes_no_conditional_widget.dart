import 'package:flutter/material.dart';

class YesNoConditionalInput extends StatefulWidget {
  final String label;
  final String? helper;
  final Function(String) onSubmit;

  const YesNoConditionalInput({
    super.key,
    required this.label,
    required this.onSubmit,
    this.helper,
  });

  @override
  State<YesNoConditionalInput> createState() => _YesNoConditionalInputState();
}

class _YesNoConditionalInputState extends State<YesNoConditionalInput> {
  String? selectedOption;
  final TextEditingController textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final showTextField = selectedOption == 'Sí';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: 18, color: Colors.black),
            children: [
              TextSpan(text: widget.label),
              if (widget.helper != null)
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Tooltip(
                    message: widget.helper!,
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
        ),
        const SizedBox(height: 12),
        DropdownMenu<String>(
          width: 400,
          initialSelection: selectedOption,
          onSelected: (value) => setState(() {
            selectedOption = value;
          }),
          dropdownMenuEntries: const [
            DropdownMenuEntry(value: 'Sí', label: 'Sí'),
            DropdownMenuEntry(value: 'No', label: 'No'),
          ],
        ),
        if (showTextField) ...[
          const SizedBox(height: 16),
          TextField(
            controller: textController,
            decoration: const InputDecoration(
              hintText: '¿Cuál?',
              border: OutlineInputBorder(),
            ),
          ),
        ],
        const SizedBox(height: 24),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            onPressed: selectedOption != null
                ? () {
              final result = selectedOption == 'Sí'
                  ? textController.text.trim()
                  : 'No';
              if (result.isNotEmpty) {
                widget.onSubmit(result);
              }
            }
                : null,
            child: const Text('Siguiente'),
          ),
        ),
      ],
    );
  }
}