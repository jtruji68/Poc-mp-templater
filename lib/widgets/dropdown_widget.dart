import 'package:flutter/material.dart';

class DropdownSelector extends StatefulWidget {
  final String label;
  final List<String> options;
  final bool allowsOtherAnswer;
  final String? helper;
  final Function(String) onSubmit;

  const DropdownSelector({
    super.key,
    required this.label,
    required this.options,
    required this.onSubmit,
    this.allowsOtherAnswer = false,
    this.helper,
  });

  @override
  State<DropdownSelector> createState() => _DropdownSelectorState();
}

class _DropdownSelectorState extends State<DropdownSelector> {
  String? selectedOption;
  final TextEditingController otherController = TextEditingController();

  List<String> get fullOptions {
    final opts = List<String>.from(widget.options);
    if (widget.allowsOtherAnswer && !opts.contains('Otro')) {
      opts.add('Otro');
    }
    return opts;
  }

  @override
  void dispose() {
    otherController.dispose();
    super.dispose();
  }

  Widget buildLabelWithHelper(String text, String? helperText) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: Text(text, style: const TextStyle(fontSize: 18))),
        if (helperText != null)
          Tooltip(
            message: helperText,
            child: Container(
              margin: const EdgeInsets.only(left: 8),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Text(
                'i',
                style: TextStyle(
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final showOtherField = selectedOption == 'Otro';

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
          dropdownMenuEntries: fullOptions
              .map((opt) => DropdownMenuEntry(value: opt, label: opt))
              .toList(),
        ),
        if (showOtherField) ...[
          const SizedBox(height: 16),
          TextField(
            controller: otherController,
            decoration: const InputDecoration(
              hintText: 'Especifica tu opción',
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
              final result = selectedOption == 'Otro'
                  ? otherController.text.trim()
                  : selectedOption!;
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