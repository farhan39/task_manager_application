import 'package:flutter/material.dart';

class CheckboxExample extends StatefulWidget {
  CheckboxExample({this.scalingFactor});

  final double? scalingFactor;
  @override
  _CheckboxExampleState createState() => _CheckboxExampleState();
}

class _CheckboxExampleState extends State<CheckboxExample> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: widget.scalingFactor ?? 1.0,
        child: Checkbox(
        value: isChecked,
        onChanged: (bool? value) {
          setState(() {
            isChecked = value ?? false; // Ensure to handle null safety
          });
        },
        checkColor: Colors.white, // The color of the check mark when checked
        fillColor: WidgetStateProperty.resolveWith<Color>(
              (Set<WidgetState> states) {
            if (states.contains(WidgetState.pressed)) {
              return Colors.white; // The background color when pressed
            }
            if (isChecked) {
              return Colors.black; // The background color when checked
            }
            return Colors.transparent; // The default background color
          },
        ),
        side: BorderSide(
          color: isChecked ? Colors.black : Colors.black, // Border color when checked or unchecked
          width: 2.0,
        ),
      )
    );
  }
}