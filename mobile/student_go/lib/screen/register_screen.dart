import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_go/bloc/register_student/register_student_bloc.dart';
import 'package:student_go/repository/auth/auth_repository.dart';
import 'package:student_go/repository/auth/auth_repository_impl.dart';
import 'package:student_go/screen/login_screen.dart';

//Comprobar el requesttoken y si tiene redirigir a home

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

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
  }

  @override
  void dispose() {
    userTextController.dispose();
    passTextController.dispose();
    _registerBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _registerBloc,
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: BlocConsumer<RegisterStudentBloc, RegisterStudentState>(
              buildWhen: (context, state) {
                return state is RegisterStudentInitial ||
                    state is DoRegisterStudentSuccess ||
                    state is DoRegisterStudentError ||
                    state is DoRegisterStudentLoading;
              },
              builder: (context, state) {
                if (state is DoRegisterStudentSuccess) {
                  return const Text('Register success');
                } else if (state is DoRegisterStudentBadRequestValidation) {
                  error =
                      state.badRequestValidation.body!.fieldsErrors![0].message;
                } else if (state is DoRegisterStudentError) {
                  error = state.errorMessage;
                } else if (state is DoRegisterStudentLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                return Container(child: _buildRegisterForm());
              },
              listener: (BuildContext context, RegisterStudentState state) {},
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterForm() {
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
              style:
                  GoogleFonts.actor(textStyle: const TextStyle(fontSize: 30)),
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
              prefixIcon: const Icon(Icons.person, color: Colors.grey),
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
              prefixIcon: const Icon(Icons.supervised_user_circle_rounded,
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
                icon:
                    Icon(_isObscure ? Icons.visibility_off : Icons.visibility),
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
                icon: Icon(
                    _isObscureVerify ? Icons.visibility_off : Icons.visibility),
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
          if (error != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Center(
                  child:
                      Text(error!, style: const TextStyle(color: Colors.red))),
            ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(61, 86, 240, 1),
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
                      confirmPassTextController.text));
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
                                builder: (context) => const LoginScreen()),
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
  }
}
