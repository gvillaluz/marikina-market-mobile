import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marikina_market_mobile/core/constants/app_colors.dart';
import 'package:marikina_market_mobile/core/router/route_args.dart';
import 'package:marikina_market_mobile/core/router/routes.dart';
import 'package:marikina_market_mobile/features/password_recovery/domain/entities/account_lookup.dart';
import 'package:marikina_market_mobile/features/password_recovery/presentation/bloc/password_recovery_bloc.dart';
import 'package:marikina_market_mobile/features/password_recovery/presentation/bloc/password_recovery_event.dart';
import 'package:marikina_market_mobile/features/password_recovery/presentation/bloc/password_recovery_state.dart';
import 'package:marikina_market_mobile/features/password_recovery/presentation/widgets/factor_option_btn.dart';
import 'package:marikina_market_mobile/core/shared/presentation/widgets/login_card_header.dart';

class ForgotPasswordOptionPage extends StatefulWidget {
  final ForgotPasswordOptionArgs args;
  const ForgotPasswordOptionPage({required this.args, super.key});

  @override
  State<StatefulWidget> createState() => _ForgotPasswordOptionPageState();
}

class _ForgotPasswordOptionPageState extends State<ForgotPasswordOptionPage> {
  AccountLookup? _account;

  @override
  void initState() {
    super.initState();

    _account = widget.args.account;

    if (_account == null) {
      context.read<PasswordRecoveryBloc>().add(
        FindAccount(widget.args.username),
      );
    }
  }

  void _onTap(BuildContext context, String channel, AccountLookup account) {
    if (channel != 'email' && channel != 'phone') {
      context.pop();
    } else {
      context.pushNamed(
        Routes.codeVerificationName,
        extra: CodeValidationArgs(
          username: widget.args.username,
          channel: channel,
          account: account,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
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

                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'FORGOT PASSWORD',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 20,
                          ),
                        ),
                        const Text(
                          'Please select and option to access your account.',
                          style: TextStyle(color: AppColors.primary),
                        ),

                        const SizedBox(height: 20),

                        BlocBuilder<
                          PasswordRecoveryBloc,
                          PasswordRecoveryState
                        >(
                          builder: (context, state) {
                            if (_account != null) {
                              return _buildContent(context, _account!);
                            }

                            if (state is SearchAccountLoading) {
                              return SizedBox(
                                height: 400,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.primary,
                                  ),
                                ),
                              );
                            }

                            if (state is SearchAccountFailed) {
                              return Text(state.message);
                            }

                            if (state is AccountFound) {
                              return _buildContent(
                                context,
                                state.accountLookup,
                              );
                            }

                            return SizedBox.shrink();
                          },
                        ),

                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, AccountLookup account) {
    return Column(
      children: [
        FactorOptionBtn(
          icon: Icons.email,
          title: 'Reset via Email',
          subtitle:
              'To reset your password, a code will be sent to your email.',
          onTap: () => _onTap(context, "email", account),
        ),
        const SizedBox(height: 10),
        FactorOptionBtn(
          icon: Icons.phone,
          title: 'Reset via SMS number',
          subtitle:
              'To reset your password, a code will be sent to your SMS number.',
          onTap: () => _onTap(context, "phone", account),
        ),
        const SizedBox(height: 10),
        FactorOptionBtn(
          icon: Icons.lock,
          title: 'Continue with password',
          subtitle: 'Use your password instead.',
          onTap: () => Navigator.popUntil(context, (route) => route.isFirst),
        ),
      ],
    );
  }
}
