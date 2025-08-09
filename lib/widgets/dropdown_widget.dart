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
  final TextEditingController dropdownController = TextEditingController(); // ✨ manually resettable

  @override
  void initState() {
    super.initState();
    selectedOption = null;
    dropdownController.clear(); // ✨ force reset value
  }

  @override
  void didUpdateWidget(DropdownSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.label != widget.label) {
      // ✨ reset everything if label (i.e. the question) changes
      selectedOption = null;
      dropdownController.clear();
      otherController.clear();
    }
  }

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
    dropdownController.dispose();
    super.dispose();
  }

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

  @override
  Widget build(BuildContext context) {
    final showOtherField = selectedOption == 'Otro';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        buildLabelWithHelper(widget.label, widget.helper),
        const SizedBox(height: 12),
        DropdownMenu<String>(
          width: 400,
          initialSelection: null,
          controller: dropdownController, // ✨ ensure external reset
          onSelected: (value) {
            setState(() {
              selectedOption = value;
              if (value != 'Otro') {
                otherController.clear(); // just in case
              }
            });
          },
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