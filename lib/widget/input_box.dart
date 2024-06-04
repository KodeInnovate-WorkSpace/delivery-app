import 'package:flutter/material.dart';

class InputBox extends StatefulWidget {
  final String hintText;
  final IconData myIcon;
  final TextEditingController myController;

  const InputBox(
      {super.key,
      required this.hintText,
      required this.myIcon,
      required this.myController});

  @override
  State<InputBox> createState() => _InputBoxState();
}

class _InputBoxState extends State<InputBox> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: TextFormField(
        controller: widget.myController,
        cursorColor: Colors.black,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.normal),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14.0),
            borderSide: const BorderSide(color: Colors.black),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14.0),
            borderSide: const BorderSide(color: Colors.black),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14.0),
            borderSide: const BorderSide(color: Colors.black),
          ),
          filled: true,
          fillColor: Colors.white,
          prefixIcon: Icon(widget.myIcon),
        ),
      ),
    );
  }
}
