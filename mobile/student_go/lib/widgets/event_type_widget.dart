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
          icon: const Icon(Icons.sports_basketball,
              size: 22, color: Color.fromRGBO(255, 255, 255, 1)),
          label: Text(
            'Sports',
            style: GoogleFonts.actor(
                textStyle: const TextStyle(color: Colors.white, fontSize: 15)),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(240, 99, 90, 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
    );
  }
}
