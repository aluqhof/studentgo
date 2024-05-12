import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_go/bloc/profile_image/profile_image_bloc.dart';
import 'package:student_go/models/response/event_details_response/student.dart';
import 'package:student_go/repository/student/student_repository.dart';
import 'package:student_go/repository/student/student_repository_impl.dart';

class PeopleGoingList extends StatefulWidget {
  final List<Student> students;
  const PeopleGoingList({super.key, required this.students});

  @override
  State<PeopleGoingList> createState() => _PeopleGoingListState();
}

class _PeopleGoingListState extends State<PeopleGoingList> {
  late StudentRepository studentRepository;

  @override
  void initState() {
    studentRepository = StudentRepositoryImp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.only(top: 25.0, bottom: 20, left: 20, right: 20),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'People Going',
              style:
                  GoogleFonts.actor(textStyle: const TextStyle(fontSize: 24)),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: widget.students.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 6.0, horizontal: 25),
                    child: Row(
                      children: [
                        BlocProvider(
                          create: (context) =>
                              ProfileImageBloc(studentRepository)
                                ..add(FetchProfileImageById(
                                    widget.students[index].id!)),
                          child:
                              BlocBuilder<ProfileImageBloc, ProfileImageState>(
                            builder: (context, state) {
                              if (state is ProfileImageInitial ||
                                  state is ProfileImageLoading) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (state is ProfileImageSuccess) {
                                return Container(
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: ClipOval(
                                    child: Image(
                                      image: MemoryImage(state.image),
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              } else {
                                return Container(
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: ClipOval(
                                    child: Image.asset(
                                      'assets/image/nophoto.png',
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                        // User details
                        Expanded(
                          // Use Expanded to ensure the text and button fit within the available space
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.students[index].name!,
                                    style: GoogleFonts.actor(
                                        textStyle: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500))),
                                Text(widget.students[index].username!,
                                    style: GoogleFonts.actor(
                                        textStyle: const TextStyle(
                                            fontSize: 13,
                                            color: Color.fromARGB(
                                                255, 121, 120, 120)))),
                              ],
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Implement follow/unfollow functionality here
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  10.0), // Rounded corners for the button
                            ),
                          ),
                          child: Text(
                            'Follow',
                            style: GoogleFonts.actor(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
