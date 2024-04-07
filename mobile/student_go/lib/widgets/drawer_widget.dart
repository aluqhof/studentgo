import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_go/bloc/student/student_bloc.dart';
import 'package:student_go/repository/student/student_repository.dart';
import 'package:student_go/repository/student/student_repository_impl.dart';
import 'package:student_go/screen/events_saved_screen.dart';
import 'package:student_go/screen/home_screen.dart';
import 'package:student_go/screen/login_screen.dart';
import 'package:student_go/screen/my_events_calendar_screen.dart';
import 'package:student_go/screen/profile_screen.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  late StudentRepository studentRepository;
  late StudentBloc _studentBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    studentRepository = StudentRepositoryImp();
    _studentBloc = StudentBloc(studentRepository)..add(FetchStudent());
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: BlocProvider.value(
        value: _studentBloc,
        child: BlocBuilder<StudentBloc, StudentState>(
          builder: (context, state) {
            if (state is StudentInitial || state is StudentLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is StudentSuccess) {
              return Theme(
                data: Theme.of(context).copyWith(
                  dividerTheme: DividerThemeData(
                    thickness: 0, // Elimina los Divider
                  ),
                ),
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    DrawerHeader(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 1,
                                  ),
                                ),
                                child: ClipOval(
                                  child: Image.asset(
                                    'assets/img/fotoprueba2.jpg',
                                    width: 70,
                                    height: 70,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  state.studentInfoResponse.name!,
                                  style: GoogleFonts.actor(
                                    textStyle: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.home_outlined,
                        size: 26,
                      ), // Icono a la izquierda
                      title: Text(
                        'Home',
                        style: GoogleFonts.actor(
                            textStyle: const TextStyle(fontSize: 18)),
                      ),
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.person_outline,
                        size: 26,
                      ), // Icono a la izquierda
                      title: Text(
                        'My Profile',
                        style: GoogleFonts.actor(
                            textStyle: const TextStyle(fontSize: 18)),
                      ),
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProfileScreen(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.calendar_today,
                        size: 26,
                      ), // Icono a la izquierda
                      title: Text(
                        'Calendar',
                        style: GoogleFonts.actor(
                            textStyle: TextStyle(fontSize: 18)),
                      ),
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const MyEventsCalendarScreen(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.bookmark_outline,
                        size: 26,
                      ), // Icono a la izquierda
                      title: Text(
                        'Bookmark',
                        style: GoogleFonts.actor(
                            textStyle: TextStyle(fontSize: 18)),
                      ),
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EventsSavedScreen(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.settings,
                        size: 26,
                      ), // Icono a la izquierda
                      title: Text(
                        'Settings',
                        style: GoogleFonts.actor(
                            textStyle: TextStyle(fontSize: 18)),
                      ),
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.help,
                        size: 26,
                      ), // Icono a la izquierda
                      title: Text(
                        'Helps & FAQ',
                        style: GoogleFonts.actor(
                            textStyle: TextStyle(fontSize: 18)),
                      ),
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.logout_outlined,
                        size: 26,
                      ), // Icono a la izquierda
                      title: Text(
                        'Sign out',
                        style: GoogleFonts.actor(
                            textStyle: TextStyle(fontSize: 18)),
                      ),
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
