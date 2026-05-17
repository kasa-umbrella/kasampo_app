import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.decoration,
    this.maxLines = 1,
    this.textInputAction = TextInputAction.done,
    this.onSubmitted,
  });

  final TextEditingController? controller;
  final InputDecoration? decoration;
  final int? maxLines;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: decoration,
      maxLines: maxLines,
      textInputAction: textInputAction,
      onSubmitted: onSubmitted ?? (_) => FocusScope.of(context).unfocus(),
    );
  }
}