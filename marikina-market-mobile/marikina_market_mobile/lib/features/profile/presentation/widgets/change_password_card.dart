import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marikina_market_mobile/core/constants/app_colors.dart';
import 'package:marikina_market_mobile/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:marikina_market_mobile/features/profile/presentation/bloc/profile_state.dart';
import 'package:marikina_market_mobile/features/profile/presentation/widgets/back_btn.dart';
import 'package:marikina_market_mobile/features/profile/presentation/widgets/save_btn.dart';

class ChangePasswordCard extends StatelessWidget {
  final TextEditingController currentPasswordController;
  final TextEditingController newPasswordController;
  final TextEditingController confirmNewPasswordController;
  final VoidCallback submit;

  const ChangePasswordCard({
    super.key,
    required this.currentPasswordController,
    required this.newPasswordController,
    required this.confirmNewPasswordController,
    required this.submit
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000000).withValues(alpha: 0.25),
            offset: const Offset(-0.5, 0.5),
            blurRadius: 3.1,
            spreadRadius: -1,
          )
        ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'CURRENT PASSWORD'
          ),
          const SizedBox(height: 10,),
          TextField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.key),
              hintText: 'Enter current password',
              hintStyle: TextStyle(
                color: AppColors.lightGrey,
                fontSize: 14
              )
            ),
            controller: currentPasswordController,
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
          ),
          
          const SizedBox(height: 20,),

          const Text(
            'NEW PASSWORD'
          ),
          const SizedBox(height: 10,),
          TextField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.key),
              hintText: 'Enter new password',
              hintStyle: TextStyle(
                color: AppColors.lightGrey,
                fontSize: 14
              )
            ),
            controller: newPasswordController,
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
          ),
          
          const SizedBox(height: 20,),


          const Text(
            'CONFIRM NEW PASSWORD'
          ),
          const SizedBox(height: 10,),
          TextField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.key),
              hintText: 'Confirm new password',
              hintStyle: TextStyle(
                color: AppColors.lightGrey,
                fontSize: 14
              )
            ),
            controller: confirmNewPasswordController,
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
          ),
          
          const SizedBox(height: 20,),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.tertiary,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              spacing: 8,
              children: [
                const Icon(
                  Icons.info,
                  color: AppColors.primary,
                ),
                Expanded(
                  child: const Text(
                    'Make sure your password is easy for you to remember but hard to guess for others.',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 13
                    ),
                  )
                )
              ],
            ),
          ),

          const SizedBox(height: 20,),
          
          BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              return Column(
                children: [
                  if (state is ChangePasswordError)...{
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        state.message,
                        style: TextStyle(
                          color: AppColors.primaryRed,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  },

                  const SizedBox(height: 20,),

                  SaveBtn(onPressed: submit, isLoading: state is ChangePasswordLoading,),
                ],
              );
            },
          ),

          const SizedBox(height: 20,),

          BackBtn(onPressed: () => context.pop())
        ],
      ),
    );
  }
}