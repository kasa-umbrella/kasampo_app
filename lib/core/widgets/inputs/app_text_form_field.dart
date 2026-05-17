import 'package:flutter/material.dart';

class AppTextFormField extends StatelessWidget {
  const AppTextFormField({
    super.key,
    this.controller,
    this.decoration,
    this.maxLines = 1,
    this.textInputAction = TextInputAction.done,
    this.onFieldSubmitted,
    this.validator,
  });

  final TextEditingController? controller;
  final InputDecoration? decoration;
  final int? maxLines;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onFieldSubmitted;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: decoration,
      maxLines: maxLines,
      textInputAction: textInputAction,
      onFieldSubmitted:
          onFieldSubmitted ?? (_) => FocusScope.of(context).unfocus(),
      validator: validator,
    );
  }
}