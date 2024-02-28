import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_go/models/response/event_type_response.dart';
import 'package:student_go/screen/event_type_events_screen.dart';

class EventTypeWidget extends StatelessWidget {
  final EventTypeResponse eventType;
  final String cityName;
  const EventTypeWidget(
      {super.key, required this.eventType, required this.cityName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: FittedBox(
        child: ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EventTypeEventsScreen(
                        id: eventType.id!,
                        cityName: cityName,
                      )),
            );
          },
          icon: Icon(
            IconData(int.parse(eventType.iconRef!),
                fontFamily: 'MaterialIcons'),
            size: 24,
            color: const Color.fromRGBO(255, 255, 255, 1),
          ),
          label: Text(
            eventType.name!,
            style: GoogleFonts.actor(
              textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 19,
                letterSpacing: 0.2,
              ),
            ),
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
