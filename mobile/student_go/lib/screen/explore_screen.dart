import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_go/bloc/event_type/event_type_bloc.dart';
import 'package:student_go/bloc/student/student_bloc.dart';
import 'package:student_go/models/response/event_type_response.dart';
import 'package:student_go/repository/event_type/event_type_repository.dart';
import 'package:student_go/repository/event_type/event_type_repository_impl.dart';
import 'package:student_go/repository/student/student_repository.dart';
import 'package:student_go/repository/student/student_repository_impl.dart';
import 'package:student_go/screen/login_screen.dart';
import 'package:student_go/screen/profile_screen.dart';
import 'package:student_go/screen/search_screen.dart';
import 'package:student_go/widgets/according_horizontal_list.dart';
import 'package:student_go/widgets/drawer_widget.dart';
import 'package:student_go/widgets/upcoming_horizontal_list.dart';
import 'package:student_go/widgets/event_type_widget.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({Key? key}) : super(key: key);

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  late String _currentCity = '';
  late String _currentCountry = '';
  bool _isLoading = true;
  late EventTypeRepository eventTypeRepository;
  late EventTypeBloc _eventTypeBloc;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    eventTypeRepository = EventTypeRepositoryImpl();
    _eventTypeBloc = EventTypeBloc(eventTypeRepository)
      ..add(FetchEventTypeEvent());
  }

  @override
  void dispose() {
    _eventTypeBloc.close();
    super.dispose();
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
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      throw Exception('Error obtaining location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _eventTypeBloc,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: <Widget>[
            Flexible(
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 6.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Builder(
                          builder: (BuildContext context) {
                            return IconButton(
                              icon: const Icon(
                                Icons.menu_rounded,
                                color: Colors.white,
                                size: 30,
                              ),
                              onPressed: () {
                                Scaffold.of(context).openDrawer();
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 6.0),
                        child: Row(
                          children: [
                            Text(
                              'Current Location',
                              style: GoogleFonts.actor(
                                textStyle: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.white,
                            )
                          ],
                        ),
                      ),
                      Text(
                        '$_currentCity${_currentCountry != '' ? ', $_currentCountry' : ''}',
                        style: GoogleFonts.actor(
                          textStyle: const TextStyle(
                              color: Colors.white, fontSize: 15),
                          fontWeight: FontWeight.w100,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromRGBO(93, 86, 243, 1),
                          ),
                          child: const Icon(
                            Icons.notifications_none_outlined,
                            color: Color.fromARGB(255, 255, 255, 255),
                            size: 25,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          backgroundColor: const Color.fromRGBO(74, 67, 236, 1),
        ),
        drawer: const DrawerWidget(),
        body: (!_isLoading)
            ? SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(74, 67, 236, 1),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30),
                            ),
                          ),
                          height: 100,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 30, right: 30, bottom: 20),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: TextField(
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      icon: const Icon(
                                        Icons.search,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                      hintText: ' Search...',
                                      hintStyle: const TextStyle(
                                        color:
                                            Color.fromRGBO(255, 255, 255, 0.2),
                                        fontSize: 20,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => SearchScreen(
                                                  currentCity: _currentCity,
                                                )),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  flex: 1,
                                  child: ElevatedButton.icon(
                                    onPressed: () {},
                                    icon: Container(
                                      width: 25,
                                      height: 25,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color.fromRGBO(162, 158, 240, 1),
                                      ),
                                      child: const Icon(
                                        Icons.filter_list,
                                        size: 22,
                                        color: Color.fromRGBO(93, 86, 243, 1),
                                      ),
                                    ),
                                    label: FittedBox(
                                      fit: BoxFit
                                          .scaleDown, // Ajusta el tamaño del texto para que quepa dentro del espacio disponible
                                      child: Text(
                                        'Filters',
                                        style: GoogleFonts.actor(),
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: const Color.fromARGB(
                                          255, 255, 255, 255),
                                      backgroundColor:
                                          const Color.fromRGBO(93, 86, 243, 1),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 80,
                          child: Column(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: 40,
                                child:
                                    BlocBuilder<EventTypeBloc, EventTypeState>(
                                  builder: (context, state) {
                                    if (state is EventTypeInitial) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    } else if (state is EventTypeError) {
                                      return Text(state.errorMessage);
                                    } else if (state is EventTypeSuccess) {
                                      return _eventTypeListView(
                                        context,
                                        state.eventTypeResponseList,
                                      );
                                    } else {
                                      return const Text('Not support');
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0, bottom: 20),
                          child:
                              AccordingHorizontalList(cityName: _currentCity),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: UpcomingHorizontalList(cityName: _currentCity),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }

  Widget _eventTypeListView(
      BuildContext context, List<EventTypeResponse> eventTypeList) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int index) {
        return EventTypeWidget(
            eventType: eventTypeList[index], cityName: _currentCity);
      },
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      itemCount: eventTypeList.length,
    );
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
