import 'package:marikina_market_mobile/features/tickets/domain/entities/vendor_summary.dart';

class VendorSummaryModel {
  final int id;
  final String stallNumber;
  final String tradeName;
  final String lastName;
  final String firstName;
  final String middleName;
  final String address;
  final int marketSectionId;
  final String marketSectionName;

  VendorSummaryModel({required this.id, required this.stallNumber, required this.tradeName, required this.lastName, required this.firstName, required this.middleName, required this.address, required this.marketSectionId, required this.marketSectionName});

  factory VendorSummaryModel.fromJson(Map<String, dynamic> json) {
    return VendorSummaryModel(
      id: json['vendor_id'] as int,
      stallNumber: json['stall_number'] as String, 
      tradeName: json['trade_name'] as String, 
      lastName: json['last_name'] as String, 
      firstName: json['first_name'] as String, 
      middleName: json['middle_name'] as String, 
      address: json['address'] as String, 
      marketSectionId: json['market_section_id'] as int, 
      marketSectionName: json['market_section_name'] as String
    );
  }

  VendorSummary toEntity() {
    return VendorSummary(
      id: id, 
      stallNumber: stallNumber, 
      tradeName: tradeName, 
      lastName: lastName, 
      firstName: firstName, 
      middleName: middleName, 
      address: address, 
      marketSectionId: marketSectionId, 
      marketSectionName: marketSectionName
    );
  }
}