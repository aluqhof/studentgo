import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:student_go/models/response/purchase_overview_response/purchase_overview_response.dart';
import 'package:student_go/models/response/general_exception.dart';
import 'package:student_go/repository/purchase/purchase_repository.dart';

part 'all_events_purchased_user_event.dart';
part 'all_events_purchased_user_state.dart';

class AllEventsPurchasedUserBloc
    extends Bloc<AllEventsPurchasedUserEvent, AllEventsPurchasedUserState> {
  final PurchaseRepository purchaseRepository;
  AllEventsPurchasedUserBloc(this.purchaseRepository)
      : super(AllEventsPurchasedUserInitial()) {
    on<FetchAllEventsPurchasedUser>(_fetchAllEvents);
  }

  void _fetchAllEvents(FetchAllEventsPurchasedUser event,
      Emitter<AllEventsPurchasedUserState> emit) async {
    emit(AllEventsPurchasedUserLoading());
    try {
      final response = await purchaseRepository.getAllEventsPurchasedByUser();
      emit(AllEventsPurchasedUserSuccess(response));
    } catch (e) {
      if (e is GeneralException) {
        if (e.status == 403) {
          emit(TokenNotValidState());
        }
        emit(AllEventsEntityException(e, e.title!));
      } else {
        emit(AllEventsPurchasedUserError("An unespected error occurred"));
      }
    }
  }
}
