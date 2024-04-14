import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:student_go/bloc/all_events_calendar/all_events_calendar_bloc.dart';
import 'package:student_go/models/response/list_events_response/content.dart';
import 'package:student_go/repository/event/event_repository.dart';
import 'package:student_go/repository/event/event_repository_impl.dart';
import 'package:student_go/screen/event_details_screen.dart';
import 'package:table_calendar/table_calendar.dart';

class EventsCalendarScreen extends StatefulWidget {
  const EventsCalendarScreen({Key? key}) : super(key: key);

  @override
  State<EventsCalendarScreen> createState() => _EventsCalendarScreenState();
}

class _EventsCalendarScreenState extends State<EventsCalendarScreen> {
  late final ValueNotifier<List<Content>> _selectedEvents;
  late AllEventsCalendarBloc _calendarBloc;
  late EventRepository eventRepository;
  Map<DateTime, List<Content>> _eventsMap = {};
  late String _currentCity = '';
  bool _isLoading = true;

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await _determinePosition();
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      Placemark placemark = placemarks.first;
      setState(() {
        _currentCity = placemark.locality ?? 'Unknown';
        _isLoading = false;
        _calendarBloc = AllEventsCalendarBloc(eventRepository)
          ..add(FetchAllEventsCalendar(_currentCity));
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      throw Exception('Error obtaining location: $e');
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied.');
    }

    return await Geolocator.getCurrentPosition();
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    eventRepository = EventRepositoryImpl();
    _selectedEvents = ValueNotifier([]);
    _calendarBloc = AllEventsCalendarBloc(eventRepository);
  }

