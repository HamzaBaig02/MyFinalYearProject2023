import 'package:flutter/material.dart';

class GraphButton extends StatefulWidget {
  final int index;
  final bool isSelected;
  final VoidCallback onSelect;
  final String text;

  GraphButton(
      {required this.text,
        required this.index,
        required this.isSelected,
        required this.onSelect});

  @override
  State<GraphButton> createState() => _GraphButtonState();
}

class _GraphButtonState extends State<GraphButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onSelect,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
        decoration: BoxDecoration(
            color: widget.isSelected ? Color(0xffc16996) : Color(0xff8b4a6c),
            borderRadius: BorderRadius.circular(5)),
        child: Text(
          "${widget.text}",
          style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,letterSpacing: 1),
        ),
      ),
    );
  }
}