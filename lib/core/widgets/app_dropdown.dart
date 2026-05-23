import 'package:flutter/material.dart';

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
    // return DropdownButtonFormField<String>(
    //   isDense: true,
    //   validator: validator,
    //   padding: EdgeInsets.zero,
    //   initialValue: value,
    //   decoration: InputDecoration(
    //     labelText: label,
    //     contentPadding: const EdgeInsets.symmetric(
    //       horizontal: 16,
    //       vertical: 14,
    //     ),
    //   ),
    //   itemHeight: 60,

    //   items: items.map((role) {
    //     return DropdownMenuItem(
    //       alignment: AlignmentGeometry.centerStart,
    //       value: role,
    //       child: Padding(
    //         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    //         child: Text(role),
    //       ),
    //     );
    //   }).toList(),
    //   onChanged: onChanged,
    // );
    // return DropdownMenu<String>(
    //   controller: _cont,
    //   label: Text(label),
    //   width: double.infinity,
    //   initialSelection: value,
    //   menuStyle: MenuStyle(
    //     padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 16)),
    //     maximumSize: WidgetStatePropertyAll(
    //       Size(
    //         (MediaQuery.widthOf(context)) - 32,
    //         MediaQuery.heightOf(context) * 0.3,
    //       ),
    //     ),
    //     shape: WidgetStatePropertyAll(
    //       RoundedRectangleBorder(
    //         borderRadius: BorderRadiusGeometry.circular(12),
    //       ),
    //     ),
    //   ),
    //   onSelected: onChanged,
    //   dropdownMenuEntries: items.map((role) {
    //     return DropdownMenuEntry(value: role, label: role);
    //   }).toList(),

    //   inputDecorationTheme: const InputDecorationTheme(
    //     contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    //   ),
    // );

    return FormField<String>(
      initialValue: value,
      validator: validator,

      builder: (field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownMenu<String>(
              width: double.infinity,
              label: Text(label),

              initialSelection: field.value,
              menuStyle: MenuStyle(
                padding: WidgetStatePropertyAll(
                  EdgeInsets.symmetric(horizontal: 16),
                ),
                maximumSize: WidgetStatePropertyAll(
                  Size(
                    (MediaQuery.widthOf(context)) - 32,
                    MediaQuery.heightOf(context) * 0.3,
                  ),
                ),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(12),
                  ),
                ),
              ),

              onSelected: (value) {
                field.didChange(value);

                onChanged.call(value);
              },

              dropdownMenuEntries: items.map((item) {
                return DropdownMenuEntry(value: item, label: item);
              }).toList(),
            ),

            if (field.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 6, left: 12),
                child: Text(
                  field.errorText!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
