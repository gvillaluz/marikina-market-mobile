import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:marikina_market_mobile/core/connectivity/cubit/connectivity_cubit.dart';
import 'package:marikina_market_mobile/core/errors/result.dart';
import 'package:marikina_market_mobile/core/network/client.dart';
import 'package:marikina_market_mobile/core/network/network_info.dart';
import 'package:marikina_market_mobile/core/router/app_router.dart';
import 'package:marikina_market_mobile/core/storage/secure_storage_service.dart';
import 'package:marikina_market_mobile/core/storage/secure_storage_service_impl.dart';
import 'package:marikina_market_mobile/features/auth/data/data_sources/auth_local_data_source.dart';
import 'package:marikina_market_mobile/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:marikina_market_mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:marikina_market_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:marikina_market_mobile/features/auth/domain/services/token_service.dart';
import 'package:marikina_market_mobile/features/auth/domain/services/token_service_impl.dart';
import 'package:marikina_market_mobile/features/auth/domain/use_cases/check_auth_status_use_case.dart';
import 'package:marikina_market_mobile/features/auth/domain/use_cases/login_user_use_case.dart';
import 'package:marikina_market_mobile/features/auth/domain/use_cases/logout_user_use_case.dart';
import 'package:marikina_market_mobile/features/auth/domain/use_cases/mandatory_change_password_use_case.dart';
import 'package:marikina_market_mobile/features/auth/domain/use_cases/refresh_tokens_use_case.dart';
import 'package:marikina_market_mobile/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:marikina_market_mobile/features/auth/presentation/bloc/auth_event.dart';
import 'package:marikina_market_mobile/features/profile/data/data_sources/profile_remote_data_source.dart';
import 'package:marikina_market_mobile/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:marikina_market_mobile/features/profile/domain/repositories/profile_repository.dart';
import 'package:marikina_market_mobile/features/profile/domain/use_cases/change_password_use_case.dart';
import 'package:marikina_market_mobile/features/profile/domain/use_cases/edit_profile_use_case.dart';
import 'package:marikina_market_mobile/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:marikina_market_mobile/features/tickets/data/data_sources/inspection_local_data_source.dart';
import 'package:marikina_market_mobile/features/tickets/data/data_sources/inspection_remote_data_source.dart';
import 'package:marikina_market_mobile/features/tickets/data/data_sources/ticket_remote_data_source.dart';
import 'package:marikina_market_mobile/features/tickets/data/models/ordinance_hive_model.dart';
import 'package:marikina_market_mobile/features/tickets/data/repositories/inspection_repository_impl.dart';
import 'package:marikina_market_mobile/features/tickets/data/repositories/ticket_repository_impl.dart';
import 'package:marikina_market_mobile/features/tickets/domain/repositories/inspection_repository.dart';
import 'package:marikina_market_mobile/features/tickets/domain/repositories/ticket_repository.dart';
import 'package:marikina_market_mobile/features/tickets/domain/use_cases/get_fine_summary_use_case.dart';
import 'package:marikina_market_mobile/features/tickets/domain/use_cases/load_inspection_list_use_case.dart';
import 'package:marikina_market_mobile/features/tickets/domain/use_cases/load_ordinances_use_case.dart';
import 'package:marikina_market_mobile/features/tickets/domain/use_cases/load_ticket_detail_use_case.dart';
import 'package:marikina_market_mobile/features/tickets/domain/use_cases/save_inspection_ticket_use_case.dart';
import 'package:marikina_market_mobile/features/tickets/domain/use_cases/search_vendor_by_code_use_case.dart';
import 'package:marikina_market_mobile/features/tickets/domain/use_cases/search_vendor_by_stall_use_case.dart';
import 'package:marikina_market_mobile/features/tickets/presentation/inspections/bloc/inspection_bloc.dart';
import 'package:marikina_market_mobile/features/tickets/presentation/tickets/bloc/ticket_bloc.dart';

final sl = GetIt.instance;

Future<void> init(Box<OrdinanceHiveModel> ordinanceBox) async {
  sl.registerLazySingleton(() => ApiClient(
    refreshAction: () async {
      final refreshUseCase = sl<RefreshTokensUseCase>();
      final result = await refreshUseCase.call();
      return result is Success;
    },
    onAuthFailure: () async {
      sl<AuthBloc>().add(LogoutUser(true));
    },
  ));
  sl.registerLazySingleton<SecureStorageService>(() => SecureStorageServiceImpl(storage: FlutterSecureStorage()));
  sl.registerLazySingleton<TokenService>(() => TokenServiceImpl());
  sl.registerLazySingleton(() => Connectivity());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton(() => ConnectivityCubit(sl()));


  sl.registerLazySingleton<AuthLocalDataSource>(() => AuthLocalDataSourceImpl(storageService: sl()));
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(apiClient: sl()));
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(localDataSource: sl(), remoteDataSource: sl()));
  sl.registerLazySingleton(() => CheckAuthStatusUseCase(sl()));
  sl.registerLazySingleton(() => LoginUserUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUserUseCase(sl()));
  sl.registerLazySingleton(() => MandatoryChangePasswordUseCase(sl()));
  sl.registerLazySingleton(() => RefreshTokensUseCase(sl()));
  sl.registerLazySingleton(() => AuthBloc(
    connectivityCubit: sl(),
    checkAuthStatusUseCase: sl(),
    loginUserUseCase: sl(),
    logoutUserUseCase: sl(),
    mandatoryChangePasswordUseCase: sl(),
    refreshTokensUseCase: sl()
  ));
  sl.registerLazySingleton(() => AppRouter(authBloc: sl()));


  sl.registerLazySingleton<Box<OrdinanceHiveModel>>(() => ordinanceBox);
  sl.registerLazySingleton<InspectionRemoteDataSource>(() => InspectionRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<InspectionLocalDataSource>(() => InspectionLocalDataSourceImpl(sl()));
  sl.registerLazySingleton<InspectionRepository>(() => InspectionRepositoryImpl(sl(), sl()));
  sl.registerLazySingleton(() => LoadInspectionListUseCase(sl()));
  sl.registerLazySingleton(() => LoadOrdinancesUseCase(sl()));
  sl.registerLazySingleton(() => SearchVendorByCodeUseCase(sl()));
  sl.registerLazySingleton(() => SearchVendorByStallUseCase(sl()));
  sl.registerLazySingleton(() => GetFineSummaryUseCase(sl()));
  sl.registerLazySingleton(() => SaveInspectionTicketUseCase(sl()));
  sl.registerFactory(() => InspectionBloc(
    loadInspectionListUseCase: sl(),
    loadOrdinancesUseCase: sl(),
    searchVendorByCodeUseCase: sl(),
    searchVendorByStallUseCase: sl(),
    getFineSummaryUseCase: sl(),
    saveInspectionTicketUseCase: sl()
  ));

  sl.registerLazySingleton<TicketRemoteDataSource>(() => TicketRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<TicketRepository>(() => TicketRepositoryImpl(sl()));
  sl.registerLazySingleton(() => LoadTicketDetailUseCase(sl()));
  sl.registerFactory(() => TicketBloc(
    loadTicketDetailUseCase: sl()
  ));

  
  sl.registerLazySingleton<ProfileRemoteDataSource>(() => ProfileRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<ProfileRepository>(() => ProfileRepositoryImpl(sl()));
  sl.registerLazySingleton(() => EditProfileUseCase(sl(), sl()));
  sl.registerLazySingleton(() => ChangePasswordUseCase(sl()));
  sl.registerFactory(() => ProfileBloc(
    editProfileUseCase: sl(),
    changePasswordUseCase: sl()
  ));
}