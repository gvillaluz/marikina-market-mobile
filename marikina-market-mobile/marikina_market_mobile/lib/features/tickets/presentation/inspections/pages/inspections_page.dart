import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marikina_market_mobile/core/router/routes.dart';
import 'package:marikina_market_mobile/core/shared/presentation/widgets/app_primary_btn.dart';
import 'package:marikina_market_mobile/features/tickets/domain/enums/violation_type.dart';
import 'package:marikina_market_mobile/features/tickets/presentation/inspections/bloc/inspection_bloc.dart';
import 'package:marikina_market_mobile/features/tickets/presentation/inspections/bloc/inspection_event.dart';
import 'package:marikina_market_mobile/features/tickets/presentation/inspections/bloc/inspection_state.dart';
import 'package:marikina_market_mobile/features/tickets/presentation/inspections/widgets/filter_row.dart';
import 'package:marikina_market_mobile/features/tickets/presentation/inspections/widgets/inspection_list_section.dart';

class InspectionsPage extends StatefulWidget {
  const InspectionsPage({super.key});

  @override
  State<StatefulWidget> createState() => _InspectionPageState();
}

class _InspectionPageState extends State<InspectionsPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;
  ViolationType _selectedViolationType = ViolationType.warning;

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
    final state = context.read<InspectionBloc>().state;

    if (_scrollController.position.pixels >= threshold &&
        !_isLoadingMore &&
        state is InspectionTicketsLoaded &&
        state.hasMore) {
      setState(() => _isLoadingMore = true);
      context.read<InspectionBloc>().add(
        LoadInspectionTickets(state.ticketSummary.length, _selectedViolationType),
      );
    }
  }

  void _handleChangeType(ViolationType type) {
    setState(() => _selectedViolationType = type);

    context.read<InspectionBloc>().add(
      LoadInspectionTickets(0, type),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          context.read<InspectionBloc>().add(LoadInspectionTickets(0, _selectedViolationType));

          await context.read<InspectionBloc>().stream.firstWhere(
            (state) => state is InspectionTicketsLoaded || state is InspectionError,
          );
        },
        child: BlocListener<InspectionBloc, InspectionState>(
          listener: (context, state) {
            if (state is InspectionTicketsLoaded || state is InspectionError) {
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
                    AppPrimaryButton(
                      label: 'New Inspection',
                      iconData: Icons.add,
                      onPressed: () => context.pushNamed(Routes.newInspectionName),
                    ),
                    const SizedBox(height: 10),
                    FilterRow(
                      typeSelected: _selectedViolationType,
                      onChange: (type) => _handleChangeType(type),
                    ),
                  ])
                ),
              ),
              
              const InspectionListSection(),
          
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