import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String? labelText;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final Color? labelColor;
  final void Function()? onTap;

  const CustomTextFormField({
    super.key,
    this.controller,
    this.keyboardType,
    this.inputFormatters,
    this.validator,
    this.labelColor,
    this.labelText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        labelStyle: TextStyle(color: labelColor),
      ),
      validator: validator,
    );
  }
}
