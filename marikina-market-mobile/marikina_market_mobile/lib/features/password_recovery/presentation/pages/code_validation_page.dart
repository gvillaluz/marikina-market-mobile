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
    final screenWidth = MediaQuery.sizeOf(context).width;
    final channelValue = widget.args.channel == 'email'
        ? widget.args.account.maskedEmail
        : widget.args.account.masketPhoneNumber;

    final defaultPinTheme = PinTheme(
      width: ((screenWidth - 120) / 6).clamp(30.0, 44.0).toDouble(),
      height: 50,
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
            padding: const EdgeInsets.all(16),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: BlocListener<PasswordRecoveryBloc, PasswordRecoveryState>(
                  listener: (context, state) {
                    if (state is OtpSent) {
                      _startCountdown(state.result.resendCooldownSeconds);
                    }

                    if (state is OtpVerified && state.result.success) {
                      context.goNamed(
                        Routes.resetPasswordName,
                        extra: ResetPasswordArgs(
                          username: widget.args.username,
                          resetToken: state.result.resetToken!,
                        ),
                      );
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 18,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const LoginCardHeader(),
                        Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Check your ${widget.args.channel}',
                                style: const TextStyle(
                                  fontSize: 22,
                                  color: AppColors.primaryBlack,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'We sent a 6-digit verification code to $channelValue.',
                                style: const TextStyle(
                                  color: AppColors.mediumGrey,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 24),
                              Center(
                                child: Pinput(
                                  controller: _pinController,
                                  length: 6,
                                  defaultPinTheme: defaultPinTheme,
                                  focusedPinTheme: focusedPinTheme,
                                  submittedPinTheme: submittedPinTheme,
                                  errorPinTheme: errorPinTheme,
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
                                    onResend: () => context
                                        .read<PasswordRecoveryBloc>()
                                        .add(
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
                                    onPressed: () => context
                                        .read<PasswordRecoveryBloc>()
                                        .add(
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
                                              horizontal: 12,
                                            ),
                                            child: Text(
                                              state.result.message,
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                color: AppColors.primaryRed,
                                              ),
                                            ),
                                          );
                                        }

                                        return const SizedBox.shrink();
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
        ),
      ),
    );
  }
}
