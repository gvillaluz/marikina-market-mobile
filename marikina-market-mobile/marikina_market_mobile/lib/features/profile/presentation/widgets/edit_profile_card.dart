import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marikina_market_mobile/core/constants/app_colors.dart';
import 'package:marikina_market_mobile/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:marikina_market_mobile/features/profile/presentation/bloc/profile_state.dart';
import 'package:marikina_market_mobile/features/profile/presentation/widgets/back_btn.dart';
import 'package:marikina_market_mobile/features/profile/presentation/widgets/save_btn.dart';

class EditProfileCard extends StatelessWidget {
  final TextEditingController lastNameController;
  final TextEditingController firstNameController;
  final TextEditingController middleNameController;
  final VoidCallback onSaveChanges;

  const EditProfileCard({
    super.key,
    required this.lastNameController,
    required this.firstNameController,
    required this.middleNameController,
    required this.onSaveChanges
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
            'LAST NAME'
          ),
          const SizedBox(height: 10,),
          TextField(
            controller: lastNameController,
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
          ),
          
          const SizedBox(height: 20,),

          const Text(
            'FIRST NAME'
          ),
          const SizedBox(height: 10,),
          TextField(
            controller: firstNameController,
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
          ),
          
          const SizedBox(height: 20,),

          const Text(
            'MIDDLE NAME'
          ),
          const SizedBox(height: 10,),
          TextField(
            controller: middleNameController,
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
          ),

          const SizedBox(height: 20,),

          BlocBuilder<ProfileBloc, ProfileState>(
            builder:(context, state) => SaveBtn(onPressed: onSaveChanges, isLoading: state is EditProfileLoading,),
          ),

          const SizedBox(height: 20,),

          BackBtn(onPressed: () => context.pop())
        ],
      ),
    );
  }
}