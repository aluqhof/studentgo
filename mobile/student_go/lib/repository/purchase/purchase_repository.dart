import 'package:student_go/models/dto/purchase_dto.dart';
import 'package:student_go/models/response/event_overview_response/event_overview_response.dart';
import 'package:student_go/models/response/purchase_response.dart';

abstract class PurchaseRepository {
  Future<PurchaseResponse> doEventPurchase(PurchaseDto purchase);
  Future<List<EventOverviewResponse>> getAllEventsPurchasedByUser();
}
