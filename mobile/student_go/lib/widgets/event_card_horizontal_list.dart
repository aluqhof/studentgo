import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_go/bloc/event_list/event_list_bloc.dart';
import 'package:student_go/repository/event/event_repository.dart';
import 'package:student_go/repository/event/event_repository_impl.dart';
import 'package:student_go/screen/login_screen.dart';

class EventCardHorizontalList extends StatefulWidget {
  final String cityName;
  const EventCardHorizontalList({super.key, required this.cityName});

  @override
  State<EventCardHorizontalList> createState() =>
      _EventCardHorizontalListState();
}

class _EventCardHorizontalListState extends State<EventCardHorizontalList> {
  late EventRepository eventRepository;
  late EventListBloc _eventListBloc;
  late SharedPreferences _prefs;

  @override
  void initState() {
    eventRepository = EventRepositoryImpl();
    _eventListBloc = EventListBloc(eventRepository)
      ..add(FetchEventListEvent(widget.cityName));
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
        if (state is EventListSuccess) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      state.listEventsResponse.name!,
                      style:
                          GoogleFonts.actor(textStyle: TextStyle(fontSize: 20)),
                    ),
                    Row(
                      children: [
                        Text(
                          'See All',
                          style: GoogleFonts.actor(
                              textStyle: const TextStyle(
                                  color: Color.fromRGBO(116, 118, 136, 1))),
                        ),
                        const Icon(Icons.arrow_right,
                            size: 20,
                            color: Color.fromRGBO(
                                116, 118, 136, 1)), // Agregar el icono aquí
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 300,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: state.listEventsResponse.result!.length,
                      itemBuilder: ((context, index) {
                        return SizedBox(
                          height: 300,
                          width: 270,
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
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            image: const DecorationImage(
                                              image: AssetImage(
                                                  'assets/img/full_logo_notrans.jpg'),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          width: double.infinity,
                                          height: 170,
                                        ),
                                        Positioned(
                                          top: 10,
                                          left: 10,
                                          child: SizedBox(
                                            width:
                                                230, // Ancho igual al ancho de la pantalla
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color: Colors.white),
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 8,
                                                      horizontal: 12),
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        obtenerDia(state
                                                            .listEventsResponse
                                                            .result![index]
                                                            .dateTime!),
                                                        style: GoogleFonts.actor(
                                                            textStyle: TextStyle(
                                                                color: Color
                                                                    .fromRGBO(
                                                                        240,
                                                                        99,
                                                                        90,
                                                                        1),
                                                                fontSize: 15)),
                                                      ),
                                                      Text(
                                                          obtenerMes(state
                                                                  .listEventsResponse
                                                                  .result![
                                                                      index]
                                                                  .dateTime!)
                                                              .toUpperCase(),
                                                          style: GoogleFonts.actor(
                                                              textStyle: TextStyle(
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          240,
                                                                          99,
                                                                          90,
                                                                          1))))
                                                    ],
                                                  ),
                                                ),
                                                const Text(
                                                  'Hola',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )),
                        );
                      })),
                )
              ],
            ),
          );
        } else if (state is EventListInitial) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is EventListEntityException) {
          if (state.generalException.status == 401 ||
              state.generalException.status == 403) {
            _prefs.setString('token', '');
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          }
          if (state.generalException.status == 400) {
            return const Text('Unespected error');
          }
          if (state.generalException.status == 404) {
            return const Text('No hay eventos en tu ciudad');
          }
          return Text('${state.generalException.status!}');
        } else if (state is EventListError) {
          return Text(state.errorMessage);
        } else {
          return const Text('Not support');
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
