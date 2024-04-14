import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_go/bloc/event_type/event_type_bloc.dart';
import 'package:student_go/repository/event_type/event_type_repository.dart';
import 'package:student_go/repository/event_type/event_type_repository_impl.dart';

class EventTypeWidgetMap extends StatefulWidget {
  final Function(int) onPressed;
  final int? selectedEventTypeId;
  const EventTypeWidgetMap(
      {super.key, required this.onPressed, required this.selectedEventTypeId});

  @override
  State<EventTypeWidgetMap> createState() => _EventTypeWidgetMapState();
}

class _EventTypeWidgetMapState extends State<EventTypeWidgetMap> {
  late EventTypeRepository eventTypeRepository;
  late EventTypeBloc _eventTypeBloc;

  @override
  void initState() {
    eventTypeRepository = EventTypeRepositoryImpl();
    _eventTypeBloc = EventTypeBloc(eventTypeRepository)
      ..add(FetchEventTypeEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _eventTypeBloc,
      child: BlocBuilder<EventTypeBloc, EventTypeState>(
        builder: (context, state) {
          if (state is EventTypeInitial) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is EventTypeLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is EventTypeSuccess) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: FittedBox(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(
                    children: state.eventTypeResponseList.map((eventType) {
                      bool isSelected =
                          eventType.id == widget.selectedEventTypeId;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            if (isSelected) {
                              widget.onPressed(-1);
                            } else {
                              widget.onPressed(eventType.id!);
                            }
                          },
                          icon: Icon(
                            IconData(int.parse(eventType.iconRef!),
                                fontFamily: 'MaterialIcons'),
                            size: 20,
                            color: isSelected
                                ? Colors.white
                                : Color(int.parse(eventType.colorCode!)),
                          ),
                          label: Text(
                            eventType.name!,
                            style: GoogleFonts.actor(
                              textStyle: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : const Color.fromARGB(255, 119, 119, 119),
                                fontSize: 17,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isSelected
                                ? Color(int.parse(eventType.colorCode!))
                                : Colors.white,
                            surfaceTintColor: isSelected
                                ? Color(int.parse(eventType.colorCode!))
                                : Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            );
          } else if (state is EventTypeError) {
            return const Text('Not suport');
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
