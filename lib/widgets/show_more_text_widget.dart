import 'package:flutter/material.dart';

class ShowMoreText extends StatefulWidget {
  final String text;
  final int maxLines;

  const ShowMoreText({super.key, required this.text, this.maxLines = 2});

  @override
  State<ShowMoreText> createState() => _ShowMoreTextState();
}

class _ShowMoreTextState extends State<ShowMoreText> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.text,
          maxLines: isExpanded ? null : widget.maxLines,
        ),
        if (widget.text.length >
            widget.maxLines *
                40) // 40 is an arbitrary number, you can adjust it based on your content
          GestureDetector(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Text(
              isExpanded ? 'Show Less' : 'Show More',
              style: const TextStyle(color: Colors.blue, fontSize: 10),
            ),
          ),
      ],
    );
  }
}
