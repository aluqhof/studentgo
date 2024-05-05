import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_go/bloc/purchase_ticket/purchase_ticket_bloc.dart';
import 'package:student_go/models/response/purchase_ticket_response/purchase_ticket_response.dart';
import 'package:student_go/repository/purchase/purchase_repository.dart';
import 'package:student_go/repository/purchase/purchase_repository_impl.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TicketData extends StatefulWidget {
  final String purchaseId;
  const TicketData({super.key, required this.purchaseId});

  @override
  State<TicketData> createState() => _TicketDataState();
}

class _TicketDataState extends State<TicketData> {
  late PurchaseRepository purchaseRepository;
  late PurchaseTicketBloc _purchaseTicketBloc;
  late String _street = '';
  late String _city = '';
  late String _postalCode = '';

  Future<void> _getStreet(PurchaseTicketResponse purchaseTicketResponse) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        purchaseTicketResponse.latitude!,
        purchaseTicketResponse.longitude!,
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
    purchaseRepository = PurchaseRepositoryImpl();
    _purchaseTicketBloc = PurchaseTicketBloc(purchaseRepository)
      ..add(FetchPruchaseTicket(widget.purchaseId));
    _purchaseTicketBloc.stream.listen((state) {
      if (state is PurchaseTicketSuccess) {
        _getStreet(state.purchaseTicket);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _purchaseTicketBloc,
      child: BlocBuilder<PurchaseTicketBloc, PurchaseTicketState>(
        builder: (context, state) {
          if (state is PurchaseTicketInitial ||
              state is PurchaseTicketLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is PurchaseTicketSuccess) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 5,
                      //height: 25.0,
                      child: Wrap(
                        spacing: 8.0, // Spacing between chips
                        runSpacing: 8.0, // Spacing between rows
                        direction: Axis.horizontal,
                        children: List.generate(
                          state.purchaseTicket.eventType!.length,
                          (index) {
                            return Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                      width: 1.0,
                                      color: Color(int.parse(state
                                          .purchaseTicket
                                          .eventType![index]
                                          .colorCode!)))),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 15),
                              child: Text(
                                state.purchaseTicket.eventType![index].name!,
                                style: GoogleFonts.actor(
                                    textStyle: TextStyle(
                                        color: Color(int.parse(state
                                            .purchaseTicket
                                            .eventType![index]
                                            .colorCode!)),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12)),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Image.asset('assets/img/logo.png', width: 30)
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text(
                    state.purchaseTicket.eventName!,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ticketDetailsWidget(
                          'Participant',
                          state.purchaseTicket.participant!,
                          'Date',
                          personalizeDateFormat(
                              state.purchaseTicket.eventDate!)),
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: ticketDetailsWidget(
                            'Price',
                            formatToEuro(state.purchaseTicket.price!),
                            'Hour',
                            obtainHourFormat(state.purchaseTicket.eventDate!)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: ticketDetailsWidget(
                            'Place',
                            _city == '' ? _street : '$_street - $_city',
                            'Reference',
                            '#1001'),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 10.0, left: 30.0, right: 30.0),
                  child: state.purchaseTicket.qrCode != null
                      ? Center(
                          child: QrImageView(
                          data: state.purchaseTicket.qrCode!,
                          version: QrVersions.auto,
                          size: 160.0,
                        ))
                      : SizedBox(),
                ),
              ],
            );
          } else {
            return const Center(
              child: Text('Error'),
            );
          }
        },
      ),
    );
  }

  String formatToEuro(double numero) {
    String numeroRedondeado = numero.toStringAsFixed(2);

    String numeroEnEuros = '$numeroRedondeado €';

    return numeroEnEuros;
  }

  String personalizeDateFormat(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);

    int day = dateTime.day;
    int month = dateTime.month;
    int year = dateTime.year;

    String formattedDate = '$day-${_padNumber(month)}-$year';

    return formattedDate;
  }

  String obtainHourFormat(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);

    int hour = dateTime.hour;
    int minute = dateTime.minute;

    String formattedTime = '${_padNumber(hour)}:${_padNumber(minute)}';

    return formattedTime;
  }

  String _padNumber(int number) {
    return number.toString().padLeft(2, '0');
  }
}

Widget ticketDetailsWidget(String firstTitle, String firstDesc,
    String secondTitle, String secondDesc) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      Expanded(
        flex: 2,
        child: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                firstTitle,
                style: const TextStyle(color: Colors.grey),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Flexible(
                  child: Text(
                    firstDesc,
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                secondTitle,
                style: const TextStyle(color: Colors.grey),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Flexible(
                  child: Text(
                    secondDesc,
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              )
            ],
          ),
        ),
      )
    ],
  );
}
