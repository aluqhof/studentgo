import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_go/bloc/event_list/event_list_bloc.dart';
import 'package:student_go/repository/event/event_repository.dart';
import 'package:student_go/repository/event/event_repository_impl.dart';
import 'package:student_go/screen/according_list_vertical.dart';
import 'package:student_go/screen/login_screen.dart';
import 'package:student_go/widgets/event_card.dart';

class AccordingHorizontalList extends StatefulWidget {
  final String cityName;
  const AccordingHorizontalList({super.key, required this.cityName});

  @override
  State<AccordingHorizontalList> createState() =>
      _AccordingHorizontalListState();
}

class _AccordingHorizontalListState extends State<AccordingHorizontalList> {
  late EventRepository eventRepository;
  late EventListBloc _eventListBloc;
  late SharedPreferences _prefs;

  @override
  void initState() {
    eventRepository = EventRepositoryImpl();
    _eventListBloc = EventListBloc(eventRepository)
      ..add(FetchAccordingListEvent(widget.cityName, 0, 5));
    initialize();
    super.initState();
  }

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _eventListBloc,
      child:
          BlocBuilder<EventListBloc, EventListState>(builder: (context, state) {
        if (state is AccordingListSuccess) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      state.listEventsResponse.name!,
                      style: GoogleFonts.actor(
                          textStyle: const TextStyle(fontSize: 20)),
                    ),
                    state.listEventsResponse.content!.isNotEmpty
                        ? GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AccordingListVertical(
                                          cityName: widget.cityName,
                                        )),
                              );
                            },
                            child: Row(
                              children: [
                                Text(
                                  'See All',
                                  style: GoogleFonts.actor(
                                      textStyle: const TextStyle(
                                          color: Color.fromRGBO(
                                              116, 118, 136, 1))),
                                ),
                                const Icon(Icons.arrow_right,
                                    size: 20,
                                    color: Color.fromRGBO(116, 118, 136,
                                        1)), // Agregar el icono aquí
                              ],
                            ),
                          )
                        : const SizedBox()
                  ],
                ),
              ),
              SizedBox(
                  height: 300,
                  width: MediaQuery.of(context).size.width,
                  child: state.listEventsResponse.content!.isNotEmpty
                      ? ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: state.listEventsResponse.content!.length,
                          itemBuilder: ((context, index) {
                            return EventCard(
                                result:
                                    state.listEventsResponse.content![index]);
                          }))
                      : SizedBox(
                          width: double.infinity,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 150.0,
                                height: 150.0,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image:
                                        AssetImage('assets/img/noevents.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18.0),
                                child: Text(
                                  'There are currently no events according to your interests in your city',
                                  style: GoogleFonts.actor(
                                      textStyle: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w200,
                                          color: Colors.grey)),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ))
            ],
          );
        } else if (state is EventListInitial || state is EventListLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is TokenNotValidState) {
          Future.microtask(() {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          });
          return const CircularProgressIndicator();
        } else if (state is AccordingListEntityException) {
          if (state.generalException.status == 401 ||
              state.generalException.status == 403) {
            _prefs.setString('token', '');
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
            return const SizedBox();
          }
          if (state.generalException.status == 400) {
            return const Text('Unespected error');
          }
          if (state.generalException.status == 404) {
            return Column(
              mainAxisAlignment: MainAxisAlignment
                  .center, // Aligns the children to the center of the column.
              children: [
                Container(
                  width: 200.0, // Sets the width of the container to 200
                  height: 200.0, // Sets the height of the container to 200
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          'assets/img/noevents.png'), // Replace with your image URL
                      fit: BoxFit
                          .cover, // Covers the area of the container without stretching the image.
                    ),
                  ),
                ),
                const SizedBox(
                    height: 20), // Adds space between the image and the text.
                Text(
                  'There are currently no events in your city', // Replace with your desired text
                  style: GoogleFonts.actor(
                      textStyle: const TextStyle(
                    fontSize: 20, // Sets the font size of the text
                    fontWeight: FontWeight.bold, // Makes the text bold
                  )),
                ),
              ],
            );
          }
          return Text(state.generalException.detail!);
        } else if (state is AccordingListError) {
          return Text(state.errorMessage);
        } else {
          return const Text('Unespected error');
        }
      }),
    );
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

  String truncateString(String str) {
    if (str.length > 21) {
      return '${str.substring(0, 21)}...';
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
}
