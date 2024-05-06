import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_go/bloc/profile_image/profile_image_bloc.dart';
import 'package:student_go/bloc/student/student_bloc.dart';
import 'package:student_go/repository/student/student_repository.dart';
import 'package:student_go/repository/student/student_repository_impl.dart';
import 'package:student_go/screen/edit_profile_screen.dart';
import 'package:student_go/screen/login_screen.dart';
import 'package:student_go/widgets/drawer_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late StudentRepository studentRepository;
  late StudentBloc _studentBloc;
  late ProfileImageBloc _profileImageBloc;

  @override
  void initState() {
    studentRepository = StudentRepositoryImp();
    _studentBloc = StudentBloc(studentRepository)..add(FetchStudent());
    _profileImageBloc = ProfileImageBloc(studentRepository)
      ..add(FetchProfileImage());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _studentBloc),
        BlocProvider.value(value: _profileImageBloc)
      ],
      child: Scaffold(
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
            'Profile',
            style: GoogleFonts.actor(),
          ),
        ),
        drawer: const DrawerWidget(),
        body: BlocBuilder<StudentBloc, StudentState>(builder: (context, state) {
          if (state is StudentLoading || state is StudentInitial) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is StudentSuccess) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Center(
                    child: BlocBuilder<ProfileImageBloc, ProfileImageState>(
                      builder: (context, stateImage) {
                        if (stateImage is ProfileImageInitial ||
                            stateImage is ProfileImageLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (stateImage is ProfileImageSuccess) {
                          return Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 1,
                              ),
                            ),
                            child: ClipOval(
                              child: Image.memory(
                                stateImage.image,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        } else {
                          return Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 1,
                              ),
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                'assets/img/nophoto.png',
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Center(
                      child: Text(
                        state.studentInfoResponse.name!,
                        style: GoogleFonts.actor(
                            textStyle: const TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ),
                  Center(
                    child: IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              const Text(
                                '234',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Text(
                                'Following',
                                style: GoogleFonts.actor(),
                              )
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: SizedBox(
                              height: 30,
                              child: VerticalDivider(
                                  color: Colors.grey, thickness: 1),
                            ),
                          ),
                          Column(
                            children: [
                              const Text('234',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                              Text(
                                'Followers',
                                style: GoogleFonts.actor(),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        surfaceTintColor: const Color.fromARGB(
                            0, 255, 255, 255), // Color de fondo blanco
                        foregroundColor: const Color.fromRGBO(
                            86, 105, 255, 1), // Color del texto
                        side: const BorderSide(
                            color: Color.fromRGBO(86, 105, 255, 1),
                            width: 1), // Borde de color morado
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(10), // Bordes redondeados
                        ),
                      ),
                      onPressed: () {
                        _navigateAndRefreshProfile(context);
                      },
                      icon: const Icon(
                        Icons.edit_outlined,
                        size: 24.0,
                      ),
                      label: Text(
                        'Edit Profile',
                        style: GoogleFonts.actor(
                            textStyle: const TextStyle(fontSize: 16)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'About me',
                        style: GoogleFonts.actor(
                            textStyle: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          state.studentInfoResponse.description != null
                              ? state.studentInfoResponse.description!
                              : 'Let other users know something about you...',
                          style: GoogleFonts.actor(
                              textStyle: const TextStyle(fontSize: 15)),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Interest',
                          style: GoogleFonts.actor(
                              textStyle: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20))),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Wrap(
                        spacing: 8.0, // Spacing between chips
                        runSpacing: 8.0, // Spacing between rows
                        direction: Axis.horizontal,
                        children: List.generate(
                          state.studentInfoResponse.interests!.length,
                          (index) {
                            return Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Color(int.parse(state
                                      .studentInfoResponse
                                      .interests![index]
                                      .colorCode!))),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 15),
                              child: Text(
                                state.studentInfoResponse.interests![index]
                                    .name!,
                                style: GoogleFonts.actor(
                                    textStyle: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700)),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          } else if (state is StudentGeneralException) {
            return Text(state.errorMessage);
          } else if (state is TokenNotValidState) {
            Future.microtask(() {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            });
            return const CircularProgressIndicator();
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }),
      ),
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const EditProfileScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0); // Comienza desde el lado derecho
        const end = Offset
            .zero; // Termina en el centro (pantalla completamente visible)
        const curve =
            Curves.ease; // Puedes cambiar la curva de animación si deseas

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  void _fetchData() {
    _studentBloc.add(FetchStudent());
    _profileImageBloc.add(FetchProfileImage());
  }

  void _navigateAndRefreshProfile(BuildContext context) {
    Navigator.of(context).push(_createRoute()).then((_) {
      _fetchData();
    });
  }
}
