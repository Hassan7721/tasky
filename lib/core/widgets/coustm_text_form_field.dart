import 'package:flutter/material.dart';

class CoustmTextFormField extends StatelessWidget {
  const CoustmTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.title,
    this.validator,
    this.maxLines,
  });
  final TextEditingController controller;
  final int? maxLines;
  final String title;
  final String hintText;
  final Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: 
        Theme.of(context).textTheme.titleMedium,
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          style: Theme.of(context).textTheme.labelMedium,

          maxLines: maxLines,
          validator: validator != null
              ? (String? value) => validator!(value)
              : null,
          decoration: InputDecoration(hintText: hintText),
        ),
      ],
    );
  }
}
