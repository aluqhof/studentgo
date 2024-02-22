import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_go/bloc/event_type/event_type_bloc.dart';
import 'package:student_go/models/response/event_type_response.dart';
import 'package:student_go/repository/event_type/event_type_repository.dart';
import 'package:student_go/repository/event_type/event_type_repository_impl.dart';
import 'package:student_go/widgets/event_type_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Position? _currentPosition;
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
        _currentPosition = position;
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

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
    Text(
      'Index 3: Profile',
      style: optionStyle,
    )
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _eventTypeBloc,
      child: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            Flexible(
              child: Row(
                children: [
                  const Expanded(
                    flex: 1,
                    child: Icon(
                      Icons.menu_rounded,
                      color: Colors.white,
                      size: 30,
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
                ],
              ),
            ),
          ],
          backgroundColor: const Color.fromRGBO(74, 67, 236, 1),
        ),
        body: Stack(clipBehavior: Clip.none, children: [
          Container(
            decoration: const BoxDecoration(
                color: Color.fromRGBO(74, 67, 236, 1),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                )),
            height: 100,
            child: Padding(
              padding: const EdgeInsets.only(left: 30, right: 30, bottom: 20),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextField(
                      decoration: InputDecoration(
                        icon: const Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 30,
                        ),
                        hintText: ' Search...',
                        hintStyle: const TextStyle(
                          color: Color.fromRGBO(255, 255, 255, 0.2),
                          fontSize: 20,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
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
                          child: const Icon(Icons.filter_list,
                              size: 22, color: Color.fromRGBO(93, 86, 243, 1))),
                      label: Text(
                        'Filters',
                        style: GoogleFonts.actor(),
                      ),
                      style: ElevatedButton.styleFrom(
                        foregroundColor:
                            const Color.fromARGB(255, 255, 255, 255),
                        backgroundColor: const Color.fromRGBO(93, 86, 243, 1),
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
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 40,
              child: BlocBuilder<EventTypeBloc, EventTypeState>(
                builder: (context, state) {
                  if (state is EventTypeInitial) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is EventTypeError) {
                    return Text(state.errorMessage);
                  } else if (state is EventTypeSuccess) {
                    return _eventTypeListView(
                        context, state.eventTypeResponseList);
                  } else {
                    return const Text('Not support');
                  }
                },
              ),
              /* ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  BlocProvider.value(value: _eventTypeBloc, child: BlocConsumer<EventTypeBloc, EventTypeState>(buildWhen: (context, state) {
                    return state is EventTypeInitial || state is EventTypeSuccess || state is EventTypeError || state is EventTypeLoading;
                  },
                  builder: (context, state) {
                    if(state is EventTypeSuccess){
                      return EventTypeWidget(eventType: state.)
                    }
                  },),),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 3.5,
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.music_note,
                            size: 22, color: Color.fromRGBO(255, 255, 255, 1)),
                        label: Text(
                          'Music',
                          style: GoogleFonts.actor(
                              textStyle: const TextStyle(
                                  color: Colors.white, fontSize: 15)),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(245, 151, 98, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 3.5,
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.restaurant_menu,
                            size: 22, color: Color.fromRGBO(255, 255, 255, 1)),
                        label: Text(
                          'Food',
                          style: GoogleFonts.actor(
                              textStyle: const TextStyle(
                                  color: Colors.white, fontSize: 15)),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(41, 214, 151, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 3.5,
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.sports_basketball,
                            size: 22, color: Color.fromRGBO(255, 255, 255, 1)),
                        label: Text(
                          'Gaming',
                          style: GoogleFonts.actor(
                              textStyle: const TextStyle(
                                  color: Colors.white, fontSize: 15)),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(70, 205, 251, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),*/
            ),
          ),
        ]),
        bottomNavigationBar: BottomNavigationBar(
          selectedLabelStyle:
              GoogleFonts.actor(textStyle: const TextStyle(fontSize: 13)),
          unselectedLabelStyle:
              GoogleFonts.actor(textStyle: const TextStyle(fontSize: 13)),
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.explore),
              label: 'Explore',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month),
              label: 'Events',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.location_on),
              label: 'Map',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          unselectedItemColor: const Color.fromRGBO(44, 53, 80, 0.3),
          selectedItemColor: const Color.fromRGBO(86, 105, 255, 1),
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

Widget _eventTypeListView(
    BuildContext context, List<EventTypeResponse> eventTypeList) {
  return ListView.builder(
    scrollDirection: Axis.horizontal,
    itemBuilder: (BuildContext context, int index) {
      return EventTypeWidget(eventType: eventTypeList[index]);
    },
    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
    itemCount: eventTypeList.length,
  );
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
