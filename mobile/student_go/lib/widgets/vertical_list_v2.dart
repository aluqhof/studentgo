import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
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
          if (state.eventsSaved.isNotEmpty) {
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
            return SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 150.0,
                    height: 150.0,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/img/nosaved.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Text(
                      'At the moment you do not have events saved in your bookmark',
                      style: GoogleFonts.actor(
                          textStyle: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w200,
                              color: Colors.grey)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            );
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
