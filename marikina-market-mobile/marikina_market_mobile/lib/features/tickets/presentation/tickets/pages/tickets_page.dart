import 'package:flutter/material.dart';
import 'package:marikina_market_mobile/features/tickets/presentation/tickets/widgets/ticket_filter_row.dart';
import 'package:marikina_market_mobile/features/tickets/presentation/tickets/widgets/ticket_list_section.dart';

class TicketsPage extends StatelessWidget {
  const TicketsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
        },
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const TicketFilterRow()
                ])
              ),
            ),
            const TicketListSection()
          ],
        ),
      )
    );
  }
}