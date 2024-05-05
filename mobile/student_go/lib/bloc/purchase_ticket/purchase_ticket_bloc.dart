import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:student_go/models/response/general_exception.dart';
import 'package:student_go/models/response/purchase_ticket_response/purchase_ticket_response.dart';
import 'package:student_go/repository/purchase/purchase_repository.dart';

part 'purchase_ticket_event.dart';
part 'purchase_ticket_state.dart';

class PurchaseTicketBloc
    extends Bloc<PurchaseTicketEvent, PurchaseTicketState> {
  final PurchaseRepository _purchaseRepository;
  PurchaseTicketBloc(this._purchaseRepository)
      : super(PurchaseTicketInitial()) {
    on<FetchPruchaseTicket>(_fetchTicket);
  }

  void _fetchTicket(
      FetchPruchaseTicket event, Emitter<PurchaseTicketState> emit) async {
    emit(PurchaseTicketLoading());
    try {
      final response = await _purchaseRepository.getPurchase(event.id);
      emit(PurchaseTicketSuccess(response));
    } catch (e) {
      if (e is GeneralException) {
        if (e.status == 403) {
          emit(TokenNotValidStatePurchaseTicket());
        }
        emit(PurchaseTicketEntityException(e, e.title!));
      } else {
        emit(PurchaseTicketError("An unespected error occurred"));
      }
    }
  }
}
