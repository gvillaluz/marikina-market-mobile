import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marikina_market_mobile/core/constants/app_colors.dart';
import 'package:marikina_market_mobile/core/shared/domain/enums/ticket_status.dart';
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
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;
  TicketStatus _selectedStatus = TicketStatus.pending;

  Timer? _debouncer;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    _debouncer?.cancel();
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
          search: _searchController.text.trim(),
          offset: state.ticketSummary.length,
          status: _selectedStatus,
        ),
      );
    }
  }

  void _onSearchChanged(String value) {
    if (_debouncer?.isActive ?? false) _debouncer!.cancel();

    _debouncer = Timer(const Duration(milliseconds: 400), () {
      context.read<TicketBloc>().add(
        LoadTicketSummary(
          search: _searchController.text.trim(),
          offset: 0,
          status: _selectedStatus,
        ),
      );
    });
  }

  void _handleChangeStatus(TicketStatus status) {
    setState(() => _selectedStatus = status);

    context.read<TicketBloc>().add(
      LoadTicketSummary(
        search: _searchController.text.trim(),
        offset: 0,
        status: status,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          context.read<TicketBloc>().add(
            LoadTicketSummary(
              search: _searchController.text.trim(),
              offset: 0,
              status: _selectedStatus,
            ),
          );

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
            physics: AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Tickets',
                        style: TextStyle(
                          color: AppColors.primaryBlack,
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Review issued tickets and settlement status.',
                        style: TextStyle(
                          color: AppColors.mediumGrey,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 18),
                      ValueListenableBuilder<TextEditingValue>(
                        valueListenable: _searchController,
                        builder: (context, value, child) {
                          return TextField(
                            controller: _searchController,
                            onChanged: _onSearchChanged,
                            textInputAction: TextInputAction.search,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.search,
                                color: AppColors.mediumGrey,
                              ),
                              suffixIcon: value.text.isEmpty
                                  ? null
                                  : IconButton(
                                      tooltip: 'Clear search',
                                      onPressed: () {
                                        _searchController.clear();
                                        _onSearchChanged('');
                                      },
                                      icon: const Icon(Icons.close),
                                    ),
                              hintText: 'Search tickets',
                              hintStyle: const TextStyle(
                                color: AppColors.mediumGrey,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 14,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide(
                                  color: AppColors.lightGrey.withValues(
                                    alpha: 0.65,
                                  ),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(
                                  color: AppColors.primary,
                                  width: 1.5,
                                ),
                              ),
                            ),
                            onTapOutside: (event) =>
                                FocusScope.of(context).unfocus(),
                          );
                        },
                      ),
                      const SizedBox(height: 14),
                      TicketFilterRow(
                        statusSelected: _selectedStatus,
                        onChange: _handleChangeStatus,
                      ),
                    ],
                  ),
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

              const SliverToBoxAdapter(child: SizedBox(height: 20)),
            ],
          ),
        ),
      ),
    );
  }
}
