import 'package:flutter/material.dart';

class MyTextfield extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;
  final void Function(String)? onSubmitted;

  const MyTextfield({
    super.key, 
    required this.hintText, 
    required this.obscureText,
    required this.controller,
    this.onSubmitted,
  });



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: SizedBox(
        width: 100,
        child: TextField(
          obscureText: obscureText,
          controller: controller,
          onSubmitted: onSubmitted,
          maxLines: 5,
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: 
              BorderSide(color: Colors.black),
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: 
              BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(12),
        
            ),
            fillColor: Colors.white,
            filled: true,
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey.shade600),
          ),
        ),
      ),
    );
  }
}
