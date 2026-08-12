import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marikina_market_mobile/core/connectivity/connectivity_status.dart';
import 'package:marikina_market_mobile/core/connectivity/cubit/connectivity_cubit.dart';
import 'package:marikina_market_mobile/core/constants/app_colors.dart';
import 'package:marikina_market_mobile/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:marikina_market_mobile/features/auth/presentation/bloc/auth_state.dart';

class UserBanner extends StatelessWidget {
  const UserBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            color: Colors.grey.shade200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome, ${state.user.firstName} ${state.user.lastName}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    letterSpacing: .7
                  ),
                ),
                Text(
                  'Market ${state.user.role.value}',
                  style: const TextStyle(
                    fontSize: 16
                  ),
                ),

                const SizedBox(height: 6,),

                BlocBuilder<ConnectivityCubit, ConnectivityStatus>(
                  builder: (context, connectivityStatus) {
                    final bool isOnline = connectivityStatus == ConnectivityStatus.online;

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 7,
                      children: [
                        Container(
                          height: 10,
                          width: 10,
                          decoration: BoxDecoration(
                            color: isOnline ? Colors.green : Colors.red,
                            borderRadius: BorderRadius.circular(50)
                          ),
                        ),
                        Text(
                          'Status: ${isOnline ? 'Online' : 'Offline'}',
                          style: const TextStyle(
                            fontSize: 16
                          ),
                        )
                      ],
                    );
                  }
                )
              ],
            )
          );
        }
        return Container(
          padding: const EdgeInsets.all(20),
          color: AppColors.secondaryRed,
          child: const Text(
            'You are not authorize to access this application',
            style: TextStyle(
              color: AppColors.primaryRed
            ),
          ),
        );
      }
    );
  }
}