import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_go/bloc/event_list/event_list_bloc.dart';
import 'package:student_go/bloc/event_type/event_type_bloc.dart';
import 'package:student_go/models/response/event_type_response.dart';
import 'package:student_go/models/response/list_events_response/list_events_response.dart';
import 'package:student_go/repository/event/event_repository.dart';
import 'package:student_go/repository/event/event_repository_impl.dart';
import 'package:student_go/repository/event_type/event_type_repository.dart';
import 'package:student_go/repository/event_type/event_type_repository_impl.dart';
import 'package:student_go/screen/login_screen.dart';
import 'package:student_go/widgets/date_selection_widget.dart';
import 'package:student_go/widgets/event_card_vertical_list.dart';
import 'package:student_go/widgets/event_type_widget_filter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';

class SearchScreen extends StatefulWidget {
  final String currentCity;
  final String currentCountry;
  final bool focusSearch;
  const SearchScreen(
      {super.key,
      required this.currentCountry,
      required this.currentCity,
      required this.focusSearch});

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
  late EventTypeRepository eventTypeRepository;
  late EventTypeBloc _eventTypeBloc;
  List<int> eventTypeIds = [];
  TextEditingController controller = TextEditingController();
  String _currentCity = '';
  String _currentCountry = '';
  String dateOptionSelected = '';
  DateTime? initialDateSelected;
  DateTime? finalDateSelected;
  RangeValues rangeValuesSelected = const RangeValues(0, 100);

