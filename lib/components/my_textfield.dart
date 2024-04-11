import 'package:flutter/material.dart';

class LSTextField extends StatefulWidget {
  final controller;
  final String hintText;
  bool obscureText;
  final bool noButton;
  
  LSTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.noButton,
    });

  @override
  State<LSTextField> createState() => _LSTextFieldState();
}

class _LSTextFieldState extends State<LSTextField> {

  void _toggle() {
    setState(() {
      widget.obscureText = !widget.obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: widget.controller,
        obscureText: widget.obscureText,
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black), 
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          fillColor: Colors.white,
          filled: true,
          hintText: widget.hintText,
          hintStyle: TextStyle(color: Colors.grey[500]),
          suffixIcon: widget.noButton
            ? null
            : Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                  primary: Colors.black,
                ),
              ),
              child: IconButton(
                onPressed: _toggle,
                icon: widget.obscureText
                    ? Icon(Icons.visibility)
                    : Icon(Icons.visibility_off),
                ),
            ),
        ),
      ),
    );
  }
}