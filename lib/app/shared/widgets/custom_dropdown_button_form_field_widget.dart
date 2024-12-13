import 'package:flutter/material.dart';

class CustomDropdownButtonFormFieldWidget extends StatelessWidget {
  final List<DropdownMenuItem<Object>>? items;
  final void Function(Object?)? onChanged;
  final String? labelText;
  final Color? color;
  final String? Function(Object?)? validator;

  const CustomDropdownButtonFormFieldWidget({
    super.key,
    required this.items,
    required this.onChanged,
    this.labelText,
    this.color,
    this.validator,
  });
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      key: key,
      focusColor: color,
      items: items,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: color),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide(color: color ?? Colors.grey)),
      ),
      dropdownColor: color,
      validator: validator,
    );
  }
}
