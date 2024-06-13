import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_go/bloc/event_image/event_image_bloc.dart';
import 'package:student_go/bloc/events_saved/events_saved_bloc.dart';
import 'package:student_go/bloc/profile_image/profile_image_bloc.dart';
import 'package:student_go/models/response/list_events_response/content.dart';
import 'package:student_go/repository/event/event_repository.dart';
import 'package:student_go/repository/event/event_repository_impl.dart';
import 'package:student_go/repository/student/student_repository.dart';
import 'package:student_go/repository/student/student_repository_impl.dart';
import 'package:student_go/screen/event_details_screen.dart';

class EventCard extends StatefulWidget {
  final Content result;
  const EventCard({super.key, required this.result});

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  Position? position;
  late String _street = '';
  late String _city = '';
  late String _postalCode = '';
  //bool _isLoading = true;
  late StudentRepository studentRepository;
  late EventsSavedBloc _eventsSavedBloc;
  late EventRepository _eventRepository;
  bool isEventSaved = false;
  late EventImageBloc _eventImageBloc;

  Future<void> _getStreet() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        widget.result.latitude!,
        widget.result.longitude!,
      );
      Placemark placemark = placemarks.first;
      if (mounted) {
        setState(() {
          _street = placemark.street ?? 'Unknown';
          _city = placemark.locality ?? 'Unknown';
          _postalCode = placemark.postalCode ?? '00000';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _street = 'Unknown';
          _city = 'Unknown';
          _postalCode = '00000';
        });
      }
      throw Exception('Error obtaining street: $e');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _getStreet();
    studentRepository = StudentRepositoryImp();
    _eventRepository = EventRepositoryImpl();
    _eventsSavedBloc = EventsSavedBloc(studentRepository)
      ..add(FetchEventsSaved());
    _eventImageBloc = EventImageBloc(_eventRepository)
      ..add(FetchEventImage(widget.result.uuid!, 0));
  }

  @override
  Widget build(BuildContext context) {
    return _buildCard();
  }

  Widget _buildCard() {
    List<Widget> stackChildren = [];

    for (int i = 0; i < widget.result.students!.length && i < 3; i++) {
      stackChildren.add(
        BlocProvider(
          create: (context) => ProfileImageBloc(studentRepository)
            ..add(FetchProfileImageById(widget.result.students![i].id!)),
          child: BlocBuilder<ProfileImageBloc, ProfileImageState>(
            builder: (context, state) {
              if (state is ProfileImageInitial ||
                  state is ProfileImageLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is ProfileImageSuccess) {
                return Positioned(
                  left: 20 * i.toDouble(),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 1,
                      ),
                    ),
                    child: ClipOval(
                      child: Image.memory(
                        state.image,
                        width: 30,
                        height: 30,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              } else {
                return Positioned(
                  left: 20 * i.toDouble(),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 1,
                      ),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/img/nophoto.png',
                        width: 30,
                        height: 30,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              }
            },
          ),
        ),
      );
    }

    if (widget.result.students!.length > 3) {
      stackChildren.add(
        Positioned(
          left: 80,
          child: Text(
            '+${widget.result.students!.length - 3} more',
            style: GoogleFonts.actor(
              textStyle: const TextStyle(
                color: Color.fromRGBO(63, 56, 221, 1),
                fontSize: 12,
              ),
            ),
          ),
        ),
      );
    }
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: _eventImageBloc,
        ),
        BlocProvider.value(value: _eventsSavedBloc)
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: GestureDetector(
          onTap: () {
            _navigateAndRefreshProfile(context, widget.result.uuid!);
          },
          child: SizedBox(
            height: 300,
            width: 275,
            child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                surfaceTintColor: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          BlocBuilder<EventImageBloc, EventImageState>(
                            builder: (context, state) {
                              if (state is EventImageInitial ||
                                  state is EventImageLoading) {
                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  width: double.infinity,
                                  height: 170,
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
                                  width: double.infinity,
                                  height: 170,
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
                                  width: double.infinity,
                                  height: 170,
                                );
                              }
                            },
                          ),
                          Positioned(
                            top: 10,
                            left: 10,
                            child: SizedBox(
                              width: 230,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 12),
                                    child: Column(
                                      children: [
                                        Text(
                                          obtenerDia(widget.result.dateTime!),
                                          style: GoogleFonts.openSans(
                                              textStyle: const TextStyle(
                                                  color: Color.fromRGBO(
                                                      240, 99, 90, 1),
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        Text(
                                            obtenerMes(widget.result.dateTime!)
                                                .toUpperCase(),
                                            style: GoogleFonts.actor(
                                                textStyle: const TextStyle(
                                                    color: Color.fromRGBO(
                                                        240, 99, 90, 1),
                                                    fontWeight:
                                                        FontWeight.w400)))
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      _eventsSavedBloc.add(
                                          BookmarkEvent(widget.result.uuid!));
                                      _eventsSavedBloc.add(FetchEventsSaved());
                                      setState(() {
                                        isEventSaved = !isEventSaved;
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white,
                                      ),
                                      padding: const EdgeInsets.all(8),
                                      child: BlocBuilder<EventsSavedBloc,
                                          EventsSavedState>(
                                        builder: (context, state) {
                                          if (state is EventsSavedSuccess) {
                                            final eventsSaved =
                                                state.eventsSaved;
                                            isEventSaved = eventsSaved.any(
                                                (event) =>
                                                    event.uuid ==
                                                    widget.result.uuid);
                                            return Icon(
                                              Icons.bookmark,
                                              color: isEventSaved
                                                  ? const Color.fromARGB(
                                                      255, 247, 230, 5)
                                                  : const Color.fromRGBO(
                                                      240, 99, 90, 1),
                                            );
                                          }
                                          return const Icon(
                                            Icons.bookmark,
                                            color: Color.fromRGBO(
                                                167, 166, 166, 1),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: Text(
                            truncateString(widget.result.name!, 20),
                            style: GoogleFonts.actor(
                                textStyle: const TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.w500)),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: SizedBox(
                          width: double.infinity,
                          height: 30,
                          child: Stack(
                              alignment: Alignment.center,
                              children: stackChildren),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6.0),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                size: 18,
                                color: Color.fromRGBO(116, 118, 136, 1),
                              ),
                              const SizedBox(
                                width: 2,
                              ),
                              Expanded(
                                child: Text(
                                  '$_street, $_postalCode, $_city',
                                  style: GoogleFonts.actor(
                                    textStyle: const TextStyle(
                                        color: Color.fromRGBO(116, 118, 136, 1),
                                        fontSize: 12),
                                    fontWeight: FontWeight.w100,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
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

  Route _createRoute(String uuid) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          EventDetailsScreen(eventId: uuid),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0); // Comienza desde el lado derecho
        const end = Offset
            .zero; // Termina en el centro (pantalla completamente visible)
        const curve =
            Curves.ease; // Puedes cambiar la curva de animación si deseas

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  void _fetchData() {
    _eventsSavedBloc.add(FetchEventsSaved());
  }

  void _navigateAndRefreshProfile(BuildContext context, String uuid) {
    Navigator.of(context).push(_createRoute(uuid)).then((_) {
      _fetchData();
    });
  }
}
