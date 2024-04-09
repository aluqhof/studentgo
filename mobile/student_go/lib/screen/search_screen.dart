import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_go/bloc/event_list/event_list_bloc.dart';
import 'package:student_go/models/response/list_events_response/list_events_response.dart';
import 'package:student_go/repository/event/event_repository.dart';
import 'package:student_go/repository/event/event_repository_impl.dart';
import 'package:student_go/screen/login_screen.dart';
import 'package:student_go/widgets/event_card_vertical_list.dart';
import 'package:student_go/widgets/vertical_list.dart';

class SearchScreen extends StatefulWidget {
  final String currentCity;
  const SearchScreen({super.key, required this.currentCity});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController _searchController;
  late FocusNode _searchFocusNode;
  late EventRepository eventRepository;
  late EventListBloc _eventListBloc;
  static const _pageSize = 10;
  final PagingController<int, ListEventsResponse> _pagingController =
      PagingController(firstPageKey: 0);
  late SharedPreferences _prefs;
  String name = '';
  bool _isInitialized = false;

  @override
  void initState() {
    _searchController = TextEditingController();
    _searchFocusNode = FocusNode();
    _searchController = TextEditingController();
    eventRepository = EventRepositoryImpl();
    _eventListBloc = EventListBloc(eventRepository)
      ..add(FetchUpcomingListSearchableEvent(widget.currentCity, 0, 5, name));
    super.initState();
    _searchController.addListener(_onNameChanged);

    initialize();
  }

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _isInitialized = true;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _searchFocusNode = FocusNode();
    // Enfocar el nodo de texto cuando se inicia la página
    FocusScope.of(context).requestFocus(_searchFocusNode);
    Future.delayed(const Duration(milliseconds: 200), () {
      FocusScope.of(context).requestFocus(_searchFocusNode);
    });
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onNameChanged() {
    final newName = _searchController.text;
    if (name != newName) {
      setState(() {
        name = newName;
      });
      _eventListBloc.add(
          FetchUpcomingListSearchableEvent(widget.currentCity, 0, 5, newName));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search', style: TextStyle(fontFamily: 'Roboto')),
      ),
      body: (!_isInitialized)
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          controller: _searchController,
                          focusNode: _searchFocusNode,
                          decoration: InputDecoration(
                            icon: const Icon(
                              Icons.search,
                              color: Color.fromRGBO(74, 67, 236, 1),
                              size: 30,
                            ),
                            hintText: ' Search...',
                            hintStyle: const TextStyle(
                              color: Color.fromRGBO(56, 56, 56, 0.2),
                              fontSize: 20,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 1,
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: Container(
                            width: 25,
                            height: 25,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color.fromRGBO(162, 158, 240, 1),
                            ),
                            child: const Icon(
                              Icons.filter_list,
                              size: 22,
                              color: Color.fromRGBO(93, 86, 243, 1),
                            ),
                          ),
                          label: const FittedBox(
                            fit: BoxFit
                                .scaleDown, // Ajusta el tamaño del texto para que quepa dentro del espacio disponible
                            child: Text(
                              'Filters',
                              style: TextStyle(fontFamily: 'Roboto'),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            foregroundColor:
                                const Color.fromARGB(255, 255, 255, 255),
                            backgroundColor:
                                const Color.fromRGBO(93, 86, 243, 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: BlocBuilder<EventListBloc, EventListState>(
                    bloc: _eventListBloc,
                    builder: (context, state) {
                      if (state is EventListLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is UpcomingListSearchableError) {
                        return Center(child: Text(state.errorMessage));
                      } else if (state is TokenNotValidState) {
                        Future.microtask(() {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()),
                          );
                        });
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is UpcomingListSearchableSuccess) {
                        return ListView.builder(
                            itemCount: state.listEventsResponse.length,
                            itemBuilder: (context, index) {
                              return state.listEventsResponse.isNotEmpty
                                  ? Column(
                                      children:
                                          state.listEventsResponse.map((event) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: EventCardVerticalList(
                                            result: event),
                                      );
                                    }).toList())
                                  : const Center(
                                      child: Text('Nothing'),
                                    );
                            });
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                )
              ],
            ),
    );
  }
}
