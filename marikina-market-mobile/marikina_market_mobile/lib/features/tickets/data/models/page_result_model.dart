import 'package:marikina_market_mobile/features/tickets/domain/entities/page_result.dart';

class PageResultModel<T> {
  final List<T> tickets;
  final bool hasMore;

  const PageResultModel({
    required this.tickets,
    required this.hasMore
  });

  factory PageResultModel.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT
    ) {
    return PageResultModel(
      tickets: (json['items'] as List)
          .map((item) => fromJsonT(item as Map<String, dynamic>))
          .toList(),
      hasMore: json['has_more'] as bool
    );
  }

  PageResult<E> toEntity<E>(E Function(T model) toEntityT) {
    return PageResult(
      tickets: tickets.map(toEntityT).toList(), 
      hasMore: hasMore
    );
  }
}