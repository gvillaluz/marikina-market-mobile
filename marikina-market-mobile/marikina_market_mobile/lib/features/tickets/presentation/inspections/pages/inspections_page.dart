import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marikina_market_mobile/core/constants/app_colors.dart';
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
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;
  ViolationType _selectedViolationType = ViolationType.warning;

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
    final state = context.read<InspectionBloc>().state;

    if (_scrollController.position.pixels >= threshold &&
        !_isLoadingMore &&
        state is InspectionTicketsLoaded &&
        state.hasMore) {
      setState(() => _isLoadingMore = true);
      context.read<InspectionBloc>().add(
        LoadInspectionTickets(
          search: _searchController.text.trim(),
          offset: state.ticketSummary.length,
          type: _selectedViolationType,
        ),
      );
    }
  }

  void _onSearchChanged(String value) {
    if (_debouncer?.isActive ?? false) _debouncer!.cancel();

    _debouncer = Timer(const Duration(milliseconds: 400), () {
      context.read<InspectionBloc>().add(
        LoadInspectionTickets(
          search: _searchController.text.trim(),
          offset: 0,
          type: _selectedViolationType,
        ),
      );
    });
  }

  void _handleChangeType(ViolationType type) {
    setState(() => _selectedViolationType = type);

    context.read<InspectionBloc>().add(
      LoadInspectionTickets(
        search: _searchController.text.trim(),
        offset: 0,
        type: type,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () async {
          context.read<InspectionBloc>().add(
            LoadInspectionTickets(
              search: _searchController.text.trim(),
              offset: 0,
              type: _selectedViolationType,
            ),
          );

          await context.read<InspectionBloc>().stream.firstWhere(
            (state) =>
                state is InspectionTicketsLoaded || state is InspectionError,
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
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Inspections',
                        style: TextStyle(
                          color: AppColors.primaryBlack,
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Review and manage issued inspection tickets.',
                        style: TextStyle(
                          color: AppColors.mediumGrey,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 18),
                      AppPrimaryButton(
                        label: 'New Inspection',
                        iconData: Icons.add,
                        onPressed: () =>
                            context.pushNamed(Routes.newInspectionName),
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
                              hintText: 'Search inspections',
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
                      FilterRow(
                        typeSelected: _selectedViolationType,
                        onChange: _handleChangeType,
                      ),
                    ],
                  ),
                ),
              ),

              InspectionListSection(
                onRetry: () => context.read<InspectionBloc>().add(
                  LoadInspectionTickets(
                    search: _searchController.text.trim(),
                    offset: 0,
                    type: _selectedViolationType,
                  ),
                ),
              ),

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
