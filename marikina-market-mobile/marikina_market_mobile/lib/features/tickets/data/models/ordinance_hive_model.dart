import 'package:hive/hive.dart';
import 'package:marikina_market_mobile/core/shared/domain/enums/severity.dart';
import 'package:marikina_market_mobile/features/tickets/data/models/ordinance_model.dart';
import 'package:marikina_market_mobile/features/tickets/domain/entities/ordinance.dart';
import 'package:marikina_market_mobile/features/tickets/domain/enums/ordinance_category.dart';

part 'ordinance_hive_model.g.dart';

@HiveType(typeId: 0)
class OrdinanceHiveModel extends HiveObject {
  @HiveField(0)
  final int ordinanceId;

  @HiveField(1)
  final String ordinanceNo;

  @HiveField(2)
  final String ordinanceCode;

  @HiveField(3)
  final String title;

  @HiveField(4)
  final String description;

  @HiveField(5)
  final String category;

  @HiveField(6)
  final DateTime createdAt;

  @HiveField(7)
  final String severity;
  
  OrdinanceHiveModel({
    required this.ordinanceId, 
    required this.ordinanceNo, 
    required this.ordinanceCode,
    required this.title, 
    required this.description, 
    required this.category,
    required this.createdAt,
    required this.severity
  });

  factory OrdinanceHiveModel.fromModel(OrdinanceModel entity) {
    return OrdinanceHiveModel(
      ordinanceId: entity.ordinanceId,
      ordinanceNo: entity.ordinanceNo,
      ordinanceCode: entity.ordinanceCode,
      title: entity.title,
      description: entity.description,
      category: entity.category.value,
      createdAt: entity.createdAt,
      severity: entity.severity.value
    );
  }

  Ordinance toEntity() {
    return Ordinance(
      id: ordinanceId, 
      ordinanceNo: ordinanceNo, 
      ordinanceCode: ordinanceCode,
      title: title, 
      description: description, 
      category: OrdinanceCategory.fromValue(category), 
      severity: Severity.fromValue(severity),
      createdAt: createdAt
    );
  }
}