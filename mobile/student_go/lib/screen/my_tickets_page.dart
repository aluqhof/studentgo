import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_go/bloc/all_events_purchased_by_user/all_events_purchased_user_bloc.dart';
import 'package:student_go/repository/purchase/purchase_repository.dart';
import 'package:student_go/repository/purchase/purchase_repository_impl.dart';
import 'package:student_go/widgets/drawer_widget.dart';
import 'package:student_go/widgets/ticket_card_widget.dart';

class MyTicketsPage extends StatefulWidget {
  const MyTicketsPage({super.key});

  @override
  State<MyTicketsPage> createState() => _MyTicketsPageState();
}

class _MyTicketsPageState extends State<MyTicketsPage> {
  late PurchaseRepository purchaseRepository;
  late AllEventsPurchasedUserBloc _purchasedUserBloc;

  @override
  void initState() {
    purchaseRepository = PurchaseRepositoryImpl();
    _purchasedUserBloc = AllEventsPurchasedUserBloc(purchaseRepository)
      ..add(FetchAllEventsPurchasedUser());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(
                Icons.menu_rounded,
                color: Color.fromARGB(255, 0, 0, 0),
                size: 30,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
          title: Text(
            'My Tickets',
            style: GoogleFonts.actor(),
          ),
        ),
        drawer: const DrawerWidget(),
        body: BlocProvider.value(
          value: _purchasedUserBloc,
          child: BlocBuilder<AllEventsPurchasedUserBloc,
              AllEventsPurchasedUserState>(
            builder: (context, state) {
              if (state is AllEventsPurchasedUserInitial ||
                  state is AllEventsPurchasedUserLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is AllEventsPurchasedUserSuccess) {
                return ListView.builder(
                  itemCount: state.purchases.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return TicketCardWidget(
                        purchaseOverviewResponse: state.purchases[index]);
                  },
                );
              } else {
                return const Center(
                  child: Text('Error'),
                );
              }
            },
          ),
        ));
  }
}
