import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marikina_market_mobile/core/constants/app_colors.dart';
import 'package:marikina_market_mobile/features/auth/domain/entities/user.dart';
import 'package:marikina_market_mobile/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:marikina_market_mobile/features/auth/presentation/bloc/auth_event.dart';
import 'package:marikina_market_mobile/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:marikina_market_mobile/features/profile/presentation/bloc/profile_event.dart';
import 'package:marikina_market_mobile/features/profile/presentation/bloc/profile_state.dart';
import 'package:marikina_market_mobile/features/profile/presentation/widgets/change_password_card.dart';
import 'package:marikina_market_mobile/features/profile/presentation/widgets/edit_appbar.dart';

class ChangePasswordPage extends StatefulWidget {
  final User user;

  const ChangePasswordPage({
    super.key,
    required this.user
  });

  @override
  State<StatefulWidget> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController = TextEditingController();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
  }
  
  void _submit() {
    context.read<ProfileBloc>().add(UpdatePasswordSubmitted(
      userId: widget.user.userId, 
      currentPassword: _currentPasswordController.text, 
      newPassword: _newPasswordController.text, 
      confirmNewPassword: _confirmNewPasswordController.text
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EditAppbar(
        title: 'Change Password', 
        onPressed: () => context.pop()
      ),
      body: BlocListener<ProfileBloc, ProfileState>(
        listener:(context, state) {
          if (state is ChangePasswordNetworkError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.primaryRed,
              )
            );
          }

          if (state is PasswordChangedSuccessfully) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Password successfully changed. Please login again.'),
                backgroundColor: AppColors.primary,
              )
            );

            context.read<AuthBloc>().add(LogoutUser(false));
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Update you account password',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  const SizedBox(height: 20,),
                  ChangePasswordCard(
                    currentPasswordController: _currentPasswordController, 
                    newPasswordController: _newPasswordController, 
                    confirmNewPasswordController: _confirmNewPasswordController,
                    submit: _submit,
                  )
                ],
              ),
            ),
          )
        ),
      )
    );
  }
}