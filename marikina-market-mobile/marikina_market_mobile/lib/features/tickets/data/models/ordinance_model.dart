import 'package:marikina_market_mobile/core/shared/domain/enums/severity.dart';
import 'package:marikina_market_mobile/features/tickets/domain/entities/ordinance.dart';
import 'package:marikina_market_mobile/features/tickets/domain/enums/ordinance_category.dart';

class OrdinanceModel {
  final int ordinanceId;
  final String ordinanceNo;
  final String ordinanceCode;
  final String title;
  final String description;
  final OrdinanceCategory category;
  final Severity severity;
  final DateTime createdAt;
  
  OrdinanceModel({
    required this.ordinanceId, 
    required this.ordinanceNo, 
    required this.ordinanceCode, 
    required this.title, 
    required this.description, 
    required this.category, 
    required this.severity,
    required this.createdAt
  });

  factory OrdinanceModel.fromJson(Map<String, dynamic> json) {
    return OrdinanceModel(
      ordinanceId: json['id'] as int, 
      ordinanceNo: json['ordinance_no'] as String, 
      ordinanceCode: json['code'] as String,
      title: json['title'] as String, 
      description: json['description'] as String, 
      category: OrdinanceCategory.fromValue(json['category'] as String), 
      severity: Severity.fromValue(json['severity'] as String),
      createdAt: DateTime.parse(json['created_at'] as String)
    );
  }

  Ordinance toEntity() {
    return Ordinance(
      id: ordinanceId, 
      ordinanceNo: ordinanceNo, 
      ordinanceCode: ordinanceCode,
      title: title, 
      description: description, 
      category: category, 
      severity: severity,
      createdAt: createdAt
    );
  }
}