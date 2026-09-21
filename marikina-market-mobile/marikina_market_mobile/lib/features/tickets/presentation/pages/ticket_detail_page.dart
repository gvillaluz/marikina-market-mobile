import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marikina_market_mobile/core/constants/app_colors.dart';
import 'package:marikina_market_mobile/core/router/routes.dart';
import 'package:marikina_market_mobile/features/tickets/domain/entities/duplicate_ordinance.dart';
import 'package:marikina_market_mobile/features/tickets/presentation/tickets/bloc/ticket_bloc.dart';
import 'package:marikina_market_mobile/features/tickets/presentation/tickets/bloc/ticket_state.dart';
import 'package:marikina_market_mobile/features/tickets/presentation/tickets/widgets/ticket_detail_content.dart';
import 'package:marikina_market_mobile/core/shared/presentation/widgets/skeleton_box.dart';

class TicketDetailPage extends StatelessWidget {
  final List<DuplicateOrdinance>? droppedOrdinances;

  const TicketDetailPage({
    this.droppedOrdinances,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        context.goNamed(Routes.inspectionsName);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.primary),
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.goNamed(Routes.inspectionsName);
              }
            },
          ),
          title: const Text(
            'Inspections',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: BlocConsumer<TicketBloc, TicketState>(
              listener: (context, state) {
                if (state is TicketError) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message))
                  );
                }
              },
              builder: (context, state) {
                if (state is TicketDetailLoading) {
                  return SkeletonBox(height: 500,);
                }
      
                if (state is TicketDetailLoaded) {
                  return TicketDetailContent(
                    ticket: state.ticket,
                    droppedOrdinances: droppedOrdinances,
                  );
                }
      
                if (state is TicketError) {
                  
                }
      
                return SizedBox.shrink();
              },
            )
          )
        ),
      ),
    );
  }
}