import 'package:marikina_market_mobile/core/shared/domain/enums/severity.dart';
import 'package:marikina_market_mobile/features/tickets/domain/enums/ordinance_category.dart';

class Ordinance {
  final int id;
  final String ordinanceNo;
  final String ordinanceCode;
  final String title;
  final String description;
  final OrdinanceCategory category;
  final Severity severity;
  final DateTime createdAt;

  Ordinance({
    required this.id, 
    required this.ordinanceNo, 
    required this.ordinanceCode, 
    required this.title, 
    required this.description, 
    required this.category, 
    required this.severity,
    required this.createdAt
  });
}