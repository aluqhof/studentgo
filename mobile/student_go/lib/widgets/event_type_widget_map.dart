import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_go/bloc/event_type/event_type_bloc.dart';
import 'package:student_go/repository/event_type/event_type_repository.dart';
import 'package:student_go/repository/event_type/event_type_repository_impl.dart';

class EventTypeWidgetMap extends StatefulWidget {
  const EventTypeWidgetMap({super.key});

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
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            /*Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EventTypeEventsScreen(
                                      id: eventType.id!,
                                      cityName: cityName,
                                    )),
                          );*/
                          },
                          icon: Icon(
                            IconData(int.parse(eventType.iconRef!),
                                fontFamily: 'MaterialIcons'),
                            size: 20,
                            color: Color(int.parse(eventType.colorCode!)),
                          ),
                          label: Text(
                            eventType.name!,
                            style: GoogleFonts.actor(
                              textStyle: const TextStyle(
                                color: Color.fromARGB(255, 119, 119, 119),
                                fontSize: 17,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            surfaceTintColor: Colors.white,
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
