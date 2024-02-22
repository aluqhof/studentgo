import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_go/models/response/event_type_response.dart';

class EventTypeWidget extends StatelessWidget {
  final EventTypeResponse eventType;
  const EventTypeWidget({super.key, required this.eventType});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 3.5,
        child: ElevatedButton.icon(
          onPressed: () {},
          icon: Icon(
              IconData(int.parse(eventType.iconRef!),
                  fontFamily: 'MaterialIcons'),
              size: 22,
              color: const Color.fromRGBO(255, 255, 255, 1)),
          label: Text(
            eventType.name!,
            style: GoogleFonts.actor(
                textStyle: const TextStyle(color: Colors.white, fontSize: 15)),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(int.parse(eventType.colorCode!)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
    );
  }
}
