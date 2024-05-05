import 'package:student_go/models/response/purchase_overview_response/purchase_overview_response.dart';
import 'package:student_go/models/response/purchase_response.dart';
import 'package:student_go/models/response/purchase_ticket_response/purchase_ticket_response.dart';

abstract class PurchaseRepository {
  Future<PurchaseResponse> doEventPurchase(String eventId);
  Future<List<PurchaseOverviewResponse>> getAllEventsPurchasedByUser();
  Future<PurchaseTicketResponse> getPurchase(String purchaseId);
}
