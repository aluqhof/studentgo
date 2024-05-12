import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_go/bloc/event_list/event_list_bloc.dart';
import 'package:student_go/models/response/event_type_response.dart';
import 'package:student_go/models/response/list_events_response/content.dart';
import 'package:student_go/repository/event/event_repository.dart';
import 'package:student_go/repository/event/event_repository_impl.dart';
import 'package:student_go/screen/login_screen.dart';
import 'package:student_go/widgets/event_card_vertical_list.dart';
import 'package:student_go/widgets/event_type_widget_map.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MapEventsScreen extends StatefulWidget {
  const MapEventsScreen({Key? key}) : super(key: key);

  @override
  State<MapEventsScreen> createState() => _MapEventsScreenState();
}

class _MapEventsScreenState extends State<MapEventsScreen> {
  late EventListBloc _eventListBloc;
  late EventRepository eventRepository;
  String _currentCity = '';
  String _currentCountry = '';
  late CameraPosition _initialCameraPosition;
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  Content? _selectedEvent;
  Set<Marker> _markers = {};
  String name = '';
  late FocusNode focusNode;
  late TextEditingController _searchController;
  bool loadingLocation = true;
  Color colorLocation = const Color.fromARGB(255, 35, 150, 245);
  int? _selectedEventTypeId;
  ValueNotifier<Content?> _selectedEventNotifier = ValueNotifier(null);
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    initialize();
    focusNode = FocusNode();
    _searchController = TextEditingController();
    eventRepository = EventRepositoryImpl();
    _eventListBloc = EventListBloc(eventRepository)
      ..add(FetchUpcomingListSearchableEvent(
          _currentCity,
          name,
          List.empty(),
          DateTime.now(),
          DateTime.now().add(const Duration(days: 365)),
          0,
          1000000));
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
        _currentCountry = placemark.country ?? 'Unknown';
        _eventListBloc = _eventListBloc = EventListBloc(eventRepository)
          ..add(FetchUpcomingListSearchableEvent(
              _currentCity,
              name,
              List.empty(),
              DateTime.now(),
              DateTime.now().add(const Duration(days: 365)),
              0,
              1000000));
        _initialCameraPosition = CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 12,
        );
      });
    } catch (e) {
      throw Exception('Error obtaining location: $e');
    }
  }

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
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

  void updateLocation() async {
    await _getCurrentLocation();

    _eventListBloc.add(FetchUpcomingListSearchableEvent(
        _currentCity,
        '',
        List.empty(),
        DateTime.now(),
        DateTime.now().add(const Duration(days: 365)),
        0,
        1000000));
    setState(() {
      _searchController.text = '';
      colorLocation = const Color.fromARGB(255, 132, 34, 224);
    });
    Fluttertoast.showToast(
        msg: "Current Location: $_currentCity, $_currentCountry",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: const Color.fromARGB(255, 132, 34, 224),
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void filterByEventType(int eventTypeId) {
    if (eventTypeId == -1) {
      _eventListBloc.add(FetchUpcomingListSearchableEvent(
          _currentCity,
          '',
          List.empty(),
          DateTime.now(),
          DateTime.now().add(const Duration(days: 365)),
          0,
          1000000));
      setState(() {
        _searchController.text = '';
        setState(() {
          _selectedEventTypeId = null;
        });
      });
    } else {
      List<int> eventTypeList = [eventTypeId];
      _eventListBloc.add(FetchUpcomingListSearchableEvent(
          _currentCity,
          '',
          eventTypeList,
          DateTime.now(),
          DateTime.now().add(const Duration(days: 365)),
          0,
          1000000));
      setState(() {
        _searchController.text = '';
        setState(() {
          _selectedEventTypeId = eventTypeId;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _eventListBloc,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: BlocBuilder<EventListBloc, EventListState>(
          bloc: _eventListBloc,
          builder: (context, state) {
            if (state is EventListLoading || state is EventListInitial) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is UpcomingListSearchableSuccess) {
              return Stack(
                children: [
                  _buildMap(state.listEventsResponse),
                  ValueListenableBuilder<Content?>(
                    valueListenable: _selectedEventNotifier,
                    builder: (context, value, child) {
                      if (value != null) {
                        return _buildEventCard(
                            value); // Build event card only if there's a selected event
                      } else {
                        return const SizedBox
                            .shrink(); // Return an empty widget if no event is selected
                      }
                    },
                  ),
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
                            child: TypeAheadField<String>(
                              builder: (context, controller, focusNode) {
                                return TextField(
                                    controller: _searchController,
                                    focusNode: focusNode,
                                    autofocus: false,
                                    onSubmitted: (value) {
                                      focusNode.unfocus();
                                      _eventListBloc.add(
                                          FetchUpcomingListSearchableEvent(
                                              _currentCity,
                                              value,
                                              List.empty(),
                                              DateTime.now(),
                                              DateTime.now().add(
                                                  const Duration(days: 365)),
                                              0,
                                              1000000));
                                    },
                                    decoration: InputDecoration(
                                      hintText:
                                          'Find for Music, Food, Sports...',
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide.none,
                                      ),
                                      isDense: true,
                                      contentPadding: const EdgeInsets.all(12),
                                    ));
                              },
                              loadingBuilder: (context) =>
                                  const Text('Loading...'),
                              errorBuilder: (context, error) =>
                                  const Text('Unespected error'),
                              emptyBuilder: (context) => const Text(
                                  'No events found according your query'),
                              suggestionsCallback: (pattern) async {
                                return Future.value(state.listEventsResponse
                                    .where((event) =>
                                        event.name != null &&
                                        event.name!
                                            .toLowerCase()
                                            .contains(pattern.toLowerCase()))
                                    .map((e) => e.name!)
                                    .toList());
                              },
                              itemBuilder: (context, suggestion) {
                                return ListTile(
                                  title: Text(suggestion),
                                );
                              },
                              onSelected: (suggestion) {
                                setState(() {
                                  _searchController.text = suggestion;
                                });
                                focusNode.unfocus();
                                _eventListBloc.add(
                                    FetchUpcomingListSearchableEvent(
                                        _currentCity,
                                        suggestion,
                                        List.empty(),
                                        DateTime.now(),
                                        DateTime.now()
                                            .add(const Duration(days: 365)),
                                        0,
                                        1000000));
                              },
                              /*transitionBuilder:
                                  (context, suggestionsBox, controller) {
                                return suggestionsBox;
                              },*/
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                updateLocation();
                              },
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
                                ),
                                padding: const EdgeInsets.all(8),
                                child: Icon(
                                  Icons.my_location,
                                  color: colorLocation,
                                ),
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
                      child: EventTypeWidgetMap(
                        onPressed: (int id) {
                          filterByEventType(id);
                        },
                        selectedEventTypeId: _selectedEventTypeId,
                      ),
                    ),
                  ),
                ],
              );
            } else if (state is UpcomingListSearchableError) {
              return Center(child: Text(state.errorMessage));
            } else if (state is TokenNotValidState) {
              Future.microtask(() {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              });
              return const Center(child: CircularProgressIndicator());
            } else if (state is UpcomingListsearchableEntityException) {
              if (state.generalException.status == 404) {
                return SizedBox(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment
                        .center, // This is already set for vertical alignment
                    crossAxisAlignment: CrossAxisAlignment
                        .center, // Aligns the children to the center of the column.
                    children: [
                      Container(
                        width: 200.0, // Sets the width of the container to 200
                        height:
                            200.0, // Sets the height of the container to 200
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
                          height:
                              20), // Adds space between the image and the text.
                      Text(
                        'There are currently no events in your city', // Replace with your desired text
                        style: GoogleFonts.actor(
                            textStyle: const TextStyle(
                          fontSize: 20, // Sets the font size of the text
                          fontWeight: FontWeight.bold, // Makes the text bold
                        )),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }
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
              return Center(child: Text(state.generalException.detail!));
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
                initialCameraPosition: events.length != 1
                    ? _initialCameraPosition
                    : CameraPosition(
                        target:
                            LatLng(events[0].latitude!, events[0].longitude!),
                        zoom: 12,
                      ),
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
          _selectedEventNotifier.value =
              result; // This will only update the notifier
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

  Widget _buildEventCard(Content event) {
    return Positioned(
      bottom: 16,
      left: 16,
      right: 16,
      child: EventCardVerticalList(
        result: event,
      ),
    );
  }
}
