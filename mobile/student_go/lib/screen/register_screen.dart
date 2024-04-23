import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_go/bloc/event_type/event_type_bloc.dart';
import 'package:student_go/bloc/register_student/register_student_bloc.dart';
import 'package:student_go/repository/auth/auth_repository.dart';
import 'package:student_go/repository/auth/auth_repository_impl.dart';
import 'package:student_go/repository/event_type/event_type_repository.dart';
import 'package:student_go/repository/event_type/event_type_repository_impl.dart';
import 'package:student_go/screen/home_screen.dart';
import 'package:student_go/screen/login_screen.dart';

//Comprobar el requesttoken y si tiene redirigir a home

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Form
  final _formRegister = GlobalKey<FormState>();
  final nameTextController = TextEditingController();
  final userTextController = TextEditingController();
  final mailTextController = TextEditingController();
  final passTextController = TextEditingController();
  final confirmPassTextController = TextEditingController();
  late EventTypeBloc _eventTypeBloc;
  late EventTypeRepository eventTypeRepository;
  List<int> selectedInterests = [];
  List<String> validationErrors = [];

  String? error;

  late AuthRepository authRepository;
  late RegisterStudentBloc _registerBloc;
  bool _isObscure = true;
  bool _isObscureVerify = true;

  @override
  void initState() {
    super.initState();
    authRepository = AuthRepositoryImpl();
    _registerBloc = RegisterStudentBloc(authRepository: authRepository);
    eventTypeRepository = EventTypeRepositoryImpl();
    _eventTypeBloc = EventTypeBloc(eventTypeRepository)
      ..add(FetchEventTypeEvent());
    _registerBloc.stream.listen((state) {
      validationErrors = [];
      if (state is DoRegisterStudentLoading) {
        const Center(
          child: CircularProgressIndicator(),
        );
      } else if (state is DoRegisterStudentSuccess) {
        _navigateToHome(context);
      } else if (state is DoRegisterStudentBadRequestValidation) {
        _showErrorSnackBar(
            state.badRequestValidation.fieldsErrors![0].message!);
      } else if (state is DoRegisterStudentError) {
        _showErrorSnackBar(state.errorMessage);
      } else if (state is DoRegisterStudentSuccess) {
        _navigateToHome(context);
      } else {
        const Center(
          child: CircularProgressIndicator(),
        );
      }
    });
  }

  @override
  void dispose() {
    userTextController.dispose();
    passTextController.dispose();
    _registerBloc.close();
    super.dispose();
  }

  void _showErrorSnackBar(String errorMessage) {
    final snackBar = SnackBar(
      content: Text(
        errorMessage,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(10),
      duration: const Duration(seconds: 4),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _navigateToHome(BuildContext context) {
    Navigator.of(context).push(_createRoute()).then((_) {});
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const HomeScreen(),
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RegisterStudentBloc>(
      create: (context) => _registerBloc,
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(child: _buildRegisterForm())),
        ),
      ),
    );
  }

  Widget _buildRegisterForm() {
    return BlocProvider.value(
        value: _eventTypeBloc,
        child: BlocBuilder<EventTypeBloc, EventTypeState>(
          builder: (context, state) {
            if (state is EventTypeSuccess) {
              return Form(
                key: _formRegister,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Text(
                        'Sign Up',
                        style: GoogleFonts.actor(
                            textStyle: const TextStyle(fontSize: 30)),
                      ),
                    ),
                    TextFormField(
                      controller: nameTextController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        labelText: 'Full name',
                        labelStyle: GoogleFonts.actor(),
                        prefixIcon:
                            const Icon(Icons.person, color: Colors.grey),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: userTextController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        labelText: 'Your username',
                        labelStyle: GoogleFonts.actor(),
                        prefixIcon: const Icon(
                            Icons.supervised_user_circle_rounded,
                            color: Colors.grey),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: mailTextController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        labelText: 'abc@gmail.com',
                        labelStyle: GoogleFonts.actor(),
                        prefixIcon: const Icon(Icons.mail, color: Colors.grey),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: passTextController,
                      obscureText: _isObscure,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        labelText: 'Your Password',
                        labelStyle: GoogleFonts.actor(),
                        prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          },
                          icon: Icon(_isObscure
                              ? Icons.visibility_off
                              : Icons.visibility),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: confirmPassTextController,
                      obscureText: _isObscure,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        labelText: 'Confirm Password',
                        labelStyle: GoogleFonts.actor(),
                        prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _isObscureVerify = !_isObscureVerify;
                            });
                          },
                          icon: Icon(_isObscureVerify
                              ? Icons.visibility_off
                              : Icons.visibility),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                          // ignore: unrelated_type_equality_checks
                        } else if (value == passTextController) {
                          return 'The passwords do not match';
                        }
                        return null;
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Choose your interests',
                              style: GoogleFonts.actor(
                                  textStyle: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold))),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Wrap(
                              spacing: 8.0,
                              runSpacing: 8.0,
                              direction: Axis.horizontal,
                              children: List.generate(
                                state.eventTypeResponseList.length,
                                (index) {
                                  bool isSelected = selectedInterests.contains(
                                      state.eventTypeResponseList[index].id);
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (isSelected) {
                                          selectedInterests.remove(state
                                              .eventTypeResponseList[index].id);
                                        } else {
                                          selectedInterests.add(state
                                              .eventTypeResponseList[index]
                                              .id!);
                                        }
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: isSelected
                                                  ? Colors.blue
                                                  : const Color.fromARGB(
                                                      0, 158, 158, 158),
                                              width: 1.5),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: isSelected
                                              ? const Color.fromARGB(
                                                  255, 219, 219, 219)
                                              : const Color.fromARGB(
                                                  255, 228, 226, 226)),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 15),
                                      child: Text(
                                        state
                                            .eventTypeResponseList[index].name!,
                                        style: GoogleFonts.actor(
                                            textStyle: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600)),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (error != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Center(
                            child: Text(error!,
                                style: const TextStyle(color: Colors.red))),
                      ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(61, 86, 240, 1),
                            padding: const EdgeInsets.all(15.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
                        onPressed: () {
                          if (_formRegister.currentState!.validate()) {
                            _registerBloc.add(DoRegisterStudentEvent(
                                nameTextController.text,
                                userTextController.text,
                                mailTextController.text,
                                passTextController.text,
                                confirmPassTextController.text,
                                selectedInterests));
                          }
                        },
                        child: Row(
                          children: [
                            Expanded(
                              child: Text('SIGN UP'.toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.actor(
                                      textStyle: const TextStyle(
                                          fontSize: 18, color: Colors.white))),
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color.fromARGB(66, 255, 255, 255),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(2.0),
                                child: Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Already have an account? ',
                                style: GoogleFonts.actor(),
                              ),
                              WidgetSpan(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginScreen()),
                                    );
                                  },
                                  child: Text(
                                    'Signin',
                                    style: GoogleFonts.actor(
                                      textStyle: const TextStyle(
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        ));
  }
}
