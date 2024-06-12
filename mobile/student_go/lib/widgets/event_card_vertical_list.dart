import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:student_go/bloc/event_image/event_image_bloc.dart';
import 'package:student_go/models/response/list_events_response/content.dart';
import 'package:student_go/repository/event/event_repository.dart';
import 'package:student_go/repository/event/event_repository_impl.dart';
import 'package:student_go/screen/event_details_screen.dart';

class EventCardVerticalList extends StatefulWidget {
  final Content result;
  const EventCardVerticalList({super.key, required this.result});

  @override
  State<EventCardVerticalList> createState() => _EventCardVerticalListState();
}

class _EventCardVerticalListState extends State<EventCardVerticalList> {
  Position? position;
  late String _street = '';
  late String _city = '';
  late String _postalCode = '';
  late EventRepository _eventRepository;
  late EventImageBloc _eventImageBloc;
  //bool _isLoading = true;

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

  Future<void> _getStreet() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        widget.result.latitude!,
        widget.result.longitude!,
      );
      Placemark placemark = placemarks.first;
      setState(() {
        _street = placemark.street ?? 'Unknown';
        _postalCode = placemark.postalCode ?? '00000';
        _city = placemark.locality ?? 'Unknown';
        //_isLoading = false;
      });
    } catch (e) {
      setState(() {
        //_isLoading = false;
      });
      throw Exception('Error obtaining location: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _getStreet();
    _eventRepository = EventRepositoryImpl();
    _eventImageBloc = EventImageBloc(_eventRepository)
      ..add(FetchEventImage(widget.result.uuid!, 0));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _eventImageBloc,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EventDetailsScreen(
                      eventId: widget.result.uuid!,
                    )),
          );
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          surfaceTintColor: Colors.white,
          child: SizedBox(
            height: 120,
            width: double.infinity, // Mantén el ancho como double.infinity
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: BlocBuilder<EventImageBloc, EventImageState>(
                      builder: (context, state) {
                        if (state is EventImageInitial ||
                            state is EventImageLoading) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        } else if (state is EventImageSuccess) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: MemoryImage(state.image),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        } else {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: const DecorationImage(
                                image: AssetImage(
                                    'assets/img/card_background.jpg'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 6.0,
                        horizontal: 12,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                formatDateTime(widget.result.dateTime!),
                                style: GoogleFonts.actor(
                                  textStyle: const TextStyle(
                                    color: Color.fromRGBO(86, 105, 255, 1),
                                  ),
                                ),
                              ),
                              Text(
                                widget.result.name!,
                                style: GoogleFonts.actor(
                                  textStyle: const TextStyle(
                                    fontSize: 18,
                                    height: 1.1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                size: 18,
                                color: Color.fromRGBO(116, 118, 136, 1),
                              ),
                              const SizedBox(width: 2),
                              Expanded(
                                child: Text(
                                    '$_street, $_postalCode, $_city',
                                  style: GoogleFonts.actor(
                                    textStyle: const TextStyle(
                                      color: Color.fromRGBO(116, 118, 136, 1),
                                      fontSize: 12,
                                    ),
                                    fontWeight: FontWeight.w100,
                                  ),
                                  overflow: TextOverflow.ellipsis,
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
    );
  }

  String truncateString(String str, int num) {
    if (str.length > num) {
      return '${str.substring(0, num)}...';
    } else {
      return str;
    }
  }

  String formatDateTime(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    String formattedDate = DateFormat('E, MMM d • h:mm a').format(dateTime);
    return formattedDate;
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
    // Obtener el índice del primer guion en la cadena
    final primerGuionIndex = fecha.indexOf('-');
    // Obtener el índice del segundo guion en la cadena
    final segundoGuionIndex = fecha.indexOf('-', primerGuionIndex + 1);
    // Extraer el substring correspondiente al día
    final dia = fecha.substring(segundoGuionIndex + 1, segundoGuionIndex + 3);
    return dia;
  }
}
