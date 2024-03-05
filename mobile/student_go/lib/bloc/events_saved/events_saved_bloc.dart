import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:student_go/models/response/event_saved_response.dart';
import 'package:student_go/models/response/general_exception.dart';
import 'package:student_go/models/response/student_info_response/student_info_response.dart';
import 'package:student_go/repository/student/student_repository.dart';

part 'events_saved_event.dart';
part 'events_saved_state.dart';

class EventsSavedBloc extends Bloc<EventsSavedEvent, EventsSavedState> {
  final StudentRepository studentRepository;
  EventsSavedBloc(this.studentRepository) : super(EventsSavedInitial()) {
    on<FetchEventsSaved>(_fetchEventsSaved);
    on<BookmarkEvent>(_saveOrUnsaveEvent);
  }

  void _fetchEventsSaved(
      EventsSavedEvent event, Emitter<EventsSavedState> emit) async {
    emit(EventsSavedLoading());
    try {
      final response = await studentRepository.getAllSavedEvents();
      emit(EventsSavedSuccess(response));
    } catch (e) {
      if (e is GeneralException) {
        if (e.status == 403 || e.status == 401) {
          emit(TokenNotValidState());
        }
        emit(EventsSavedEntityException(e, e.title!));
      } else {
        emit(EventsSavedError("An unexpected error occurred"));
      }
    }
  }

  void _saveOrUnsaveEvent(
      BookmarkEvent event, Emitter<EventsSavedState> emit) async {
    try {
      final response = await studentRepository.saveOrUnsaveEvent(event.eventId);
      // No emitimos EventsSavedLoading aquí
      emit(SaveUnsaveSuccess(response));
      // Después de guardar/quitar el evento, volvemos a cargar los eventos guardados
      add(FetchEventsSaved());
    } catch (e) {
      emit(EventsSavedError("An unexpected error occurred"));
    }
  }
}
