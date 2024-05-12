import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_go/bloc/events_saved/events_saved_bloc.dart';
import 'package:student_go/repository/student/student_repository.dart';
import 'package:student_go/repository/student/student_repository_impl.dart';
import 'package:student_go/widgets/drawer_widget.dart';
import 'package:student_go/widgets/vertical_list_v2.dart';

class EventsSavedScreen extends StatefulWidget {
  const EventsSavedScreen({super.key});

  @override
  State<EventsSavedScreen> createState() => _EventsSavedScreenState();
}

class _EventsSavedScreenState extends State<EventsSavedScreen> {
  late StudentRepository studentRepository;
  late EventsSavedBloc _eventListBloc;

  @override
  void initState() {
    super.initState();
    studentRepository = StudentRepositoryImp();

    _eventListBloc = EventsSavedBloc(studentRepository);
    _eventListBloc.add(FetchEventsSaved());
  }

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
            'Bookmarks',
            style: GoogleFonts.actor(
                textStyle:
                    const TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
          ),
        ),
        drawer: const DrawerWidget(),
        body: VerticalListV2(
          bloc: _eventListBloc,
        ));
  }

  @override
  void dispose() {
    _eventListBloc.close();
    super.dispose();
  }
}
