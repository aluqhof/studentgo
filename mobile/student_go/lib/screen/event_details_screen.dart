import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_go/bloc/event_details/event_details_bloc.dart';
import 'package:student_go/bloc/event_image/event_image_bloc.dart';
import 'package:student_go/bloc/purchase/purchase_bloc.dart';
import 'package:student_go/models/response/event_details_response/event_details_response.dart';
import 'package:student_go/repository/event/event_repository.dart';
import 'package:student_go/repository/event/event_repository_impl.dart';
import 'package:student_go/repository/purchase/purchase_repository.dart';
import 'package:student_go/repository/purchase/purchase_repository_impl.dart';
import 'package:student_go/screen/login_screen.dart';
import 'package:student_go/widgets/people_going_list.dart';
import 'package:carousel_slider/carousel_slider.dart';

class EventDetailsScreen extends StatefulWidget {
  final String eventId;
  const EventDetailsScreen({super.key, required this.eventId});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  late EventRepository eventRepository;
  late EventDetailsBloc _eventDetailsBloc;
  late PurchaseRepository purchaseRepository;
  late PurchaseBloc _purchaseBloc;
  late SharedPreferences _prefs;
  late String _street = '';
  late String _city = '';
  late String _postalCode = '';
  int _counter = 1;
  late EventImageBloc _eventImageBloc;

