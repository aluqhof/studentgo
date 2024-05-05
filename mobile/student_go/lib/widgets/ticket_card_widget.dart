import 'dart:ffi';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:student_go/bloc/event_image/event_image_bloc.dart';
import 'package:student_go/models/response/purchase_overview_response/purchase_overview_response.dart';
import 'package:student_go/repository/event/event_repository.dart';
import 'package:student_go/repository/event/event_repository_impl.dart';
import 'package:student_go/widgets/ticket_data.dart';
import 'package:ticket_widget/ticket_widget.dart';

class TicketCardWidget extends StatefulWidget {
  final PurchaseOverviewResponse purchaseOverviewResponse;
  const TicketCardWidget({super.key, required this.purchaseOverviewResponse});

  @override
  State<TicketCardWidget> createState() => _TicketCardWidgetState();
}

class _TicketCardWidgetState extends State<TicketCardWidget> {
  Position? position;
  late String _street = '';
  late String _city = '';
  late String _postalCode = '';
  late EventRepository _eventRepository;
  late EventImageBloc _eventImageBloc;
  bool loading = true;

  Future<void> _getStreet() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        widget.purchaseOverviewResponse.latitude!,
        widget.purchaseOverviewResponse.longitude!,
      );
      Placemark placemark = placemarks.first;
      setState(() {
        _street = placemark.street ?? 'Unknown';
        _postalCode = placemark.postalCode ?? '00000';
        _city = placemark.locality ?? 'Unknown';
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
    _getStreet();
    _eventRepository = EventRepositoryImpl();
    _eventImageBloc = EventImageBloc(_eventRepository)
      ..add(FetchEventImage(widget.purchaseOverviewResponse.eventId!, 0));
    _eventImageBloc.stream.listen((state) {
      if (state is EventImageSuccess || state is EventImageError) {
        setState(() {
          loading = false;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> formats =
        obtenerFormatos(widget.purchaseOverviewResponse.dateTime!);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10),
      child: Skeletonizer(
        enabled: loading,
        child: GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  child: TicketWidget(
                    width: 350,
                    height: 500,
                    isCornerRounded: true,
                    padding: const EdgeInsets.all(20),
                    child: TicketData(
                      purchaseId: widget.purchaseOverviewResponse.purchaseId!,
                    ),
                  ),
                );
              },
            );
          },
          child: Container(
            width: double.infinity,
            height: 160.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Colors.transparent,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: BlocProvider.value(
                value: _eventImageBloc,
                child: Stack(
                  children: [
                    BlocBuilder<EventImageBloc, EventImageState>(
                      builder: (context, state) {
                        if (state is EventImageInitial ||
                            state is EventImageLoading) {
                          return const SizedBox();
                        } else if (state is EventImageSuccess) {
                          return Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: MemoryImage(state.image),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        } else {
                          return Container(
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                    'assets/img/card_background.jpg'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                    BackdropFilter(
                      filter: ImageFilter.blur(
                          sigmaX: 5.0, sigmaY: 5.0), // Apply blur effect
                      child: Container(
                        color: Colors.black.withOpacity(
                            0.5), // This container must be translucent
                      ),
                    ),
                    Positioned(
                      top: 15, // Adjust these values as needed for your design
                      left: 12,
                      child: BlocBuilder<EventImageBloc, EventImageState>(
                        builder: (context, state) {
                          if (state is EventImageInitial ||
                              state is EventImageLoading) {
                            return SizedBox();
                          } else if (state is EventImageSuccess) {
                            return Container(
                              width: 80.0, // Set the size of the small image
                              height: 60.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    10.0), // Rounded corners for the small image
                                image: DecorationImage(
                                  image: MemoryImage(state
                                      .image), // Same image as the background
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          } else {
                            return Container(
                              width: 80.0, // Set the size of the small image
                              height: 60.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    10.0), // Rounded corners for the small image
                                image: const DecorationImage(
                                  image: AssetImage(
                                      'assets/img/card_background.jpg'), // Same image as the background
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    Positioned(
                      top: 15,
                      left: 106,
                      child: SizedBox(
                        width: 200,
                        child: Text('Order Reference #1001',
                            style: GoogleFonts.actor(
                                textStyle: const TextStyle(
                                    fontSize: 14,
                                    color: Color.fromARGB(255, 255, 255, 255))),
                            textAlign: TextAlign
                                .left), // Text aligned left within the container
                      ),
                    ),
                    Positioned(
                      top: 15,
                      right: 2,
                      child: SizedBox(
                        width: 80,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          child: Text(formats[1],
                              style: GoogleFonts.actor(
                                  textStyle: const TextStyle(
                                      fontSize: 18,
                                      color:
                                          Color.fromARGB(255, 199, 198, 198))),
                              textAlign: TextAlign.left),
                        ), // Text aligned left within the container
                      ),
                    ),
                    Positioned(
                      top: 26,
                      right: 4,
                      child: SizedBox(
                        width:
                            80, // Forces the container to take all available width
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(formats[0],
                              style: GoogleFonts.actor(
                                  textStyle: const TextStyle(
                                      fontSize: 34, color: Colors.white)),
                              textAlign: TextAlign.left),
                        ), // Text aligned left within the container
                      ),
                    ),
                    Positioned(
                      top: 56,
                      left: 96,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        child: Text(formats[2],
                            style: GoogleFonts.actor(
                                textStyle: const TextStyle(
                                    fontSize: 14,
                                    color: Color.fromARGB(255, 199, 198, 198))),
                            textAlign: TextAlign.left),
                      ),
                    ),
                    Positioned(
                      top: 76,
                      left: 96,
                      child: SizedBox(
                        width: 300,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          child: Text(
                            widget.purchaseOverviewResponse.name!,
                            style: GoogleFonts.actor(
                                textStyle: const TextStyle(
                                    fontSize: 26,
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontWeight: FontWeight.w500,
                                    height: 1)),
                            textAlign: TextAlign.left,
                          ),
                        ), // Text aligned left within the container
                      ),
                    ),
                    Positioned(
                      top: 130,
                      left: 96,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        child: Text(_city == '' ? _street : '$_street - $_city',
                            style: GoogleFonts.actor(
                                textStyle: const TextStyle(
                                    fontSize: 14,
                                    color: Color.fromARGB(255, 199, 198, 198))),
                            textAlign: TextAlign.left),
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
  }

  List<String> obtenerFormatos(String dateTimeString) {
    // Parsear la cadena de fecha en un objeto DateTime
    DateTime dateTime = DateTime.parse(dateTimeString);

    // Obtener el día del mes
    String dayOfMonth = dateTime.day.toString();

    // Obtener las tres primeras letras del mes en mayúsculas
    String monthAbbreviation = _getMonthAbbreviation(dateTime.month);

    // Obtener el día de la semana y la hora en el formato solicitado
    String dayOfWeekAndTime = _getDayOfWeekAndTime(dateTime);

    // Devolver los formatos en una lista
    return [dayOfMonth, monthAbbreviation, dayOfWeekAndTime];
  }

  String _getMonthAbbreviation(int month) {
    switch (month) {
      case 1:
        return 'JAN';
      case 2:
        return 'FEB';
      case 3:
        return 'MAR';
      case 4:
        return 'APR';
      case 5:
        return 'MAY';
      case 6:
        return 'JUN';
      case 7:
        return 'JUL';
      case 8:
        return 'AUG';
      case 9:
        return 'SEP';
      case 10:
        return 'OCT';
      case 11:
        return 'NOV';
      case 12:
        return 'DEC';
      default:
        return '';
    }
  }

  String _getDayOfWeekAndTime(DateTime dateTime) {
    String dayOfWeek = _getDayOfWeek(dateTime.weekday);
    String time =
        "${_formatTwoDigits(dateTime.hour)}:${_formatTwoDigits(dateTime.minute)}";
    return "$dayOfWeek - $time";
  }

  String _getDayOfWeek(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'Mon';
      case DateTime.tuesday:
        return 'Tue';
      case DateTime.wednesday:
        return 'Wed';
      case DateTime.thursday:
        return 'Thu';
      case DateTime.friday:
        return 'Fri';
      case DateTime.saturday:
        return 'Sat';
      case DateTime.sunday:
        return 'Sun';
      default:
        return '';
    }
  }

  String _formatTwoDigits(int value) {
    return value.toString().padLeft(2, '0');
  }
}
