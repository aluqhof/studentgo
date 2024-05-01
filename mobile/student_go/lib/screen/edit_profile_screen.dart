import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_go/bloc/event_type/event_type_bloc.dart';
import 'package:student_go/bloc/profile_image/profile_image_bloc.dart';
import 'package:student_go/bloc/student/student_bloc.dart';
import 'package:student_go/bloc/update_profile/update_profile_bloc.dart';
import 'package:student_go/bloc/upload_profile_photo/upload_profile_photo_bloc.dart';
import 'package:student_go/models/response/event_type_response.dart';
import 'package:student_go/models/response/validation_exception/fields_error.dart';
import 'package:student_go/repository/event_type/event_type_repository.dart';
import 'package:student_go/repository/event_type/event_type_repository_impl.dart';
import 'package:student_go/repository/student/student_repository.dart';
import 'package:student_go/repository/student/student_repository_impl.dart';
import 'package:student_go/screen/edit_username_screen.dart';
import 'package:student_go/screen/login_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late StudentRepository studentRepository;
  late StudentBloc _studentBloc;
  late UpdateProfileBloc _updateProfileBloc;
  late TextEditingController _nameController;
  late TextEditingController _usernameController;
  late TextEditingController _descriptionController;
  bool validationError = false;
  List<FieldsError> validationErrors = [];
  bool _isSubmitting = false;
  List<int> interestsId = [];
  List<String> nameErrors = [];
  List<String> descriptionErrors = [];
  List<String> interestErrors = [];
  List<EventTypeResponse> interestList = [];
  late EventTypeBloc _eventTypeBloc;
  late EventTypeRepository eventTypeRepository;
  late ProfileImageBloc _profileImageBloc;
  late UploadProfilePhotoBloc _uploadProfilePhotoBloc;

  @override
  void initState() {
    studentRepository = StudentRepositoryImp();
    _studentBloc = StudentBloc(studentRepository)..add(FetchStudent());
    _nameController = TextEditingController();
    _usernameController = TextEditingController();
    _descriptionController = TextEditingController();
    _updateProfileBloc = UpdateProfileBloc(studentRepository);
    _profileImageBloc = ProfileImageBloc(studentRepository)
      ..add(FetchProfileImage());
    _studentBloc.stream.listen((state) {
      if (state is StudentSuccess) {
        _nameController.text = state.studentInfoResponse.name!;
        _usernameController.text = state.studentInfoResponse.username!;
        _descriptionController.text = state.studentInfoResponse.description!;
      }
    });
    eventTypeRepository = EventTypeRepositoryImpl();
    _eventTypeBloc = EventTypeBloc(eventTypeRepository)
      ..add(FetchEventTypeEvent());
    _uploadProfilePhotoBloc = UploadProfilePhotoBloc(studentRepository);
    _uploadProfilePhotoBloc.stream.listen((state) {
      if (state is UploadProfilePhotoSuccess) {
        _profileImageBloc.add(FetchProfileImage());
        Navigator.of(context).pop();
      } else if (state is UploadProfilePhotoEntityException) {
        _showErrorSnackBar(state.generalException.detail!);
      } else if (state is UploadProfilePhotoValidationException) {
        //processValidationErrors(state);
        _showErrorSnackBar(state.validationException.fieldsErrors![0].message!);
      } else if (state is UploadProfilePhotoError) {
        _showErrorSnackBar(state.errorMessage);
      } else {
        null;
      }
    });
    _updateProfileBloc.stream.listen((state) {
      validationErrors = [];
      validationError = false;
      nameErrors = [];
      descriptionErrors = [];
      interestErrors = [];
      if (state is UpdateProfileSuccess) {
        Navigator.of(context).pop();
      } else if (state is UpdateProfileEntityException) {
        _showErrorSnackBar(state.generalException.detail!);
      } else if (state is UpdateProfileValidationException) {
        //processValidationErrors(state);
        _showErrorSnackBar(state.validationException.fieldsErrors![0].message!);
      } else if (state is UpdateProfileError) {
        _showErrorSnackBar(state.errorMessage);
      } else {
        null;
      }
    });
    super.initState();
  }

  void processValidationErrors(UpdateProfileValidationException state) {
    List<String> newNameErrors = state.validationException.fieldsErrors!
        .where((error) => error.field! == "name")
        .map((e) => e.message!)
        .toList();
    if (!listEquals(newNameErrors, nameErrors)) {
      setState(() {
        nameErrors = newNameErrors;
      });
    }

    List<String> newDescriptionErrors = state.validationException.fieldsErrors!
        .where((error) => error.field! == "description")
        .map((e) => e.message!)
        .toList();
    if (!listEquals(newDescriptionErrors, descriptionErrors)) {
      setState(() {
        descriptionErrors = newDescriptionErrors;
      });
    }

    List<String> newIntererstsErrors = state.validationException.fieldsErrors!
        .where((error) => error.field! == "interests")
        .map((e) => e.message!)
        .toList();
    if (!listEquals(newIntererstsErrors, interestErrors)) {
      setState(() {
        interestErrors = newIntererstsErrors;
      });
    }
  }

  void _submitProfileUpdate() {
    setState(() {
      _isSubmitting = true;
    });
    Future.delayed(const Duration(seconds: 1), () {
      _updateProfileBloc.add(FetchProfileUpdate(
          _nameController.text, _descriptionController.text, interestsId));
      setState(() {
        _isSubmitting = false;
      });
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

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider.value(value: _studentBloc),
          BlocProvider.value(value: _eventTypeBloc),
          BlocProvider.value(value: _profileImageBloc),
          BlocProvider(create: (_) => _updateProfileBloc),
        ],
        child: BlocBuilder<StudentBloc, StudentState>(
          builder: (context, state) {
            if (state is StudentLoading || state is StudentInitial) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is StudentSuccess) {
              interestList = state.studentInfoResponse.interests!;
              return Scaffold(
                appBar: AppBar(
                  title: Center(
                    child: Text(
                      'Edit Profile',
                      style: GoogleFonts.actor(),
                    ),
                  ),
                  actions: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 5.0),
                      child: TextButton(
                        style: ButtonStyle(
                          overlayColor:
                              MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.pressed) ||
                                  states.contains(MaterialState.hovered) ||
                                  states.contains(MaterialState.focused)) {
                                return Colors.transparent;
                              }
                              return null;
                            },
                          ),
                        ),
                        onPressed: _isSubmitting ? null : _submitProfileUpdate,
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
                body: BlocBuilder<EventTypeBloc, EventTypeState>(
                  builder: (context, stateEventType) {
                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Center(child: BlocBuilder<ProfileImageBloc,
                                ProfileImageState>(
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
                                        width: 60,
                                        height: 60,
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
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                }
                              },
                            )),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Center(
                                child: GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet<void>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ListView(
                                              shrinkWrap: true,
                                              children: [
                                                ListTile(
                                                  leading: const Icon(
                                                      Icons.photo_library,
                                                      color: Colors.black),
                                                  title: Text(
                                                      'Choose from the library',
                                                      style: GoogleFonts.actor(
                                                          textStyle:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .black))),
                                                  onTap: () {
                                                    getImageFromLibrary(
                                                        context);
                                                  },
                                                ),
                                                ListTile(
                                                  leading: const Icon(
                                                    Icons.camera_alt,
                                                    color: Colors.black,
                                                  ),
                                                  title: Text(
                                                    'Take a Photo',
                                                    style: GoogleFonts.actor(
                                                        textStyle:
                                                            const TextStyle(
                                                                color: Colors
                                                                    .black)),
                                                  ),
                                                  onTap: () {
                                                    takePhoto(context);
                                                  },
                                                ),
                                                ListTile(
                                                  leading: const Icon(
                                                    Icons.delete,
                                                    color: Colors.red,
                                                  ),
                                                  title: Text(
                                                    'Delete Photo',
                                                    style: GoogleFonts.actor(
                                                        textStyle:
                                                            const TextStyle(
                                                                color: Colors
                                                                    .red)),
                                                  ),
                                                  onTap: () async {
                                                    try {
                                                      final prefs =
                                                          await SharedPreferences
                                                              .getInstance();

                                                      final url = Uri.parse(
                                                          'http://10.0.2.2:8080/delete-photo');
                                                      final response =
                                                          await http.get(
                                                        url,
                                                        headers: {
                                                          'Authorization':
                                                              'Bearer ${prefs.getString('token')!}', // Asegúrate de reemplazar esto con tu token real
                                                        },
                                                      );

                                                      if (response.statusCode ==
                                                          204) {
                                                        _profileImageBloc.add(
                                                            FetchProfileImage());
                                                        Navigator.of(context)
                                                            .pop();
                                                      } else {
                                                        Navigator.of(context)
                                                            .pop();
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          SnackBar(
                                                            content: Text(
                                                                'Failed to delete photo'),
                                                            backgroundColor:
                                                                Colors.red,
                                                          ),
                                                        );
                                                      }
                                                    } catch (e) {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                              'Error occurred: $e'),
                                                          backgroundColor:
                                                              Colors.red,
                                                        ),
                                                      );
                                                    }
                                                  },
                                                ),
                                              ],
                                            ),
                                          );
                                        });
                                  },
                                  child: Text(
                                    'Change profile image',
                                    style: GoogleFonts.actor(
                                        textStyle: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.blue)),
                                  ),
                                ),
                              ),
                            ),
                            const Divider(
                              color: Color.fromARGB(255, 245, 245, 245),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: 2,
                                      child: Text(
                                        'Name',
                                        style: GoogleFonts.actor(
                                            textStyle:
                                                const TextStyle(fontSize: 16)),
                                      )),
                                  Expanded(
                                      flex: 6,
                                      child: TextField(
                                        controller: _nameController,
                                        onChanged: (value) {
                                          setState(() {
                                            _nameController.text = value;
                                          });
                                        },
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
                                      ))
                                ],
                              ),
                            ),
                            /*nameErrors.isNotEmpty
                                            ? Text(nameErrors[0],
                                                style: const TextStyle(color: Colors.red))
                                            : const SizedBox(),*/
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: 2,
                                      child: Text(
                                        'Username',
                                        style: GoogleFonts.actor(
                                            textStyle:
                                                const TextStyle(fontSize: 16)),
                                      )),
                                  Expanded(
                                    flex: 6,
                                    child: InkWell(
                                      onTap: () {
                                        _navigateAndRefreshProfile(context);
                                      },
                                      child: Container(
                                        height: 48,
                                        alignment: Alignment.centerLeft,
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              color: Colors.grey[500]!,
                                              width: 0.5,
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          _usernameController.text.isNotEmpty
                                              ? _usernameController.text
                                              : "Tap to edit username",
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: Color.fromARGB(
                                                  255, 27, 27, 27),
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: 2,
                                      child: Text(
                                        'Description',
                                        style: GoogleFonts.actor(
                                            textStyle:
                                                const TextStyle(fontSize: 16)),
                                      )),
                                  Expanded(
                                      flex: 6,
                                      child: TextField(
                                        controller: _descriptionController,
                                        onChanged: (value) {
                                          setState(() {
                                            _descriptionController.text = value;
                                          });
                                        },
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
                                      ))
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: BlocBuilder<EventTypeBloc, EventTypeState>(
                                builder: (context, stateEventType) {
                                  if (stateEventType is EventTypeSuccess) {
                                    return Row(
                                      children: [
                                        Expanded(
                                            flex: 2,
                                            child: Text(
                                              'Interest',
                                              style: GoogleFonts.actor(
                                                  textStyle: const TextStyle(
                                                      fontSize: 16)),
                                            )),
                                        Expanded(
                                            flex: 6,
                                            child: TypeAheadField(
                                              itemBuilder:
                                                  (context, suggestion) {
                                                return ListTile(
                                                  title: Text(suggestion.name!),
                                                );
                                              },
                                              onSelected: (value) {
                                                setState(() {
                                                  interestList.add(value);
                                                });
                                              },
                                              loadingBuilder: (context) =>
                                                  const Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text('Loading...'),
                                              ),
                                              errorBuilder: (context, error) =>
                                                  const Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text('Unespected error'),
                                              ),
                                              emptyBuilder: (context) =>
                                                  const Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text(
                                                    'No event types found according your query'),
                                              ),
                                              suggestionsCallback:
                                                  (pattern) async {
                                                List<EventTypeResponse>
                                                    eventTypes = stateEventType
                                                        .eventTypeResponseList;

                                                Set<String> myInterestNames =
                                                    Set.from(state
                                                        .studentInfoResponse
                                                        .interests!
                                                        .map((e) => e.name!
                                                            .toLowerCase()));

                                                List<EventTypeResponse>
                                                    otherEventTypes = [];

                                                for (var eventType
                                                    in eventTypes) {
                                                  if (!myInterestNames.contains(
                                                      eventType.name!
                                                          .toLowerCase())) {
                                                    otherEventTypes
                                                        .add(eventType);
                                                  }
                                                }

                                                return otherEventTypes;
                                              },
                                            ))
                                      ],
                                    );
                                  } else {
                                    return const SizedBox();
                                  }
                                },
                              ),
                            ),
                            Row(
                              children: [
                                const Expanded(flex: 2, child: SizedBox()),
                                Expanded(
                                  flex: 6,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Wrap(
                                      spacing: 8.0, // Spacing between chips
                                      runSpacing: 8.0, // Spacing between rows
                                      direction: Axis.horizontal,
                                      children: List.generate(
                                        interestList.length,
                                        (index) {
                                          interestsId = interestList
                                              .map(
                                                (e) => e.id!,
                                              )
                                              .toList();
                                          return GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                interestList.removeAt(index);
                                              });
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: const Color.fromARGB(
                                                      255, 228, 226, 226)),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5,
                                                      horizontal: 15),
                                              child: Text(
                                                interestList[index].name!,
                                                style: GoogleFonts.actor(
                                                    textStyle: const TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w600)),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
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
          },
        ));
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const EditUsernameScreen(),
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

  Future<void> getImageFromLibrary(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _uploadProfilePhotoBloc.add(FetchProfilePhotoUpload(pickedFile));
    }
  }

  Future<void> takePhoto(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      _uploadProfilePhotoBloc.add(FetchProfilePhotoUpload(pickedFile));
    }
  }
}
