import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_go/bloc/event_list/event_list_bloc.dart';
import 'package:student_go/models/response/list_events_response/list_events_response.dart';
import 'package:student_go/screen/login_screen.dart';
import 'package:student_go/widgets/event_card_vertical_list.dart';

class VerticalList extends StatefulWidget {
  final PagingController<int, ListEventsResponse> pagingController;
  final dynamic bloc;
  const VerticalList(
      {super.key, required this.pagingController, required this.bloc});

  @override
  State<VerticalList> createState() => _VerticalListState();
}

class _VerticalListState extends State<VerticalList> {
  late SharedPreferences _prefs;

  @override
  void initState() {
    initialize();
    super.initState();
  }

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventListBloc, EventListState>(
      bloc: widget.bloc,
      builder: (context, state) {
        if (state is EventListLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is UpcomingListEntityException) {
          if (state.generalException.status == 404) {
            return SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 200.0,
                    height: 200.0,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/img/noevents.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Text(
                      'There are currently no events in your city',
                      style: GoogleFonts.actor(
                          textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      )),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            );
          }
          if (state.generalException.status == 401 ||
              state.generalException.status == 403) {
            _prefs.setString('token', '');
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
            return const SizedBox();
          }
          if (state.generalException.status == 400) {
            return const Text('Unespected error');
          }
          return Center(child: Text(state.generalException.detail!));
        } else if (state is AccordingListEntityException) {
          if (state.generalException.status == 404) {
            return SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 200.0,
                    height: 200.0,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/img/noevents.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Text(
                      'There are currently no events in your city',
                      style: GoogleFonts.actor(
                          textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      )),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            );
          }
          if (state.generalException.status == 401 ||
              state.generalException.status == 403) {
            _prefs.setString('token', '');
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
            return const SizedBox();
          }
          if (state.generalException.status == 400) {
            return const Text('Unespected error');
          }
          return Center(child: Text(state.generalException.detail!));
        } else if (state is UpcomingListError) {
          return Center(child: Text(state.errorMessage));
        } else if (state is AccordingListEntityException) {
          return Center(child: Text(state.errorMessage));
        } else if (state is TokenNotValidState) {
          Future.microtask(() {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          });
          return const CircularProgressIndicator();
        } else if (state is UpcomingListSuccess) {
          if (state.listEventsResponse.pageNumber == 0 &&
              state.listEventsResponse.totalElements == 0) {
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
                        image: AssetImage('assets/img/noevents.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Text(
                      'There are currently no upcoming ${state.listEventsResponse.name} events in your city',
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
          } else {
            return PagedListView<int, ListEventsResponse>(
              pagingController: widget.pagingController,
              builderDelegate: PagedChildBuilderDelegate<ListEventsResponse>(
                itemBuilder: (context, item, index) {
                  return Column(
                    children: item.content!.map((event) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: EventCardVerticalList(result: event),
                      );
                    }).toList(),
                  );
                },
              ),
            );
          }
        } else if (state is AccordingListSuccess) {
          if (state.listEventsResponse.pageNumber == 0 &&
              state.listEventsResponse.totalElements == 0) {
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
                        image: AssetImage('assets/img/noevents.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Text(
                      'There are currently no upcoming ${state.listEventsResponse.name} events in your city',
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
          } else {
            return PagedListView<int, ListEventsResponse>(
              pagingController: widget.pagingController,
              builderDelegate: PagedChildBuilderDelegate<ListEventsResponse>(
                itemBuilder: (context, item, index) {
                  return Column(
                    children: item.content!.map((event) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: EventCardVerticalList(result: event),
                      );
                    }).toList(),
                  );
                },
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