  @override
  void dispose() {
    _calendarBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AllEventsCalendarBloc, AllEventsCalendarState>(
        bloc: _calendarBloc,
        builder: (context, state) {
          if (state is AllEventsCalendarLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AllEventsCalendarSuccess) {
            _eventsMap = _getEventsMap(state.events);
            return _buildCalendar();
          } else if (state is AllEventsCalendarError) {
            return Center(child: Text(state.errorMessage));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _buildCalendar() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: _onDaySelected,
            headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: GoogleFonts.actor(
                    textStyle: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 25))),
            eventLoader: _getEventsForDay,
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(top: 15.0, left: 15, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _selectedDay != null
                    ? Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color.fromRGBO(238, 240, 255, 1)),
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                        child: Column(
                          children: [
                            Text(obtenerMes(_selectedDay.toString()),
                                style: GoogleFonts.actor(
                                    textStyle: const TextStyle(
                                        color: Color.fromRGBO(86, 105, 255, 1),
                                        fontWeight: FontWeight.w400))),
                            Text(
                              obtenerDia(_selectedDay.toString()),
                              style: GoogleFonts.openSans(
                                  textStyle: const TextStyle(
                                      color: Color.fromRGBO(86, 105, 255, 1),
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color.fromRGBO(238, 240, 255, 1)),
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(obtenerMes(DateTime.now().toString()),
                                style: GoogleFonts.actor(
                                    textStyle: const TextStyle(
                                        color: Color.fromRGBO(86, 105, 255, 1),
                                        fontWeight: FontWeight.w400))),
                            Text(
                              obtenerDia(DateTime.now().toString()),
                              style: GoogleFonts.openSans(
                                  textStyle: const TextStyle(
                                      color: Color.fromRGBO(86, 105, 255, 1),
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: _selectedDay != null
                      ? Text(
                          formatDateTime(_selectedDay!).toUpperCase(),
                          style: GoogleFonts.actor(
                              textStyle:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                        )
                      : Text(formatDateTime(DateTime.now()).toUpperCase(),
                          style: GoogleFonts.actor(
                              textStyle: const TextStyle(
                                  fontWeight: FontWeight.bold))),
                ),
              ],
            ),
          ),
          Expanded(
            child: ValueListenableBuilder<List<Content>>(
              valueListenable: _selectedEvents,
              builder: (context, events, _) {
                return events.isEmpty
                    ? Text(
                        'No hay ningún evento para este día',
                        style: GoogleFonts.actor(),
                      )
                    : ListView.builder(
                        itemCount: events.length,
                        itemBuilder: (context, index) {
                          final event = events[index];
                          return Padding(
                            padding: const EdgeInsets.only(
                                top: 8.0, left: 60, right: 10),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EventDetailsScreen(
                                            eventId: event.uuid!,
                                          )),
                                );
                              },
                              child: SizedBox(
                                width: double.infinity,
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  color: Color(int.parse(
                                      event.eventType![0].colorCode!)),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              child: Container(
                                                width: 65,
                                                height: 65,
                                                decoration: const BoxDecoration(
                                                  image: DecorationImage(
                                                    image: AssetImage(
                                                        'assets/img/card_background.jpg'),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 4,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 6.0,
                                                horizontal: 12,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        formatHour(
                                                            event.dateTime!),
                                                        style:
                                                            GoogleFonts.actor(
                                                          textStyle:
                                                              const TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    255,
                                                                    255,
                                                                    255,
                                                                    1),
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        event.name!,
                                                        style:
                                                            GoogleFonts.actor(
                                                          textStyle:
                                                              const TextStyle(
                                                                  fontSize: 18,
                                                                  height: 1.1,
                                                                  color: Colors
                                                                      .white),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
              },
            ),
          ),
        ],
      ),
    );
  }

  String formatHour(String dateTimeString) {
    // Formato de entrada corregido
    final inputFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss");
    // Formato de salida
    final outputFormat = DateFormat("hh:mm a");

    final dateTime = inputFormat.parse(dateTimeString);
    final formattedTime = outputFormat.format(dateTime);

    return formattedTime;
  }

  String obtenerMes(String fecha) {
    // Analizar la cadena de fecha en un objeto DateTime
    DateTime dateTime = DateTime.parse(fecha);

    // Obtener el nombre del mes en inglés
    String monthName = '';
    switch (dateTime.month) {
      case 1:
        monthName = 'Jan.';
        break;
      case 2:
        monthName = 'Feb.';
        break;
      case 3:
        monthName = 'Mar.';
        break;
      case 4:
        monthName = 'Apr.';
        break;
      case 5:
        monthName = 'May';
        break;
      case 6:
        monthName = 'June';
        break;
      case 7:
        monthName = 'July';
        break;
      case 8:
        monthName = 'Aug.';
        break;
      case 9:
        monthName = 'Sep.';
        break;
      case 10:
        monthName = 'Oct.';
        break;
      case 11:
        monthName = 'Nov.';
        break;
      case 12:
        monthName = 'Dec.';
        break;
      default:
        monthName = '';
        break;
    }

    return monthName;
  }

  String obtenerDia(String fecha) {
    final primerGuionIndex = fecha.indexOf('-');
    final segundoGuionIndex = fecha.indexOf('-', primerGuionIndex + 1);
    final dia = fecha.substring(segundoGuionIndex + 1, segundoGuionIndex + 3);
    return dia;
  }

  String formatDateTime(DateTime dateTime) {
    final dateFormat =
        DateFormat('E, d\'${_getDaySuffix(dateTime.day)}\' MMMM, yyyy');
    return dateFormat.format(dateTime);
  }

  String _getDaySuffix(int day) {
    if (day >= 11 && day <= 13) {
      return 'th';
    }
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  List<Content> _getEventsForDay(DateTime day) {
    final eventsForDay = _eventsMap.entries
        .where((entry) => isSameDay(entry.key, day))
        .map((entry) => entry.value)
        .expand((events) => events)
        .toList();
    return eventsForDay;
  }

  List<Content> _getEventsForSelectedDay() {
    if (_selectedDay != null) {
      return _getEventsForDay(_selectedDay!);
    } else {
      return [];
    }
  }

  Map<DateTime, List<Content>> _getEventsMap(List<Content> events) {
    final Map<DateTime, List<Content>> eventsMap = {};

    for (final event in events) {
      final eventDate = DateTime.parse(event.dateTime!);
      if (eventsMap.containsKey(eventDate)) {
        eventsMap[eventDate]!.add(event);
      } else {
        eventsMap[eventDate] = [event];
      }
    }

    return eventsMap;
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
      _rangeStart = null; // Clear these values
      _rangeEnd = null;
      _rangeSelectionMode = RangeSelectionMode.toggledOff;
    });
    _selectedEvents.value = _getEventsForSelectedDay();
  }

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
}
