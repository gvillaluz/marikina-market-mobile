import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marikina_market_mobile/core/router/routes.dart';
import 'package:marikina_market_mobile/core/shared/presentation/widgets/app_primary_btn.dart';
import 'package:marikina_market_mobile/features/tickets/presentation/inspections/bloc/inspection_bloc.dart';
import 'package:marikina_market_mobile/features/tickets/presentation/inspections/bloc/inspection_event.dart';
import 'package:marikina_market_mobile/features/tickets/presentation/inspections/bloc/inspection_state.dart';
import 'package:marikina_market_mobile/features/tickets/presentation/inspections/widgets/filter_row.dart';
import 'package:marikina_market_mobile/features/tickets/presentation/inspections/widgets/inspection_list_section.dart';

class InspectionsPage extends StatelessWidget {
  const InspectionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          context.read<InspectionBloc>().add(LoadInspectionTickets());

          await context.read<InspectionBloc>().stream.firstWhere(
            (state) => state is InspectionTicketsLoaded || state is InspectionError,
          );
        },
        child: CustomScrollView(
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
                  const FilterRow(),
                ])
              ),
            ),
            
            const InspectionListSection(),
            const SliverToBoxAdapter(child: SizedBox(height: 20,),)
          ],
        ),
      )
    );
  }
}