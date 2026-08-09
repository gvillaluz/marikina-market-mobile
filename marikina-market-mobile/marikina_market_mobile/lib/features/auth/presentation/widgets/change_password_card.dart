import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marikina_market_mobile/core/constants/app_colors.dart';
import 'package:marikina_market_mobile/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:marikina_market_mobile/features/auth/presentation/bloc/auth_event.dart';
import 'package:marikina_market_mobile/features/auth/presentation/bloc/auth_state.dart';
import 'package:marikina_market_mobile/features/auth/presentation/widgets/change_password_fields.dart';
import 'package:marikina_market_mobile/features/auth/presentation/widgets/login_btn.dart';
import 'package:marikina_market_mobile/features/auth/presentation/widgets/login_card_header.dart';

class ChangePasswordCard extends StatefulWidget {
  const ChangePasswordCard({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _ChangePasswordCardState();
}

class _ChangePasswordCardState extends State<ChangePasswordCard> {
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController = TextEditingController();
  int userId = 0;

  @override
  void initState() {
    super.initState();

    var authState = context.read<AuthBloc>().state;
    
    if (authState is Authenticated) {
      userId = authState.user.userId;
    }
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    context.read<AuthBloc>().add(ChangePasswordSubmitted(
      userId: userId, 
      currentPassword: _currentPasswordController.text, 
      newPassword: _newPasswordController.text, 
      confirmNewPassword: _confirmNewPasswordController.text
    ));
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    
    return Container(
      width: screenSize.width * 0.9,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.09), 
            blurRadius: 15, 
            spreadRadius: 1, 
            offset: const Offset(0, 4), 
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const LoginCardHeader(),
          ChangePasswordFields(
            currentPasswordController: _currentPasswordController, 
            newPasswordController: _newPasswordController, 
            confirmNewPasswordController: _confirmNewPasswordController
          ),
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              return Column(
                children: [

                  if (state is AuthChangePasswordError)...{
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

                  AuthBtn(
                    isLoading: state is AuthChangePasswordLoading,
                    onPressed: _submit,
                    label: 'UPDATE PASSWORD',
                  ),
                ],
              );
            }
          )
        ],
      ),
    );
  }
}