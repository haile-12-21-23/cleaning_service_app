import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool obSecureText;
  final TextInputType keyboardType;
  final void Function(String?)? onChanged;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final int maxLines;

  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.obSecureText,
    required this.keyboardType,
    this.onChanged,
    this.validator,
    this.maxLines = 1,
    this.focusNode,
    this.nextFocusNode
  });

  @override
  Widget build(BuildContext context) {
    final isSingleLine = maxLines == 1;

    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      obscureText: obSecureText,
      keyboardType: keyboardType,
      validator: validator,
      obscuringCharacter: "*",
      onChanged: onChanged,
      maxLines: maxLines,

      /// SINGLE LINE -> NEXT
      /// MULTI LINE -> NEW LINE
      textInputAction: isSingleLine
          ? TextInputAction.next
          : TextInputAction.newline,
      onFieldSubmitted: (_) {
        if (isSingleLine) {
          if (nextFocusNode != null) {
            FocusScope.of(context).requestFocus(nextFocusNode);
          } else {
            FocusScope.of(context).unfocus();
          }
        }
      },
      decoration: InputDecoration(labelText: label),
    );
  }
}
