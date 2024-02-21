import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Position? _currentPosition;
  late String _currentCity = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
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
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            const Expanded(
              flex: 1,
              child: Icon(
                Icons.menu_rounded,
                color: Colors.white,
                size: 30,
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: Row(
                    children: [
                      Text(
                        'Current Location',
                        style: GoogleFonts.actor(
                          textStyle: const TextStyle(
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
                  _currentCity,
                  style: GoogleFonts.actor(
                    textStyle: const TextStyle(
                      color: Colors.white,
                    ),
                    fontWeight: FontWeight.w100,
                  ),
                ),
              ],
            ),
            const Expanded(
              flex: 1,
              child: Icon(
                Icons.notifications,
                color: Colors.white,
                size: 25,
              ),
            ),
          ],
          backgroundColor: const Color.fromRGBO(74, 67, 236, 1),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _currentPosition != null
                ? Center(
                    child: Text(
                      'Current Location: ${_currentPosition!.latitude}, ${_currentPosition!.longitude}',
                    ),
                  )
                : Text('Error'));
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
