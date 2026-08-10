import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marikina_market_mobile/features/tickets/domain/enums/ticket_status.dart';
import 'package:marikina_market_mobile/features/tickets/presentation/tickets/bloc/ticket_bloc.dart';
import 'package:marikina_market_mobile/features/tickets/presentation/tickets/bloc/ticket_event.dart';
import 'package:marikina_market_mobile/features/tickets/presentation/tickets/bloc/ticket_state.dart';
import 'package:marikina_market_mobile/features/tickets/presentation/tickets/widgets/ticket_filter_row.dart';
import 'package:marikina_market_mobile/features/tickets/presentation/tickets/widgets/ticket_list_section.dart';

class TicketsPage extends StatefulWidget {
  const TicketsPage({super.key});

  @override
  State<StatefulWidget> createState() => _TicketsPageState();
}

class _TicketsPageState extends State<TicketsPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;
  TicketStatus _selectedStatus = TicketStatus.active;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final threshold = _scrollController.position.maxScrollExtent - 200;
    final state = context.read<TicketBloc>().state;

    if (_scrollController.position.pixels >= threshold &&
        !_isLoadingMore &&
        state is TicketsLoaded &&
        state.hasMore) {
      setState(() => _isLoadingMore = true);
      context.read<TicketBloc>().add(
        LoadTicketSummary(
          offset: state.ticketSummary.length,
          status: _selectedStatus
        )
      );
    }
  }

  void _handleChangeStatus(TicketStatus status) {
    setState(() => _selectedStatus = status);

    context.read<TicketBloc>().add(
      LoadTicketSummary(
        offset: 0, 
        status: status
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          context.read<TicketBloc>().add(LoadTicketSummary(offset: 0, status: _selectedStatus));

          await context.read<TicketBloc>().stream.firstWhere(
            (state) => state is TicketsLoaded || state is TicketError,
          );
        },
        child: BlocListener<TicketBloc, TicketState>(
          listener: (context, state) {
            if (state is TicketsLoaded || state is TicketError) {
              setState(() => _isLoadingMore = false);
            }
          },
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    TicketFilterRow(
                      statusSelected: _selectedStatus,
                      onChange: (status) => _handleChangeStatus(status),
                    )
                  ])
                ),
              ),
              const TicketListSection(),

              SliverToBoxAdapter(
                child: _isLoadingMore
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : const SizedBox.shrink(),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 20,),)
            ],
          ),
        ),
      )
    );
  }
}