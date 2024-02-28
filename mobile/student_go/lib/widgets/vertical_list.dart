import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
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
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventListBloc, EventListState>(
      bloc: widget.bloc,
      builder: (context, state) {
        if (state is EventListLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is UpcomingListError) {
          return Center(child: Text(state.errorMessage));
        } else if (state is TokenNotValidState) {
          Future.microtask(() {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          });
          return const CircularProgressIndicator();
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
      },
    );
  }
}
