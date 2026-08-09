import 'package:dio/dio.dart';
import 'package:marikina_market_mobile/core/errors/exceptions.dart';
import 'package:marikina_market_mobile/core/network/client.dart';
import 'package:marikina_market_mobile/features/tickets/data/models/ticket_detail_model.dart';

abstract class TicketRemoteDataSource {
  Future<TicketDetailModel> getTicketDetailById(int ticketId);
}

class TicketRemoteDataSourceImpl implements TicketRemoteDataSource {
  final ApiClient apiClient;
  TicketRemoteDataSourceImpl(this.apiClient);

  @override
  Future<TicketDetailModel> getTicketDetailById(int ticketId) async {
    try {
      final response = await apiClient.get('/ticket/$ticketId');

      return TicketDetailModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) throw ValidationException(e.response?.data['message'] ?? 'Invalid Ticket');

      if (e.response?.statusCode == 404) throw NotFoundException(e.response?.data['message'] ?? 'Ticket not found.');

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.receiveTimeout) {
        throw NetworkException('No internet connection. Please try again.');
      }

      throw ServerException('Something went wrong. Please try again later');
    }
  }
}