import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marikina_market_mobile/core/constants/app_colors.dart';
import 'package:marikina_market_mobile/core/router/route_args.dart';
import 'package:marikina_market_mobile/core/router/routes.dart';
import 'package:marikina_market_mobile/core/shared/presentation/widgets/login_card_header.dart';
import 'package:marikina_market_mobile/features/auth/presentation/widgets/login_btn.dart';
import 'package:marikina_market_mobile/features/password_recovery/presentation/bloc/password_recovery_bloc.dart';
import 'package:marikina_market_mobile/features/password_recovery/presentation/bloc/password_recovery_event.dart';
import 'package:marikina_market_mobile/features/password_recovery/presentation/bloc/password_recovery_state.dart';
import 'package:marikina_market_mobile/features/password_recovery/presentation/widgets/resend_text.dart';
import 'package:pinput/pinput.dart';

class CodeValidationPage extends StatefulWidget {
  final CodeValidationArgs args;

  const CodeValidationPage({super.key, required this.args});

  @override
  State<StatefulWidget> createState() => _CodeValidationPageState();
}

class _CodeValidationPageState extends State<CodeValidationPage> {
  final TextEditingController _pinController = TextEditingController();
  Timer? _timer;

  int _remainingSeconds = 0;

  @override
  void initState() {
    context.read<PasswordRecoveryBloc>().add(
      SendOtp(username: widget.args.username, channel: widget.args.channel),
    );
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pinController.dispose();
    super.dispose();
  }

  void _startCountdown(int seconds) {
    _timer?.cancel();

    setState(() {
      _remainingSeconds = seconds;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remainingSeconds <= 0) {
        _timer?.cancel();
        return;
      }

      setState(() {
        _remainingSeconds--;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final channelValue = widget.args.channel == 'email'
        ? widget.args.account.maskedEmail
        : widget.args.account.masketPhoneNumber;

    final defaultPinTheme = PinTheme(
      width: 44,
      height: 52,
      textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: AppColors.primary, width: 1.5),
    );

    final submittedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: AppColors.primary),
      color: AppColors.primary.withValues(
        alpha: 0.05,
      ), // subtle fill once filled
    );

    final errorPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Colors.red),
    );

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: BlocListener<PasswordRecoveryBloc, PasswordRecoveryState>(
              listener: (context, state) {
                if (state is OtpSent) {
                  _startCountdown(state.result.resendCooldownSeconds);
                }

                if (state is OtpVerified) {
                  if (state.result.success) {
                    context.goNamed(
                      Routes.resetPasswordName,
                      extra: ResetPasswordArgs(
                        username: widget.args.username,
                        resetToken: state.result.resetToken!,
                      ),
                    );
                  }
                }
              },
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
                          Text(
                            'CHECK YOUR ${widget.args.channel.toUpperCase()}',
                            style: TextStyle(
                              fontSize: 20,
                              color: AppColors.primary,
                            ),
                          ),
                          Text(
                            'We\'ve sent a 6-digit verification code to $channelValue',
                          ),

                          const SizedBox(height: 20),

                          Center(
                            child: Pinput(
                              controller: _pinController,
                              length: 6,
                              defaultPinTheme: defaultPinTheme,
                              focusedPinTheme: focusedPinTheme,
                              submittedPinTheme: submittedPinTheme,
                              errorPinTheme: errorPinTheme,
                              // no onCompleted
                            ),
                          ),

                          const SizedBox(height: 20),

                          BlocBuilder<
                            PasswordRecoveryBloc,
                            PasswordRecoveryState
                          >(
                            builder: (context, state) {
                              return ResendText(
                                cooldownSeconds: _remainingSeconds,
                                isSending: state is SendOtpLoading,
                                onResend: () =>
                                    context.read<PasswordRecoveryBloc>().add(
                                      SendOtp(
                                        username: widget.args.username,
                                        channel: widget.args.channel,
                                      ),
                                    ),
                              );
                            },
                          ),

                          const SizedBox(height: 20),

                          BlocBuilder<
                            PasswordRecoveryBloc,
                            PasswordRecoveryState
                          >(
                            builder: (context, state) {
                              return AuthBtn(
                                onPressed: () =>
                                    context.read<PasswordRecoveryBloc>().add(
                                      VerifyCode(
                                        widget.args.username,
                                        _pinController.text.trim(),
                                      ),
                                    ),
                                isLoading: state is VerifyOtpLoading,
                                label: 'Verify',
                              );
                            },
                          ),

                          const SizedBox(height: 5),

                          Center(
                            child: TextButton(
                              onPressed: () => Navigator.popUntil(
                                context,
                                (route) => route.isFirst,
                              ),
                              child: const Text('Back to login'),
                            ),
                          ),

                          Center(
                            child:
                                BlocBuilder<
                                  PasswordRecoveryBloc,
                                  PasswordRecoveryState
                                >(
                                  builder: (context, state) {
                                    if (state is OtpVerified &&
                                        !state.result.success) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                        ),
                                        child: Text(
                                          state.result.message,
                                          style: TextStyle(
                                            color: AppColors.primaryRed,
                                          ),
                                        ),
                                      );
                                    }

                                    return SizedBox.shrink();
                                  },
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
