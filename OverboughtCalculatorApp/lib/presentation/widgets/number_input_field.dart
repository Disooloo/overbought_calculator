import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class NumberInputField extends StatefulWidget {
  final String label;
  final double? value;
  final ValueChanged<double?> onChanged;
  final String currencySymbol;

  const NumberInputField({
    super.key,
    required this.label,
    this.value,
    required this.onChanged,
    this.currencySymbol = '',
  });

  @override
  State<NumberInputField> createState() => _NumberInputFieldState();
}

class _NumberInputFieldState extends State<NumberInputField> {
  late TextEditingController _controller;
  bool _isEditing = false;

  String _formatNumber(double? number) {
    if (number == null || number == 0) return '';
    final formatter = NumberFormat('#,###.##');
    return formatter.format(number);
  }

  double? _parseNumber(String text) {
    if (text.isEmpty) return 0;
    final cleaned = text.replaceAll(RegExp(r'[^\d.]'), '');
    if (cleaned.isEmpty) return 0;
    return double.tryParse(cleaned);
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: _formatNumber(widget.value),
    );
  }

  @override
  void didUpdateWidget(NumberInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isEditing && oldWidget.value != widget.value) {
      _controller.text = _formatNumber(widget.value);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: widget.label,
        prefixText: widget.currencySymbol.isNotEmpty
            ? '${widget.currencySymbol} '
            : null,
        suffixIcon: widget.value != null && widget.value! > 0
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _controller.clear();
                  widget.onChanged(0);
                },
              )
            : null,
      ),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[\d.,]')),
        TextInputFormatter.withFunction((oldValue, newValue) {
          final text = newValue.text;
          if (text.isEmpty) return newValue;

          // Allow only one decimal point
          final parts = text.split('.');
          if (parts.length > 2) {
            return oldValue;
          }

          // Allow commas for thousands separator
          final cleaned = text.replaceAll(',', '');
          final number = double.tryParse(cleaned);
          if (number == null && text.isNotEmpty) {
            return oldValue;
          }

          return newValue;
        }),
      ],
      onTap: () {
        _isEditing = true;
      },
      onChanged: (text) {
        final number = _parseNumber(text);
        widget.onChanged(number);
      },
      onEditingComplete: () {
        _isEditing = false;
      },
    );
  }
}

