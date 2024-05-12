import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_go/bloc/event_list/event_list_bloc.dart';
import 'package:student_go/models/response/list_events_response/list_events_response.dart';
import 'package:student_go/repository/event/event_repository.dart';
import 'package:student_go/repository/event/event_repository_impl.dart';
import 'package:student_go/widgets/vertical_list.dart';

class EventTypeEventsScreen extends StatefulWidget {
  final int id;
  final String cityName;
  const EventTypeEventsScreen(
      {super.key, required this.id, required this.cityName});

  @override
  State<EventTypeEventsScreen> createState() => _EventTypeEventsScreenState();
}

class _EventTypeEventsScreenState extends State<EventTypeEventsScreen> {
  late EventRepository eventRepository;
  late EventListBloc _eventListBloc;
  late SharedPreferences _prefs;
  String appBarTitle = '';

  static const _pageSize = 10;
  final PagingController<int, ListEventsResponse> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    super.initState();
    eventRepository = EventRepositoryImpl();
    _eventListBloc = EventListBloc(eventRepository);
    _eventListBloc
        .add(FetchEventTypeListEvent(widget.cityName, widget.id, 0, _pageSize));
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    initialize();
  }

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await _eventListBloc.eventRepository
          .getEventsByEventType(widget.cityName, widget.id, pageKey, _pageSize);

      final itemsList = [newItems];

      final isLastPage = newItems.last! || newItems.size! < _pageSize;

      if (isLastPage) {
        _pagingController.appendLastPage(itemsList);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(itemsList, nextPageKey);
      }

      setState(() {
        appBarTitle = newItems.name ?? '';
      });
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _eventListBloc,
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              appBarTitle,
              style: GoogleFonts.actor(),
            ),
          ),
          body: VerticalList(
            pagingController: _pagingController,
            bloc: _eventListBloc,
          )),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    _eventListBloc.close();
    super.dispose();
  }
}
