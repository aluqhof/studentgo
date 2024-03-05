import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_go/bloc/student/student_bloc.dart';
import 'package:student_go/repository/student/student_repository.dart';
import 'package:student_go/repository/student/student_repository_impl.dart';

class SaveButtonEventCard extends StatefulWidget {
  final String eventId;
  const SaveButtonEventCard({super.key, required this.eventId});

  @override
  State<SaveButtonEventCard> createState() => _SaveButtonEventCardState();
}

class _SaveButtonEventCardState extends State<SaveButtonEventCard> {
  late StudentRepository studentRepository;
  late StudentBloc _studentBloc;

  @override
  void initState() {
    super.initState();
    studentRepository = StudentRepositoryImp();
    _studentBloc = StudentBloc(studentRepository)
      ..add(SavedOrUnsavedEvent(widget.eventId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _studentBloc,
      child: BlocBuilder<StudentBloc, StudentState>(
        bloc: _studentBloc,
        builder: (context, state) {
          return Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.white),
              padding: const EdgeInsets.all(8),
              child: const Icon(
                Icons.bookmark,
                color: Color.fromRGBO(240, 99, 90, 1),
              ));
        },
      ),
    );
  }
}
