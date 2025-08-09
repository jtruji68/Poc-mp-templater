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

  Widget buildLabelWithHelper(String text, String? helperText) {
    // Inherit themed text color and size
    final baseStyle = DefaultTextStyle.of(context).style.copyWith(fontSize: 18);

    // Helper badge colors adapt to theme
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final badgeBg = isDark ? Colors.white24 : Colors.grey.shade300;
    final badgeFg = Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black87;

    return RichText(
      text: TextSpan(
        style: baseStyle,
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

  @override
  Widget build(BuildContext context) {
    final showTextField = selectedOption == 'Sí';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        buildLabelWithHelper(widget.label, widget.helper),
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