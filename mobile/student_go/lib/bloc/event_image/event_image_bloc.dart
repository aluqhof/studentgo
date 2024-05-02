import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:student_go/models/response/general_exception.dart';
import 'package:student_go/models/response/validation_exception/validation_exception.dart';
import 'package:student_go/repository/event/event_repository.dart';

part 'event_image_event.dart';
part 'event_image_state.dart';

class EventImageBloc extends Bloc<EventImageEvent, EventImageState> {
  final EventRepository eventRepository;
  EventImageBloc(this.eventRepository) : super(EventImageInitial()) {
    on<FetchEventImage>(_fetchEventImage);
  }

  void _fetchEventImage(
      FetchEventImage event, Emitter<EventImageState> emit) async {
    emit(EventImageLoading());
    try {
      final response =
          await eventRepository.getEventPhoto(event.id, event.index);
      emit(EventImageSuccess(response));
    } catch (e) {
      if (e is GeneralException) {
        if (e.status == 403) {
          emit(TokenNotValidStateEventImage());
        }
        emit(EventImageEntityException(e, e.title!));
      } else if (e is ValidationException) {
        emit(EventImageValidationException(e, e.title!));
      } else {
        emit(EventImageError("An unespected error occurred"));
      }
    }
  }
}
