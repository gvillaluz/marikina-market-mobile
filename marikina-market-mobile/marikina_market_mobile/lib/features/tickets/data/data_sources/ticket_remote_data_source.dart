import 'package:dio/dio.dart';
import 'package:marikina_market_mobile/core/errors/exceptions.dart';
import 'package:marikina_market_mobile/core/network/client.dart';
import 'package:marikina_market_mobile/core/shared/data/models/page_result_model.dart';
import 'package:marikina_market_mobile/features/tickets/data/models/ticket_detail_model.dart';
import 'package:marikina_market_mobile/features/tickets/data/models/ticket_summary_model.dart';
import 'package:marikina_market_mobile/core/shared/domain/enums/ticket_status.dart';

abstract class TicketRemoteDataSource {
  Future<PageResultModel<TicketSummaryModel>> loadTickets(
    int offset,
    TicketStatus status,
  );
  Future<TicketDetailModel> getTicketDetailById(int ticketId);
}

class TicketRemoteDataSourceImpl implements TicketRemoteDataSource {
  final ApiClient apiClient;
  TicketRemoteDataSourceImpl(this.apiClient);

  @override
  Future<PageResultModel<TicketSummaryModel>> loadTickets(
    int offset,
    TicketStatus status,
  ) async {
    try {
      final response = await apiClient.get(
        '/enforcer/tickets?offset=$offset&status=${status.value}',
      );

      final data = response.data;

      if (data == null) return PageResultModel(items: [], hasMore: false);

      return PageResultModel.fromJson(
        data,
        (json) => TicketSummaryModel.fromJson(json),
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw ValidationException(e.response?.data['message'] ?? '');
      }

      if (e.response?.statusCode == 400) {
        throw UnauthorizedException(
          e.response?.data['message'] ?? 'Unauthorized.',
        );
      }

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.receiveTimeout) {
        throw NetworkException('No internet connection. Please try again.');
      }

      throw ServerException('Something went wrong. Please try again later');
    }
  }

  @override
  Future<TicketDetailModel> getTicketDetailById(int ticketId) async {
    try {
      final response = await apiClient.get('/enforcer/tickets/$ticketId');

      return TicketDetailModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw ValidationException(
          e.response?.data['message'] ?? 'Invalid Ticket',
        );
      }

      if (e.response?.statusCode == 404) {
        throw NotFoundException(
          e.response?.data['message'] ?? 'Ticket not found.',
        );
      }

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.receiveTimeout) {
        throw NetworkException('No internet connection. Please try again.');
      }

      throw ServerException('Something went wrong. Please try again later');
    }
  }
}
