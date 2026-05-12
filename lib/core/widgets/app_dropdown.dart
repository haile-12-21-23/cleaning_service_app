import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppDropdown extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> items;
  final void Function(String?) onChanged;
  final String? Function(String?)? validator;

  const AppDropdown({
    super.key,
    required this.label,
    this.value,
    required this.items,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DropdownButtonFormField<String>(
        validator: validator,
        padding: EdgeInsets.zero,
        initialValue: value,
        decoration: InputDecoration(labelText: label),

        items: items.map((role) {
          return DropdownMenuItem(
            alignment: AlignmentGeometry.centerStart,
            value: role,
            child: Text(role),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
