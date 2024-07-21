import 'package:flutter/material.dart';
import 'package:task_quill/custom_widgets/checkbox.dart';
import 'package:task_quill/custom_widgets/responsive_fontSize.dart';

class HomeTaskDisplay extends StatefulWidget {
  HomeTaskDisplay({Key? key, required this.title, required this.description, this.lineThrough = false});

  final String title, description;
  final bool? lineThrough;
  //final BuildContext curr_context;

  @override
  State<HomeTaskDisplay> createState() => _HomeTaskDisplay();
}

class _HomeTaskDisplay extends State<HomeTaskDisplay> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: MediaQuery.of(context).size.width * 0.05,
        right: MediaQuery.of(context).size.width * 0.05,
        bottom: MediaQuery.of(context).size.height * 0.02,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.black,
          width: 1,
        ),
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).size.width * 0.02),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CheckboxExample(scalingFactor: 1.4),
              Padding(
                padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
                child: Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ResponsiveText(
                        text: widget.title,
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        lineThrough: widget.lineThrough,
                      ),
                      ResponsiveText(
                        text: widget.description,
                        fontSize: 18,
                        color: Colors.black,
                        lineThrough: widget.lineThrough,
                      ),
                    ],
                  ),
                ),
              ),
              Spacer(),
              Transform.scale(
                scale: 1.3,
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.edit_note_rounded),
                  alignment: Alignment.topRight,
                ),
              ),
              Transform.scale(
                scale: 1.3,
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.delete_outline_rounded),
                  alignment: Alignment.topRight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
