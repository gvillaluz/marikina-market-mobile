import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marikina_market_mobile/core/constants/app_colors.dart';
import 'package:marikina_market_mobile/core/router/route_args.dart';
import 'package:marikina_market_mobile/core/router/routes.dart';
import 'package:marikina_market_mobile/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:marikina_market_mobile/features/auth/presentation/bloc/auth_event.dart';
import 'package:marikina_market_mobile/features/auth/presentation/bloc/auth_state.dart';
import 'package:marikina_market_mobile/features/auth/presentation/widgets/login_btn.dart';
import 'package:marikina_market_mobile/core/shared/presentation/widgets/login_card_header.dart';
import 'package:marikina_market_mobile/features/auth/presentation/widgets/login_fields.dart';

class LoginCard extends StatefulWidget {
  const LoginCard({super.key});

  @override
  State<StatefulWidget> createState() => _LoginCardState();
}

class _LoginCardState extends State<LoginCard> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    context.read<AuthBloc>().add(
      LoginSubmitted(
        username: _usernameController.text.trim(),
        password: _passwordController.text.trim(),
      ),
    );
  }

  void _forgotPassword(BuildContext context) {
    if (_usernameController.text.isNotEmpty) {
      context.push(
        Routes.forgotPasswordOptionName,
        extra: ForgotPasswordOptionArgs(
          username: _usernameController.text.trim(),
        ),
      );
    } else {
      context.push(Routes.findAccount);
    }
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

          const SizedBox(height: 20),

          LoginFields(
            usernameController: _usernameController,
            passwordController: _passwordController,
          ),

          TextButton(
            onPressed: () => _forgotPassword(context),
            child: Text('Forgot password?'),
          ),

          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    AuthBtn(
                      isLoading: state is AuthLoginLoading,
                      onPressed: _submit,
                      label: 'LOGIN',
                    ),

                    const SizedBox(height: 10),

                    if (state is AuthInvalidCredentials) ...{
                      Text(
                        state.message,
                        style: TextStyle(color: AppColors.primaryRed),
                        textAlign: TextAlign.center,
                      ),
                    },
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
