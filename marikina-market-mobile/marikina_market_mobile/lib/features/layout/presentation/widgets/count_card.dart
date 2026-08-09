import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:marikina_market_mobile/core/constants/app_colors.dart';

class CountCard extends StatelessWidget {
  final String type;
  final int count;

  const CountCard({
    super.key,
    required this.type,
    required this.count
  });

  Color _getContainerColor() {
    if (type == 'Ticket') {
      return AppColors.secondaryRed;
    } else if (type == 'Warning') {
      return AppColors.primaryYellow;
    }
    return AppColors.tertiary;
  }

  Color _getTextColor() {
    if (type == 'Ticket') {
      return AppColors.primaryRed;
    } else if (type == 'Warning') {
      return AppColors.primaryBlack;
    }
    return AppColors.primary;
  }

  IconData _getIcon() {
    if (type == 'Ticket') {
      return Icons.confirmation_num_outlined;
    } else if (type == 'Warning') {
      return Icons.warning_amber_outlined;
    }
    return Icons.calendar_today_outlined;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 15, 40, 15),
      decoration: BoxDecoration(
        color: _getContainerColor(),
        borderRadius: BorderRadius.circular(8)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            spacing: 20,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                _getIcon(),
                color: _getTextColor(),
              ),
              Text(
                '$type ${type == 'total' ? 'This Week' : 'Recorded'}',
                style: TextStyle(
                  color: _getTextColor()
                ),
              )
            ],
          ),
          Center(
            child: Text(
              count.toString(),
              style: TextStyle(
                color: _getTextColor(),
                fontSize: 25,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
        ],
      ),
    );
  }
}