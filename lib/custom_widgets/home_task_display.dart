import 'package:flutter/material.dart';
import 'package:task_quill/Models/task_info.dart';
import 'package:task_quill/custom_widgets/checkbox.dart';

class HomeTaskDisplay extends StatefulWidget {
  const HomeTaskDisplay({
    Key? key,
    required this.task,
    required this.onCheckboxChanged,
    required this.onEditPressed,
    required this.onDeletePressed,
  }) : super(key: key);

  final Task task; // Use Task object instead of individual attributes
  final ValueChanged<bool?> onCheckboxChanged;
  final VoidCallback onEditPressed;
  final VoidCallback onDeletePressed;

  @override
  State<HomeTaskDisplay> createState() => _HomeTaskDisplayState();
}

class _HomeTaskDisplayState extends State<HomeTaskDisplay> {
  @override
  Widget build(BuildContext context) {

    final bool isCompleted = widget.task.isCompleted == 1;

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
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CheckboxExample(
                scalingFactor: 1.4,
                isChecked: isCompleted,
                onChanged: isCompleted
                    ? null // Disable checkbox interaction if completed
                    : (value) {
                  widget.onCheckboxChanged(value);
                },
              ),
              Padding(
                padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.task.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          decoration: widget.task.isCompleted == 1
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      Text(
                        widget.task.description,
                        style: TextStyle(
                          fontSize: 18,
                          decoration: widget.task.isCompleted == 1
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                    ],
                ),
              ),
              Spacer(),
              if (!isCompleted)
                Transform.scale(
                  scale: 1.3,
                  child: IconButton(
                    onPressed: widget.onEditPressed,
                    icon: const Icon(Icons.edit_note_rounded),
                    alignment: Alignment.topRight,
                  ),
                ),
                Transform.scale(
                  scale: 1.3,
                  child: IconButton(
                    onPressed: widget.onDeletePressed,
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
