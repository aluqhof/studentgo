import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:student_go/bloc/all_events_calendar/all_events_calendar_bloc.dart';
import 'package:student_go/models/response/event_type_response.dart';
import 'package:student_go/models/response/list_events_response/content.dart';
import 'package:student_go/repository/event/event_repository.dart';
import 'package:student_go/repository/event/event_repository_impl.dart';
import 'package:student_go/widgets/event_card_vertical_list.dart';
import 'package:student_go/widgets/event_type_widget_map.dart';

class MapEventsScreen extends StatefulWidget {
  const MapEventsScreen({Key? key}) : super(key: key);

  @override
  State<MapEventsScreen> createState() => _MapEventsScreenState();
}

class _MapEventsScreenState extends State<MapEventsScreen> {
  late AllEventsCalendarBloc _calendarBloc;
  late EventRepository eventRepository;
  late String _currentCity = '';
  late CameraPosition _initialCameraPosition;
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  Content? _selectedEvent;
  Set<Marker> _markers = {};
  bool _showEventCard = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    eventRepository = EventRepositoryImpl();
    _calendarBloc = AllEventsCalendarBloc(eventRepository);
  }

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
        _calendarBloc = AllEventsCalendarBloc(eventRepository)
          ..add(FetchAllEventsCalendar(_currentCity));
        _initialCameraPosition = CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 12,
        );
      });
    } catch (e) {
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
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _calendarBloc,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: BlocBuilder<AllEventsCalendarBloc, AllEventsCalendarState>(
          bloc: _calendarBloc,
          builder: (context, state) {
            if (state is AllEventsCalendarLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is AllEventsCalendarSuccess) {
              return Stack(
                children: [
                  _buildMap(state.events),
                  if (_showEventCard) _buildEventCard(),
                  Positioned(
                    top: 40,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Find for Music, Food, Sports...',
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                                isDense: true, // Added this
                                contentPadding: const EdgeInsets.all(12),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 1,
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color.fromARGB(255, 255, 255, 255),
                              ),
                              padding: const EdgeInsets.all(8),
                              child: const Icon(
                                Icons.my_location,
                                color: Colors.blue,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 95,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: const EventTypeWidgetMap(),
                    ),
                  ),
                ],
              );
            } else if (state is AllEventsCalendarError) {
              return Center(child: Text(state.errorMessage));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Widget _buildMap(List<Content> events) {
    return FutureBuilder<Set<Marker>>(
      future: _createMarkers(events),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          _markers = snapshot.data!;
          return Stack(
            children: [
              GoogleMap(
                mapType: MapType.terrain,
                initialCameraPosition: _initialCameraPosition,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
                zoomControlsEnabled: false,
                markers: snapshot.data!,
              ),
            ],
          );
        }
      },
    );
  }

  Future<Set<Marker>> _createMarkers(List<Content> events) async {
    List<Marker> markers = [];
    for (var result in events) {
      List<EventTypeResponse> eventTypes = result.eventType!;
      final Uint8List markerIcon = await _createMarkerIcon(
          eventTypes[0].iconRef!, eventTypes[0].colorCode!);
      final marker = Marker(
        markerId: MarkerId(result.uuid.toString()),
        position: LatLng(result.latitude!, result.longitude!),
        icon: BitmapDescriptor.fromBytes(markerIcon),
        onTap: () {
          setState(() {
            _showEventCard = true;
            _selectedEvent = result;
          });
        },
      );
      markers.add(marker);
    }
    return markers.toSet();
  }

  Future<Uint8List> _createMarkerIcon(String iconRef, String color) async {
    const double iconSize = 120;
    const double squareSize = 160;
    const double pinSize = 24;
    const double pinWidth = 40;
    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    final Paint whitePaint = Paint()..color = Colors.white;
    final RRect whiteRect = RRect.fromLTRBR(
      0,
      0,
      squareSize,
      squareSize,
      const Radius.circular(30),
    );
    canvas.drawRRect(whiteRect, whitePaint);

    final Paint colorPaint = Paint()..color = Color(int.parse(color));
    final RRect colorRect = RRect.fromLTRBR(
      (squareSize - iconSize) / 2,
      (squareSize - iconSize) / 2,
      (squareSize + iconSize) / 2,
      (squareSize + iconSize) / 2,
      const Radius.circular(30),
    );
    canvas.drawRRect(colorRect, colorPaint);

    final IconData iconData =
        IconData(int.parse(iconRef), fontFamily: 'MaterialIcons');
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(iconData.codePoint),
        style: TextStyle(
          color: Colors.white,
          fontSize: iconSize * 0.8,
          fontFamily: iconData.fontFamily,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        (squareSize - textPainter.width) / 2,
        (squareSize - textPainter.height) / 2,
      ),
    );

    final Paint pinPaint = Paint()..color = Colors.white;
    final Path pinPath = Path()
      ..moveTo(squareSize / 2 - pinWidth / 2, squareSize)
      ..lineTo(squareSize / 2 + pinWidth / 2, squareSize)
      ..lineTo(squareSize / 2, squareSize + pinSize)
      ..close();
    canvas.drawPath(pinPath, pinPaint);

    final img = await pictureRecorder.endRecording().toImage(
          squareSize.toInt(),
          squareSize.toInt() + pinSize.toInt(),
        );
    final ByteData? byteData =
        await img.toByteData(format: ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  Widget _buildEventCard() {
    return Positioned(
        bottom: 16,
        left: 16,
        right: 16,
        child: EventCardVerticalList(
          result: _selectedEvent!,
        ));
  }
}
