import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool obSecureText;
  final TextInputType keyboardType;
  final void Function(String?)? onChanged;
  final String? Function(String?)? validator;

  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.obSecureText,
    required this.keyboardType,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obSecureText,
      keyboardType: keyboardType,
      validator: validator,
      obscuringCharacter: "*",
      onChanged: onChanged,
      decoration: InputDecoration(labelText: label),
    );
  }
}
