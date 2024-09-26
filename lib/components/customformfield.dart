import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key,
      required this.hint,
      required this.mycont,
      required this.valid});
  final String? Function(String?) valid;
  final String hint;
  final TextEditingController mycont;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: valid,
      controller: mycont,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(10),
        hintText: hint,
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
