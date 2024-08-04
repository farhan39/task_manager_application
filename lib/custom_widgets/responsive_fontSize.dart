import 'package:flutter/material.dart';

class ResponsiveText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color? color;
  final TextAlign? textAlign;
  final FontWeight? fontWeight;
  final bool? lineThrough;

  ResponsiveText({
    required this.text,
    required this.fontSize,
    required this.color,
    this.textAlign,
    this.fontWeight,
    this.lineThrough = false,
  });

  double getResponsiveFontSize(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double baseWidth = 375.0; // Define a base width for your design
    return fontSize * (screenWidth / baseWidth);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.5), // Limit the width of the text
      child: Text(
        text,
        maxLines: 10,
        style: TextStyle(
          decoration: lineThrough ?? false ? TextDecoration.lineThrough : TextDecoration.none,
          color: color,
          fontSize: getResponsiveFontSize(context),
          fontWeight: fontWeight ?? FontWeight.normal,
          decorationThickness: lineThrough ?? false ? 3 : 1,
          decorationColor: lineThrough ?? false ? Colors.black : null, // Set the color for the line-through
        ),
        textAlign: textAlign ?? TextAlign.start,
      ),
    );
  }
}
