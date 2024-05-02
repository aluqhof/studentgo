import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_go/widgets/drawer_widget.dart';

class MyTicketsPage extends StatefulWidget {
  const MyTicketsPage({super.key});

  @override
  State<MyTicketsPage> createState() => _MyTicketsPageState();
}

class _MyTicketsPageState extends State<MyTicketsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(
                Icons.menu_rounded,
                color: Color.fromARGB(255, 0, 0, 0),
                size: 30,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
          title: Text(
            'My Tickets',
            style: GoogleFonts.actor(),
          ),
        ),
        drawer: const DrawerWidget(),
        body: const Center(
          child: Text('My Tickets'),
        ));
  }
}
