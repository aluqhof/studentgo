import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_go/bloc/change_username/change_username_bloc.dart';
import 'package:student_go/bloc/student/student_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:student_go/repository/student/student_repository.dart';
import 'package:student_go/repository/student/student_repository_impl.dart';
import 'package:student_go/screen/login_screen.dart';

class EditUsernameScreen extends StatefulWidget {
  const EditUsernameScreen({super.key});

  @override
  State<EditUsernameScreen> createState() => _EditUsernameScreenState();
}

class _EditUsernameScreenState extends State<EditUsernameScreen> {
  late StudentRepository studentRepository;
  late StudentBloc _studentBloc;
  late TextEditingController _usernameController;
  late ChangeUsernameBloc _changeUsernameBloc;
  bool _isSubmitting = false;
  String _initialUsername = '';

  @override
  void initState() {
    super.initState();
    studentRepository = StudentRepositoryImp();
    _studentBloc = StudentBloc(studentRepository)..add(FetchStudent());
    _changeUsernameBloc = ChangeUsernameBloc(studentRepository);
    _usernameController = TextEditingController();
    _studentBloc.stream.listen((state) {
      if (state is StudentSuccess) {
        _usernameController.text = state.studentInfoResponse.username!;
        _initialUsername = state.studentInfoResponse.username!;
      }
    });
    _changeUsernameBloc.stream.listen((state) {
      if (state is ChangeUsernameSuccess) {
        Navigator.of(context).pop();
      } else if (state is ChangeUsernameEntityException) {
        _showErrorSnackBar(state.generalException.detail!);
      } else if (state is ChangeUsernameValidationException) {
        for (var element in state.validationException.fieldsErrors!) {
          _showErrorSnackBar(element.message!);
        }
      } else if (state is ChangeUsernameError) {
        _showErrorSnackBar(state.errorMessage);
      } else {
        null;
      }
    });
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

  void _submitUsernameChange() {
    setState(() {
      _isSubmitting = true;
    });
    if (_usernameController.text == _initialUsername) {
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.of(context).pop();
        setState(() {
          _isSubmitting = false;
        });
      });
      return;
    }
    Future.delayed(const Duration(seconds: 1), () {
      _changeUsernameBloc.add(FetchUsernameChange(_usernameController.text));
      setState(() {
        _isSubmitting = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider.value(value: _studentBloc),
          BlocProvider(create: (_) => _changeUsernameBloc),
        ],
        child:
            BlocBuilder<StudentBloc, StudentState>(builder: (context, state) {
          if (state is StudentLoading || state is StudentInitial) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is StudentSuccess) {
            return Scaffold(
              appBar: AppBar(
                title: Center(
                  child: Text(
                    'Username',
                    style: GoogleFonts.actor(
                        textStyle: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                ),
                actions: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: TextButton(
                      style: ButtonStyle(
                        overlayColor: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                            // If the button is pressed, hovered, or focused, return transparent color
                            if (states.contains(MaterialState.pressed) ||
                                states.contains(MaterialState.hovered) ||
                                states.contains(MaterialState.focused)) {
                              return Colors.transparent;
                            }
                            return null; // Defer to the widget's default.
                          },
                        ),
                      ),
                      onPressed: _isSubmitting ? null : _submitUsernameChange,
                      child: _isSubmitting
                          ? const SpinKitFadingCircle(
                              color: Color.fromARGB(255, 189, 188, 188),
                              size: 30.0,
                            )
                          : const Text(
                              'Done',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 19,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
              body: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 8.0, left: 14, right: 14),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Username',
                        style: GoogleFonts.actor(
                            textStyle: const TextStyle(
                                color: Color.fromARGB(255, 139, 139, 139))),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 0.0, horizontal: 14),
                    child: TextField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.blue,
                            width: 1.0,
                          ),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 0.5,
                          ),
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
        }));
  }
}
