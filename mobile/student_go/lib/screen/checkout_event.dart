import 'package:flutter/material.dart';
import 'package:student_go/models/response/event_details_response/event_details_response.dart';

class CheckoutEvent extends StatelessWidget {
  final EventDetailsResponse event;
  const CheckoutEvent({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('Checkout')), body: Column());
  }
}
