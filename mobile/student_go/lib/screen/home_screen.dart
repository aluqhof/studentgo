import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_go/screen/events_calendar_screen.dart';
import 'package:student_go/screen/explore_screen.dart';
import 'package:student_go/screen/map_events_screen.dart';
import 'package:student_go/screen/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    ExploreScreen(),
    EventsCalendarScreen(),
    MapEventsScreen(),
    ProfileScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
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
    );
  }
}
