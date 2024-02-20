import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_go/bloc/login/login_bloc.dart';
import 'package:student_go/repository/auth/auth_repository.dart';
import 'package:student_go/repository/auth/auth_repository_impl.dart';
import 'package:student_go/screen/register_screen.dart';

//Comprobar el requesttoken y si tiene redirigir a home

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({Key? key}) : super(key: key);

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  // Form
  final _formLogin = GlobalKey<FormState>();
  final userTextController = TextEditingController();
  final passTextController = TextEditingController();

  late AuthRepository authRepository;
  late LoginBloc _loginBloc;
  bool _isObscure = true;

  @override
  void initState() {
    super.initState();
    authRepository = AuthRepositoryImpl();
    _loginBloc = LoginBloc(authRepository: authRepository);
  }

  @override
  void dispose() {
    userTextController.dispose();
    passTextController.dispose();
    _loginBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _loginBloc,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: BlocConsumer<LoginBloc, LoginState>(
              buildWhen: (context, state) {
                return state is LoginInitial ||
                    state is DoLoginSuccess ||
                    state is DoLoginError ||
                    state is DoLoginLoading;
              },
              builder: (context, state) {
                if (state is DoLoginSuccess) {
                  return const Text('Login success');
                } else if (state is DoLoginError) {
                  return const Text('Login error');
                } else if (state is DoLoginLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                return Container(child: _buildLoginForm());
              },
              listener: (BuildContext context, LoginState state) {},
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _formLogin,
      child: Padding(
        padding: const EdgeInsets.only(top: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
                child: Column(
              children: [
                Image.asset(
                  'assets/img/logo.png',
                  width: 130,
                ),
                Text(
                  'StudentGo',
                  style: GoogleFonts.alatsi(
                      textStyle: const TextStyle(
                          color: Color.fromRGBO(55, 54, 74, 1), fontSize: 40)),
                )
              ],
            )),
            const SizedBox(
              height: 80,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Text(
                'Sign in',
                style:
                    GoogleFonts.actor(textStyle: const TextStyle(fontSize: 30)),
              ),
            ),
            TextFormField(
              controller: userTextController,
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
                  icon: Icon(
                      _isObscure ? Icons.visibility_off : Icons.visibility),
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
                  if (_formLogin.currentState!.validate()) {
                    _loginBloc.add(DoLoginEvent(
                        userTextController.text, passTextController.text));
                  }
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Text('SIGN IN'.toUpperCase(),
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
                        text: 'Don\'t have an account? ',
                        style: GoogleFonts.actor(),
                      ),
                      WidgetSpan(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegisterScreen()),
                            );
                          },
                          child: Text(
                            'Signup',
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
      ),
    );
  }
}
