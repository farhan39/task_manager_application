import 'package:flutter/material.dart';

class CheckboxExample extends StatefulWidget {
  final double? scalingFactor;
  final bool isChecked;
  final ValueChanged<bool?>? onChanged; // Callback function

  CheckboxExample({
    this.scalingFactor,
    required this.isChecked,
    this.onChanged, // Initialize callback function
  });

  @override
  _CheckboxExampleState createState() => _CheckboxExampleState();
}

class _CheckboxExampleState extends State<CheckboxExample> {
  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: widget.scalingFactor ?? 1.0,
      child: Checkbox(
        value: widget.isChecked,
        onChanged: widget.onChanged,
        checkColor: Colors.white, // The color of the check mark when checked
        fillColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.white; // The background color when pressed
            }
            if (widget.isChecked) {
              return Colors.black; // The background color when checked
            }
            return Colors.transparent; // The default background color
          },
        ),
        side: BorderSide(
          color: widget.isChecked ? Colors.black : Colors.black, // Border color when checked or unchecked
          width: 2.0,
        ),
      ),
    );
  }
}
