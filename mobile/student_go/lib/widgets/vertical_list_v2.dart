import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_go/bloc/events_saved/events_saved_bloc.dart';
import 'package:student_go/screen/login_screen.dart';
import 'package:student_go/widgets/event_card_vertical_list.dart';

class VerticalListV2 extends StatefulWidget {
  final EventsSavedBloc bloc;
  const VerticalListV2({super.key, required this.bloc});

  @override
  State<VerticalListV2> createState() => _VerticalListV2State();
}

class _VerticalListV2State extends State<VerticalListV2> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventsSavedBloc, EventsSavedState>(
      bloc: widget.bloc,
      builder: (context, state) {
        if (state is EventsSavedLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is EventsSavedError) {
          return Center(child: Text(state.errorMessage));
        } else if (state is TokenNotValidState) {
          Future.microtask(() {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          });
          return const CircularProgressIndicator();
        } else if (state is EventsSavedSuccess) {
          return ListView.builder(
            itemCount: state.eventsSaved.length,
            itemBuilder: (context, index) {
              return Column(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                      EventCardVerticalList(result: state.eventsSaved[index]),
                )
              ]);
            },
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
