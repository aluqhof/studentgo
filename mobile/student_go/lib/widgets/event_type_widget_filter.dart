import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_go/models/response/event_type_response.dart';

class EventTypeWidgetFilter extends StatefulWidget {
  final EventTypeResponse eventType;
  final String cityName;
  final Function(int) onEventTypeSelected;
  final Function(int) onEventTypeDeSelected;
  final List<int> eventTypeIds;

  const EventTypeWidgetFilter(
      {Key? key,
      required this.eventType,
      required this.cityName,
      required this.onEventTypeSelected,
      required this.onEventTypeDeSelected,
      required this.eventTypeIds})
      : super(key: key);

  @override
  State<EventTypeWidgetFilter> createState() => _EventTypeWidgetFilterState();
}

class _EventTypeWidgetFilterState extends State<EventTypeWidgetFilter> {
  bool isSelected = false;

  @override
  void initState() {
    super.initState();
    isSelected = widget.eventTypeIds.contains(widget.eventType.id);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                isSelected = !isSelected;
                if (isSelected) {
                  widget.onEventTypeSelected(widget.eventType.id!);
                } else {
                  widget.onEventTypeDeSelected(widget.eventType.id!);
                }
              });
            },
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? const Color.fromRGBO(74, 67, 236, 1)
                    : Colors.white,
                boxShadow: isSelected
                    ? [
                        const BoxShadow(
                          color: Color.fromRGBO(74, 67, 236, 0.5),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: Offset(0, 2),
                        ),
                      ]
                    : null,
                border: Border.all(
                  color: const Color.fromARGB(255, 187, 186, 186),
                  width: 0.5,
                ),
              ),
              child: Center(
                child: Icon(
                  IconData(int.parse(widget.eventType.iconRef!),
                      fontFamily: 'MaterialIcons'),
                  size: 40,
                  color: isSelected
                      ? Colors.white
                      : const Color.fromARGB(255, 187, 186, 186),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.eventType.name!,
            style: GoogleFonts.actor(
              textStyle: const TextStyle(
                color: Colors.black,
                fontSize: 15,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