  @override
  void initState() {
    _searchController = TextEditingController();
    eventRepository = EventRepositoryImpl();
    _eventListBloc = EventListBloc(eventRepository)
      ..add(FetchUpcomingListSearchableEvent(
          widget.currentCity,
          name,
          List.empty(),
          DateTime.now(),
          DateTime.now().add(const Duration(days: 365)),
          0,
          1000000));
    super.initState();
    _searchController.addListener(_onNameChanged);
    _searchFocusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        if (widget.focusSearch) {
          _searchFocusNode.requestFocus();
        } else {
          _showFilterModal(context); // Abre el ModalBottomSheet automáticamente
        }
      }
    });
    eventTypeRepository = EventTypeRepositoryImpl();
    _eventTypeBloc = EventTypeBloc(eventTypeRepository)
      ..add(FetchEventTypeEvent());
    _currentCity = widget.currentCity;
    _currentCountry = widget.currentCountry;
    initialize();
  }

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _isInitialized = true;
    });
  }

  Future<void> _getLocation(Prediction prediction) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        double.parse(prediction.lat!),
        double.parse(prediction.lng!),
      );
      Placemark placemark = placemarks.first;
      setState(() {
        _currentCity = placemark.locality ?? 'Unknown';
        _currentCountry = placemark.country ?? 'Unknown';
      });
    } catch (e) {
      throw Exception('Error obtaining location: $e');
    }
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
      _eventListBloc.add(FetchUpcomingListSearchableEvent(
          widget.currentCity,
          newName,
          List.empty(),
          DateTime.now(),
          DateTime.now().add(const Duration(days: 365)),
          0,
          1000000));
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
                          onPressed: () {
                            _showFilterModal(context);
                          },
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
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: EventCardVerticalList(
                                          result:
                                              state.listEventsResponse[index]),
                                    )
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

  void _showFilterModal(BuildContext context) {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        RangeValues _currentRangeValues = rangeValuesSelected;
        String selectedDate = dateOptionSelected;
        DateTime? startDate = initialDateSelected;
        DateTime? endDate = finalDateSelected;
        Future<void> selectDateRange(BuildContext context) async {
          final initialDate = startDate ?? DateTime.now();
          final finalDate =
              endDate ?? DateTime.now().add(const Duration(days: 7));
          final firstDate = DateTime.now();
          final lastDate = DateTime.now().add(const Duration(days: 365));

          final pickedDateRange = await showDateRangePicker(
            context: context,
            firstDate: firstDate,
            lastDate: lastDate,
            initialDateRange: DateTimeRange(
              start: initialDate,
              end: finalDate,
            ),
          );

          if (pickedDateRange != null) {
            setState(() {
              startDate = pickedDateRange.start;
              endDate = pickedDateRange.end;
              initialDateSelected = pickedDateRange.start;
              finalDateSelected = pickedDateRange.end;
            });
          }
        }

        return StatefulBuilder(
          builder: (BuildContext context, setState) => SingleChildScrollView(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'Filter',
                      style: GoogleFonts.actor(
                          textStyle: const TextStyle(fontSize: 26)),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 100,
                  child: BlocProvider.value(
                    value: _eventTypeBloc,
                    child: BlocBuilder<EventTypeBloc, EventTypeState>(
                      builder: (context, state) {
                        if (state is EventTypeInitial) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is EventTypeError) {
                          return Text(state.errorMessage);
                        } else if (state is EventTypeSuccess) {
                          return _eventTypeListView(
                            context,
                            state.eventTypeResponseList,
                          );
                        } else {
                          return const Text('Not support');
                        }
                      },
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Text(
                      'Time & Date',
                      style: GoogleFonts.actor(
                          textStyle: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      DateSelectionWidget(
                        text: 'Today',
                        onPressed: () {
                          setState(() {
                            selectedDate = 'Today';
                            dateOptionSelected = 'Today';
                          });
                        },
                        isSelected: selectedDate == 'Today',
                      ),
                      DateSelectionWidget(
                        text: 'Tomorrow',
                        onPressed: () {
                          setState(() {
                            selectedDate = 'Tomorrow';
                            dateOptionSelected = 'Tommorrow';
                          });
                        },
                        isSelected: selectedDate == 'Tomorrow',
                      ),
                      DateSelectionWidget(
                        text: 'This Week',
                        onPressed: () {
                          setState(() {
                            selectedDate = 'This Week';
                            dateOptionSelected = 'This Week';
                          });
                        },
                        isSelected: selectedDate == 'This Week',
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  child: ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        selectedDate = 'Calendar';
                        dateOptionSelected = 'Calendar';
                      });
                      await selectDateRange(context);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 20),
                      backgroundColor: selectedDate == 'Calendar'
                          ? const Color.fromRGBO(74, 67, 236, 1)
                          : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: selectedDate == 'Calendar'
                              ? const Color.fromRGBO(74, 67, 236, 1)
                              : const Color.fromARGB(255, 187, 186, 186),
                          width: 0.5,
                        ),
                      ),
                      elevation: selectedDate == 'Calendar' ? 2 : 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.calendar_month,
                          size: 24,
                          color: selectedDate != 'Calendar'
                              ? const Color.fromRGBO(74, 67, 236, 1)
                              : const Color.fromARGB(255, 255, 255, 255),
                        ),
                        Text(
                          'Choose from Calendar',
                          style: GoogleFonts.actor(
                              textStyle: TextStyle(
                            color: selectedDate == 'Calendar'
                                ? Colors.white
                                : const Color.fromARGB(255, 128, 128, 128),
                            fontSize: 15,
                          )),
                        ),
                        Icon(
                          Icons.navigate_next,
                          size: 24,
                          color: selectedDate != 'Calendar'
                              ? const Color.fromRGBO(74, 67, 236, 1)
                              : const Color.fromARGB(255, 255, 255, 255),
                        )
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Text(
                      'Location',
                      style: GoogleFonts.actor(
                          textStyle: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return placesAutoCompleteTextField();
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 20),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(
                          color: Color.fromARGB(255, 187, 186, 186),
                          width: 0.5,
                        ),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color.fromRGBO(74, 67, 236, 0.5),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(6.0),
                              child: Icon(Icons.location_on,
                                  size: 24,
                                  color: Color.fromRGBO(74, 67, 236, 1)),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left:
                                    10), // Ajusta el espacio entre el icono y el texto
                            child: Text(
                              '$_currentCity, $_currentCountry',
                              style: GoogleFonts.actor(
                                  textStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                              )),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(
                              right:
                                  10), // Ajusta el espacio entre el texto y el icono navigate_next
                          child: Icon(Icons.navigate_next,
                              size: 24, color: Color.fromRGBO(74, 67, 236, 1)),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 18.0, right: 18, bottom: 10, top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Select price range',
                        style: GoogleFonts.actor(
                            textStyle: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600)),
                      ),
                      Text(
                        '${_currentRangeValues.start.round()}€-${_currentRangeValues.end.round()}€',
                        style: GoogleFonts.actor(
                            textStyle: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w200,
                                color: Color.fromRGBO(74, 67, 236, 1))),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: RangeSlider(
                    max: 1000,
                    activeColor: const Color.fromRGBO(74, 67, 236, 1),
                    divisions: 100,
                    values: _currentRangeValues,
                    labels: RangeLabels(
                      _currentRangeValues.start.round().toString(),
                      _currentRangeValues.end.round().toString(),
                    ),
                    onChanged: (RangeValues values) {
                      setState(() {
                        _currentRangeValues = values;
                        rangeValuesSelected = values;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 20.0, left: 20.0, right: 20.0, bottom: 15),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _searchController.text = '';

                              _eventListBloc.add(
                                  FetchUpcomingListSearchableEvent(
                                      _currentCity,
                                      '',
                                      List.empty(),
                                      DateTime.now(),
                                      DateTime.now()
                                          .add(const Duration(days: 365)),
                                      0,
                                      1000000));
                            });
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 18, horizontal: 20),
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: const BorderSide(
                                color: Color.fromARGB(255, 187, 186, 186),
                                width: 0.5,
                              ),
                            ),
                          ),
                          child: Text(
                            'RESET',
                            style: GoogleFonts.actor(
                                textStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            )),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        flex: 3,
                        child: ElevatedButton(
                          onPressed: () {
                            switch (selectedDate) {
                              case "Today":
                                startDate = DateTime.now();
                                endDate = DateTime(
                                  startDate!.year,
                                  startDate!.month,
                                  startDate!.day,
                                  23,
                                  59,
                                  59,
                                  999,
                                );
                                break;
                              case "Tomorrow":
                                DateTime tomorrow =
                                    DateTime.now().add(const Duration(days: 1));
                                startDate = DateTime(
                                  tomorrow.year,
                                  tomorrow.month,
                                  tomorrow.day,
                                );
                                endDate = DateTime(
                                  tomorrow.year,
                                  tomorrow.month,
                                  tomorrow.day,
                                  23,
                                  59,
                                  59,
                                  999,
                                );
                                break;
                              case "This Week":
                                DateTime now = DateTime.now();

                                DateTime startOfWeek = now
                                    .subtract(Duration(days: now.weekday - 1));

                                DateTime endOfWeek =
                                    startOfWeek.add(const Duration(days: 6));

                                startDate = startOfWeek;
                                endDate = endOfWeek.add(const Duration(
                                    hours: 23,
                                    minutes: 59,
                                    seconds: 59,
                                    milliseconds: 999));
                                break;
                              case "Calendar":
                                if (startDate == null || endDate == null) {
                                  break;
                                }
                              default:
                                break;
                            }
                            setState(() {
                              _searchController.text = '';

                              _eventListBloc.add(
                                FetchUpcomingListSearchableEvent(
                                  _currentCity,
                                  '',
                                  eventTypeIds,
                                  startDate ?? DateTime.now(),
                                  endDate ??
                                      DateTime.now()
                                          .add(const Duration(days: 365)),
                                  _currentRangeValues.start,
                                  _currentRangeValues.end,
                                ),
                              );
                            });
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 18, horizontal: 20),
                            backgroundColor:
                                const Color.fromRGBO(74, 67, 236, 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: const BorderSide(
                                color: Color.fromARGB(255, 187, 186, 186),
                                width: 0.5,
                              ),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'APPLY',
                            style: GoogleFonts.actor(
                                textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            )),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _eventTypeListView(
      BuildContext context, List<EventTypeResponse> eventTypeList) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int index) {
        return EventTypeWidgetFilter(
            eventType: eventTypeList[index],
            cityName: widget.currentCity,
            onEventTypeSelected: (selectedEventType) {
              eventTypeIds.add(selectedEventType);
            },
            onEventTypeDeSelected: (deSelectedType) {
              eventTypeIds.remove(deSelectedType);
            },
            eventTypeIds: eventTypeIds);
      },
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      itemCount: eventTypeList.length,
    );
  }

  placesAutoCompleteTextField() {
    return Dialog(
      alignment: Alignment.topCenter,
      child: Container(
        //constraints: BoxConstraints(minHeight: 300),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GooglePlaceAutoCompleteTextField(
                textEditingController: controller,
                googleAPIKey: "AIzaSyAlKtaZlLjfVcE6fktFj9SB1wqRpFjQtFE",
                inputDecoration: const InputDecoration(
                  hintText: "Search your location",
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                ),
                debounceTime: 400,
                countries: const ["es", "de"],
                isLatLngRequired: true,
                getPlaceDetailWithLatLng: (Prediction prediction) {
                  _getLocation(prediction);
                },
                itemClick: (Prediction prediction) {
                  controller.text = prediction.description ?? "";
                  controller.selection = TextSelection.fromPosition(
                      TextPosition(
                          offset: prediction.description?.length ?? 0));
                },
                seperatedBuilder: const Divider(),
                containerHorizontalPadding: 10,
                itemBuilder: (context, index, Prediction prediction) {
                  return Container(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on),
                        const SizedBox(width: 7),
                        Expanded(child: Text(prediction.description ?? ""))
                      ],
                    ),
                  );
                },
                isCrossBtnShown: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 20),
                    backgroundColor: const Color.fromRGBO(74, 67, 236, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(
                        color: Color.fromARGB(255, 187, 186, 186),
                        width: 0.5,
                      ),
                    )),
                onPressed: () {
                  //print("Lugar seleccionado: ${controller.text}");
                  Navigator.of(context).pop(); // Cierra el diálogo
                },
                child: Text(
                  'Aceptar',
                  style: GoogleFonts.actor(
                      textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
