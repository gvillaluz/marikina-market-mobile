import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marikina_market_mobile/core/constants/app_colors.dart';
import 'package:marikina_market_mobile/core/router/route_args.dart';
import 'package:marikina_market_mobile/core/router/routes.dart';
import 'package:marikina_market_mobile/features/auth/presentation/widgets/login_btn.dart';
import 'package:marikina_market_mobile/core/shared/presentation/widgets/login_card_header.dart';
import 'package:marikina_market_mobile/features/password_recovery/presentation/bloc/password_recovery_bloc.dart';
import 'package:marikina_market_mobile/features/password_recovery/presentation/bloc/password_recovery_event.dart';
import 'package:marikina_market_mobile/features/password_recovery/presentation/bloc/password_recovery_state.dart';

class FindAccountPage extends StatefulWidget {
  const FindAccountPage({super.key});

  @override
  State<StatefulWidget> createState() => _FindAccountPageState();
}

class _FindAccountPageState extends State<FindAccountPage> {
  final usernameController = TextEditingController();

  void _searchAccount() {
    if (usernameController.text.isNotEmpty) {
      context.read<PasswordRecoveryBloc>().add(
        FindAccount(usernameController.text.trim()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child:
                    BlocListener<PasswordRecoveryBloc, PasswordRecoveryState>(
                      listener: (context, state) {
                        if (state is AccountFound) {
                          context.pushNamed(
                            Routes.forgotPasswordOptionName,
                            extra: ForgotPasswordOptionArgs(
                              username: usernameController.text.trim(),
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
                                  const Text(
                                    'Find your account',
                                    style: TextStyle(
                                      color: AppColors.primaryBlack,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'Enter your username to continue.',
                                    style: TextStyle(
                                      color: AppColors.mediumGrey,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  const Text('USERNAME'),
                                  const SizedBox(height: 7),
                                  TextField(
                                    controller: usernameController,
                                    textInputAction: TextInputAction.done,
                                    onSubmitted: (_) => _searchAccount(),
                                    onTapOutside: (_) =>
                                        FocusScope.of(context).unfocus(),
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(
                                        Icons.person_rounded,
                                      ),
                                      hintText: 'Enter your username',
                                      hintStyle: const TextStyle(
                                        color: AppColors.lightGrey,
                                        fontSize: 14,
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  BlocBuilder<
                                    PasswordRecoveryBloc,
                                    PasswordRecoveryState
                                  >(
                                    builder: (context, state) {
                                      return Column(
                                        children: [
                                          AuthBtn(
                                            isLoading:
                                                state is SearchAccountLoading,
                                            onPressed: _searchAccount,
                                            label: 'Continue',
                                          ),
                                          if (state is SearchAccountFailed) ...[
                                            const SizedBox(height: 12),
                                            Text(
                                              state.message,
                                              style: const TextStyle(
                                                color: AppColors.primaryRed,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ],
                                      );
                                    },
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