  Future<void> _getStreet(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );
      Placemark placemark = placemarks.first;
      setState(() {
        _street = placemark.street ?? 'Unknown';
        _postalCode = placemark.postalCode ?? '00000';
        _city = placemark.locality ?? 'Unknown';
      });
    } catch (e) {
      throw Exception('Error obtaining location: $e');
    }
  }

  @override
  void initState() {
    eventRepository = EventRepositoryImpl();
    _eventDetailsBloc = EventDetailsBloc(eventRepository)
      ..add(FetchEventDetails(widget.eventId));
    purchaseRepository = PurchaseRepositoryImpl();
    _purchaseBloc = PurchaseBloc(purchaseRepository);
    _eventImageBloc = EventImageBloc(eventRepository);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
        value: _eventDetailsBloc,
        child: BlocBuilder<EventDetailsBloc, EventDetailsState>(
          builder: (context, state) {
            if (state is EventDetailsSuccess) {
              _getStreet(
                  state.eventDetails.latitude!, state.eventDetails.longitude!);
              return Scaffold(
                extendBodyBehindAppBar:
                    true, // Para extender el body detrás del AppBar
                appBar: AppBar(
                  title: Text(
                    'Event Details',
                    style: GoogleFonts.actor(),
                  ),
                  foregroundColor: Colors.white,
                  actions: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color:
                                      const Color.fromRGBO(255, 255, 255, 0.3)),
                              padding: const EdgeInsets.all(8),
                              child: const Icon(
                                Icons.share,
                                color: Color.fromRGBO(255, 255, 255, 1),
                              )),
                          const SizedBox(
                            width: 5,
                          ),
                          Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color:
                                      const Color.fromRGBO(255, 255, 255, 0.3)),
                              padding: const EdgeInsets.all(8),
                              child: const Icon(
                                //Bokmark added
                                Icons.bookmark,
                                color: Color.fromRGBO(255, 255, 255, 1),
                              )),
                        ],
                      ),
                    ),
                  ],
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                ),
                body: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet<void>(
                            context: context,
                            isScrollControlled: true,
                            builder: (BuildContext context) {
                              ImageFilter.blur(sigmaX: 20, sigmaY: 20);
                              return SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.85,
                                child: PeopleGoingList(
                                  students: state.eventDetails.students!,
                                ),
                              );
                            },
                          );
                        },
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            fetchImages(state.eventDetails),
                            Positioned(
                              top: 215,
                              left: 0,
                              right: 0,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 40.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(40.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.3),
                                        blurRadius:
                                            10.0, // Establece el blurRadius en 0
                                        spreadRadius: 0.0,
                                        offset: const Offset(0.0,
                                            5.0), // Desplazamiento hacia abajo
                                      ),
                                    ],
                                  ),
                                  height: 70,
                                  width: double.infinity,
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40.0),
                                    ),
                                    surfaceTintColor: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Positioned(
                                            left: 50,
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
                                                  'assets/img/fotoprueba1.jpg',
                                                  width: 35,
                                                  height: 35,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            left: 25,
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
                                                  'assets/img/fotoprueba2.jpg',
                                                  width: 35,
                                                  height: 35,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            left: 0,
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
                                                  'assets/img/fotoprueba3.jpg',
                                                  width: 35,
                                                  height: 35,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            left: 100,
                                            child: Text(
                                              state.eventDetails.students!
                                                          .length >=
                                                      20
                                                  ? '+20 Going'
                                                  : state.eventDetails.students!
                                                          .isNotEmpty
                                                      ? '${state.eventDetails.students!.length} Going'
                                                      : 'Be the first',
                                              style: GoogleFonts.actor(
                                                  textStyle: const TextStyle(
                                                color: Color.fromRGBO(
                                                    63, 56, 221, 1),
                                                fontSize: 17,
                                              )),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: ElevatedButton(
                                                style: ButtonStyle(
                                                    padding:
                                                        MaterialStateProperty.all<EdgeInsets>(
                                                            const EdgeInsets.symmetric(
                                                                horizontal: 25,
                                                                vertical: 0)),
                                                    shape: MaterialStateProperty.all<
                                                            RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                    10.0))),
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(Colors.blue)),
                                                onPressed: () {
                                                  // Lógica para el botón de invitar
                                                },
                                                child: Text(
                                                  'Invite',
                                                  style: GoogleFonts.actor(
                                                      textStyle:
                                                          const TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 15)),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 55),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            state.eventDetails.name!,
                            style: GoogleFonts.actor(
                                textStyle: const TextStyle(
                                    fontSize: 35,
                                    height: 1.1,
                                    fontWeight: FontWeight.w500)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10),
                        child: Row(
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color:
                                        const Color.fromRGBO(238, 240, 255, 1)),
                                padding: const EdgeInsets.all(12),
                                child: const Icon(
                                  Icons.calendar_month,
                                  size: 25,
                                  color: Color.fromRGBO(86, 105, 255, 1),
                                )),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    convertirFormatoFecha(
                                        state.eventDetails.dateTime!),
                                    style: GoogleFonts.actor(
                                        textStyle:
                                            const TextStyle(fontSize: 20)),
                                  ),
                                  Text(
                                      convertirFormato(
                                          state.eventDetails.dateTime!),
                                      style: GoogleFonts.actor(
                                          textStyle: const TextStyle(
                                              fontSize: 15,
                                              color: Color.fromRGBO(
                                                  112, 110, 143, 1))))
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10),
                        child: Row(
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color:
                                        const Color.fromRGBO(238, 240, 255, 1)),
                                padding: const EdgeInsets.all(12),
                                child: const Icon(
                                  Icons.location_on,
                                  size: 25,
                                  color: Color.fromRGBO(86, 105, 255, 1),
                                )),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    state.eventDetails.place!,
                                    style: GoogleFonts.actor(
                                        textStyle:
                                            const TextStyle(fontSize: 20)),
                                  ),
                                  Text(
                                      truncateString(
                                          '$_street, $_postalCode, $_city', 40),
                                      style: GoogleFonts.actor(
                                          textStyle: const TextStyle(
                                              fontSize: 15,
                                              color: Color.fromRGBO(
                                                  112, 110, 143, 1))))
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10),
                        child: Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: const Color.fromRGBO(238, 240, 255, 1),
                                  image: const DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage(
                                        'assets/img/fotoprueba3.jpg',
                                      ))),
                              padding: const EdgeInsets.all(12),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    state.eventDetails.organizer!.name!,
                                    style: GoogleFonts.actor(
                                        textStyle:
                                            const TextStyle(fontSize: 20)),
                                  ),
                                  Text(
                                    'Organizer',
                                    style: GoogleFonts.actor(
                                        textStyle: const TextStyle(
                                            fontSize: 15,
                                            color: Color.fromRGBO(
                                                112, 110, 143, 1))),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text('About event',
                                    style: GoogleFonts.actor(
                                        textStyle:
                                            const TextStyle(fontSize: 20))),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 80.0),
                                child: Text(state.eventDetails.description!,
                                    style: GoogleFonts.actor(
                                        textStyle:
                                            const TextStyle(fontSize: 16))),
                              )
                            ],
                          )),
                    ],
                  ),
                ),
                floatingActionButton: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(
                    left: 40.0,
                  ),
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: ElevatedButton(
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all<EdgeInsets>(
                              const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 15),
                            ),
                            foregroundColor:
                                MaterialStateProperty.all(Colors.blue),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            backgroundColor: MaterialStateProperty.all(
                                state.eventDetails.maxCapacity! <=
                                        state.eventDetails.students!.length
                                    ? Colors.red
                                    : Colors.blue),
                            shadowColor: MaterialStateProperty.all(
                                Colors.white), // Color de la sombra blanca
                            elevation: MaterialStateProperty.all(5),
                          ),
                          onPressed: () {
                            state.eventDetails.maxCapacity! >
                                    state.eventDetails.students!.length
                                ? showModalBottomSheet<void>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      ImageFilter.blur(sigmaX: 20, sigmaY: 20);
                                      return SafeArea(
                                        child: Wrap(children: [
                                          Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: SizedBox(
                                              width: double.infinity,
                                              child: Column(
                                                children: [
                                                  Text(
                                                    'Order Review',
                                                    style: GoogleFonts.actor(
                                                        textStyle:
                                                            const TextStyle(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 8.0),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          height: 100,
                                                          width: 100,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            image:
                                                                const DecorationImage(
                                                              image: AssetImage(
                                                                'assets/img/card_background.jpg',
                                                              ),
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      8.0),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Align(
                                                                alignment:
                                                                    Alignment
                                                                        .topLeft,
                                                                child: Text(
                                                                    truncateString(
                                                                        state
                                                                            .eventDetails
                                                                            .name!,
                                                                        20),
                                                                    style: GoogleFonts.actor(
                                                                        textStyle: const TextStyle(
                                                                            fontSize:
                                                                                18,
                                                                            fontWeight:
                                                                                FontWeight.w500))),
                                                              ),
                                                              Text(
                                                                  truncateString(
                                                                      state
                                                                          .eventDetails
                                                                          .place!,
                                                                      20),
                                                                  style: GoogleFonts.actor(
                                                                      textStyle: const TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          color:
                                                                              Colors.grey))),
                                                              Text(
                                                                  convertirFormato(state
                                                                      .eventDetails
                                                                      .dateTime!),
                                                                  style: GoogleFonts.actor(
                                                                      textStyle: const TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          color:
                                                                              Colors.grey))),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 8.0),
                                                    child: BlocProvider.value(
                                                        value: _purchaseBloc,
                                                        child: BlocBuilder<
                                                            PurchaseBloc,
                                                            PurchaseState>(
                                                          builder: (context,
                                                              statePurchase) {
                                                            if (statePurchase
                                                                is PurchaseInitial) {
                                                              return GestureDetector(
                                                                onTap: () {
                                                                  _purchaseBloc.add(
                                                                      FetchPurchase(state
                                                                          .eventDetails
                                                                          .uuid!));
                                                                },
                                                                child:
                                                                    Container(
                                                                  width: double
                                                                      .infinity,
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          10),
                                                                  decoration: BoxDecoration(
                                                                      color: Colors
                                                                          .blue,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10)),
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        horizontal:
                                                                            20.0,
                                                                        vertical:
                                                                            8),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Text(
                                                                          'PAY NOW',
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          style: GoogleFonts.actor(
                                                                              textStyle: const TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize:
                                                                                20,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                          )),
                                                                        ),
                                                                        Text(
                                                                          formatPriceToEuro(state.eventDetails.price! *
                                                                              _counter),
                                                                          style: GoogleFonts.actor(
                                                                              textStyle: const TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize:
                                                                                20,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                          )),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            }
                                                            if (statePurchase
                                                                is PurchaseLoading) {
                                                              return const Center(
                                                                child:
                                                                    CircularProgressIndicator(),
                                                              );
                                                            }
                                                            if (statePurchase
                                                                is PurchaseSuccess) {
                                                              Navigator.pop(
                                                                  context);
                                                              WidgetsBinding
                                                                  .instance
                                                                  .addPostFrameCallback(
                                                                      (_) {
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                  SnackBar(
                                                                    content:
                                                                        Container(
                                                                      padding:
                                                                          const EdgeInsets
                                                                              .symmetric(
                                                                        vertical:
                                                                            12.0,
                                                                        horizontal:
                                                                            16.0,
                                                                      ),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: Colors
                                                                            .white,
                                                                        borderRadius:
                                                                            BorderRadius.circular(8.0),
                                                                        boxShadow: [
                                                                          BoxShadow(
                                                                            color:
                                                                                Colors.black.withOpacity(0.2),
                                                                            blurRadius:
                                                                                6.0,
                                                                            offset:
                                                                                const Offset(0, 3),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      child:
                                                                          const Text(
                                                                        '¡Compra exitosa!',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                18.0,
                                                                            color:
                                                                                Colors.black),
                                                                      ),
                                                                    ),
                                                                    duration: const Duration(
                                                                        seconds:
                                                                            4), // Ajusta la duración según tus necesidades
                                                                    backgroundColor:
                                                                        Colors
                                                                            .transparent, // Fondo transparente para eliminar el fondo del SnackBar
                                                                    elevation:
                                                                        0, // Sin elevación para que la sombra personalizada se aplique
                                                                    behavior:
                                                                        SnackBarBehavior
                                                                            .floating, // SnackBar flotante
                                                                  ),
                                                                );
                                                              });
                                                            }
                                                            if (statePurchase
                                                                is PurchaseEntityException) {
                                                              return AlertDialog(
                                                                content:
                                                                    Container(
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          10),
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min, // Para que el AlertDialog no sea tan alto
                                                                    children: [
                                                                      Text(
                                                                        statePurchase
                                                                            .generalException
                                                                            .detail!,
                                                                        style:
                                                                            const TextStyle(
                                                                          fontSize:
                                                                              16, // Tamaño de fuente más pequeño
                                                                          color:
                                                                              Colors.red, // Color de fuente rojo
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                          height:
                                                                              10),
                                                                      TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.of(context)
                                                                              .pop(); // Cierra el diálogo
                                                                        },
                                                                        style: TextButton
                                                                            .styleFrom(
                                                                          backgroundColor:
                                                                              Colors.red, // Color de fondo rojo
                                                                          padding: const EdgeInsets
                                                                              .symmetric(
                                                                              vertical: 10), // Ajusta el padding del botón
                                                                        ),
                                                                        child:
                                                                            const Text(
                                                                          'OK',
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                16, // Tamaño de fuente del botón igual al texto del botón 'PAY NOW'
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              );
                                                            }
                                                            if (statePurchase
                                                                is PurchaseError) {
                                                              return Text(
                                                                  statePurchase
                                                                      .errorMessagge);
                                                            } else {
                                                              return const Center(
                                                                  child:
                                                                      CircularProgressIndicator());
                                                            }
                                                          },
                                                        )),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ]),
                                      );
                                    },
                                  )
                                : null;
                          },
                          child: state.eventDetails.maxCapacity! <=
                                  state.eventDetails.students!.length
                              ? Text('SOLD OUT',
                                  style: GoogleFonts.actor(
                                    textStyle: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ))
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'BUY TICKET ${formatPriceToEuro(state.eventDetails.price!)}',
                                      style: GoogleFonts.actor(
                                        textStyle: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(40),
                                        color:
                                            const Color.fromARGB(40, 0, 0, 0),
                                      ),
                                      padding: const EdgeInsets.all(6),
                                      child: const Icon(
                                        Icons.arrow_forward,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ))),
                ),
              );
            } else if (state is EventDetailsLoading ||
                state is EventDetailsInitial) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is TokenNotValidStateEventDetails) {
              Future.microtask(() {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              });
              return const CircularProgressIndicator();
            } else if (state is EventDetailsEntityException) {
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
                return const Text('No se ha encontrado un evento que coincida');
              }
              return Text('${state.generalException.status!}');
            } else if (state is EventDetailsError) {
              return const Text('An unespected error occurred');
            } else {
              return const Text('Not support');
            }
          },
        ));
  }

  Widget fetchImages(EventDetailsResponse eventDetailsResponse) {
    int countImages = 0;
    if (eventDetailsResponse.urlPhotos != null &&
        eventDetailsResponse.urlPhotos!.isNotEmpty) {
      countImages = eventDetailsResponse.urlPhotos!.length;
    }

    if (countImages == 0) {
      return Container(
        height: 250,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/img/card_background.jpg',
            ),
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    if (countImages == 1) {
      return BlocProvider(
        create: (context) => EventImageBloc(eventRepository)
          ..add(FetchEventImage(eventDetailsResponse.uuid!, 0)),
        child: BlocBuilder<EventImageBloc, EventImageState>(
          builder: (context, state) {
            if (state is EventImageInitial || state is EventImageLoading) {
              return const SizedBox(
                height: 250,
                child: Center(child: CircularProgressIndicator()),
              );
            } else if (state is EventImageSuccess) {
              return Container(
                height: 250,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: MemoryImage(state.image),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            } else {
              return Container(
                height: 250,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/img/card_background.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            }
          },
        ),
      );
    }

    List<Widget> imageSliders = List.generate(
      countImages,
      (index) => BlocProvider<EventImageBloc>(
        create: (context) => EventImageBloc(eventRepository)
          ..add(FetchEventImage(eventDetailsResponse.uuid!, index)),
        child: BlocBuilder<EventImageBloc, EventImageState>(
          builder: (context, state) {
            if (state is EventImageInitial || state is EventImageLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is EventImageSuccess) {
              return Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: MemoryImage(state.image),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            } else {
              return Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/img/card_background.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            }
          },
        ),
      ),
    );

    return CarouselSlider(
      items: imageSliders,
      options: CarouselOptions(
        autoPlay: true,
        enlargeCenterPage: true,
        height: 250,
        viewportFraction: 1,
        initialPage: 0,
      ),
    );
  }

  String formatPriceToEuro(double price) {
    String formattedPrice = '${price.toStringAsFixed(2)} €';

    return formattedPrice;
  }

  String truncateString(String str, int num) {
    if (str.length > num) {
      return '${str.substring(0, num)}...';
    } else {
      return str;
    }
  }

  String convertirFormatoFecha(String fechaEnFormatoOriginal) {
    // Parsear la fecha en formato original
    DateTime fecha = DateTime.parse(fechaEnFormatoOriginal);

    // Formatear la fecha en el nuevo formato
    String nuevoFormato = DateFormat('dd MMMM, yyyy').format(fecha);

    return nuevoFormato;
  }

  String convertirFormato(String fechaEnFormatoOriginal) {
    // Parsear la fecha en formato original
    DateTime fecha = DateTime.parse(fechaEnFormatoOriginal);

    // Formatear el día de la semana
    String diaSemana = DateFormat('EEEE').format(fecha);

    // Formatear la hora en formato de 12 horas
    String hora = DateFormat('h').format(fecha);

    // Obtener los minutos
    String minutos = DateFormat('mm').format(fecha);

    // Obtener AM/PM
    String amPm = DateFormat('a').format(fecha);

    // Combinar todo en el formato deseado
    String formatoFinal = '$diaSemana, $hora:$minutos$amPm';

    return formatoFinal;
  }

  void _mostrarNotificacion(BuildContext context) {
    final snackBar = SnackBar(
      content: const Text('¡Hola! Esta es una notificación dentro de la app.'),
      action: SnackBarAction(
        label: 'Cerrar',
        onPressed: () {
          // Al hacer clic en "Cerrar"
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
