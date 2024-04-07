import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_go/models/response/event_details_response/student.dart';

class PeopleGoingList extends StatelessWidget {
  final List<Student> students;
  const PeopleGoingList({super.key, required this.students});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: students.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 6.0, horizontal: 25),
              child: Row(
                children: [
                  //SearchBar(),
                  Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/img/fotoprueba1.jpg',
                        width: 35,
                        height: 35,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(students[index].name!,
                            style: GoogleFonts.actor(
                                textStyle: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500))),
                        Text(students[index].username!,
                            style: GoogleFonts.actor(
                                textStyle: const TextStyle(
                                    fontSize: 12,
                                    color:
                                        Color.fromARGB(255, 121, 120, 120)))),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
