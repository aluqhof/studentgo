import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DateSelectionWidget extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isSelected;

  const DateSelectionWidget({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.isSelected,
  }) : super(key: key);

  @override
  State<DateSelectionWidget> createState() => _DateSelectionWidgetState();
}

class _DateSelectionWidgetState extends State<DateSelectionWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          backgroundColor: widget.isSelected
              ? const Color.fromRGBO(74, 67, 236, 1)
              : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: widget.isSelected
                  ? const Color.fromRGBO(74, 67, 236, 1)
                  : const Color.fromARGB(255, 187, 186, 186),
              width: 0.5,
            ),
          ),
          elevation: widget.isSelected ? 2 : 0,
        ),
        child: Text(
          widget.text,
          style: GoogleFonts.actor(
              textStyle: TextStyle(
            color: widget.isSelected
                ? Colors.white
                : const Color.fromARGB(255, 128, 128, 128),
            fontSize: 15,
          )),
        ),
      ),
    );
  }
}
