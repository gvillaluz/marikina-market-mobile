import 'package:flutter/widgets.dart';
import 'package:marikina_market_mobile/features/layout/presentation/widgets/count_card.dart';

class WeeklyOverviewSection extends StatelessWidget {
  const WeeklyOverviewSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CountCard(type: 'Ticket', count: 3),
        const SizedBox(height: 20,),
        CountCard(type: 'Warning', count: 2),
        const SizedBox(height: 20,),
        CountCard(type: 'Total', count: 5),
      ],
    );
  }
}