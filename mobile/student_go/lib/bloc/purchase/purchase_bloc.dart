import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:student_go/models/dto/purchase_dto.dart';
import 'package:student_go/models/response/general_exception.dart';
import 'package:student_go/models/response/purchase_response.dart';
import 'package:student_go/repository/purchase/purchase_repository.dart';

part 'purchase_event.dart';
part 'purchase_state.dart';

class PurchaseBloc extends Bloc<PurchaseEvent, PurchaseState> {
  final PurchaseRepository purchaseRepository;
  PurchaseBloc(this.purchaseRepository) : super(PurchaseInitial()) {
    on<FetchPurchase>(_fetchPurchase);
  }

  void _fetchPurchase(FetchPurchase event, Emitter<PurchaseState> emit) async {
    emit(PurchaseLoading());
    try {
      final PurchaseDto purchaseDto = PurchaseDto(
          eventId: event.eventId, numberOfTickets: event.numberOfTickets);
      final response = await purchaseRepository.doEventPurchase(purchaseDto);
      emit(PurchaseSuccess(response));
    } catch (e) {
      if (e is GeneralException) {
        if (e.status == 403 || e.status == 401) {
          emit(TokenNotValidState());
        }
        emit(PurchaseEntityException(e, e.title!));
      } else {
        emit(PurchaseError("An unexpected error occurred"));
      }
    }
  }
}
