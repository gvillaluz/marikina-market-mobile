import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marikina_market_mobile/core/constants/app_colors.dart';
import 'package:marikina_market_mobile/core/router/routes.dart';
import 'package:marikina_market_mobile/core/shared/presentation/widgets/app_outlined_btn.dart';
import 'package:marikina_market_mobile/core/shared/presentation/widgets/app_primary_btn.dart';
import 'package:marikina_market_mobile/core/utils/date_formatter_util.dart';
import 'package:marikina_market_mobile/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:marikina_market_mobile/features/auth/presentation/bloc/auth_event.dart';
import 'package:marikina_market_mobile/features/auth/presentation/bloc/auth_state.dart';
import 'package:marikina_market_mobile/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:marikina_market_mobile/features/profile/presentation/bloc/profile_event.dart';
import 'package:marikina_market_mobile/features/profile/presentation/bloc/profile_state.dart';
import 'package:marikina_market_mobile/features/profile/presentation/widgets/profile_detail_row.dart';
import 'package:marikina_market_mobile/features/profile/presentation/widgets/profile_header_card.dart';
import 'package:marikina_market_mobile/features/profile/presentation/widgets/profile_page_skeleton.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfilePictureChanged) {
          context.read<AuthBloc>().add(UserUpdated(state.user));

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Profile photo changed successfully.'),
              backgroundColor: AppColors.primary,
            ),
          );
        }

        if (state is ChangeProfilePhotoFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Failed to change photo.'),
              backgroundColor: AppColors.primaryRed,
            ),
          );
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthLoading || state is AuthInitial) {
            return const ProfilePageSkeleton();
          }

          if (state is Authenticated) {
            return SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProfileHeaderCard(
                        user: state.user,
                        onChangePhoto: (file) => context
                            .read<ProfileBloc>()
                            .add(ChangeProfilePhoto(file: file)),
                        onRemovePhoto: () => context.read<ProfileBloc>().add(
                          RemoveProfilePhoto(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Account Information',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'Your account details and information',
                        style: TextStyle(fontSize: 15),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.lightGrey.withValues(alpha: 0.30),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            ProfileDetailRow(
                              label: 'LAST NAME',
                              value: state.user.lastName,
                            ),
                            Divider(
                              height: 1,
                              color: AppColors.lightGrey.withValues(
                                alpha: 0.30,
                              ),
                            ),
                            ProfileDetailRow(
                              label: 'FIRST NAME',
                              value: state.user.firstName,
                            ),
                            Divider(
                              height: 1,
                              color: AppColors.lightGrey.withValues(
                                alpha: 0.30,
                              ),
                            ),
                            ProfileDetailRow(
                              label: 'MIDDLE NAME',
                              value: state.user.middleName,
                            ),
                            Divider(
                              height: 1,
                              color: AppColors.lightGrey.withValues(
                                alpha: 0.30,
                              ),
                            ),
                            ProfileDetailRow(
                              label: 'ACCOUNT STATUS',
                              value: null,
                              status: state.user.status,
                            ),
                            Divider(
                              height: 1,
                              color: AppColors.lightGrey.withValues(
                                alpha: 0.30,
                              ),
                            ),
                            ProfileDetailRow(
                              label: 'CREATED AT',
                              value: DateTimeFormatter.getDate(
                                state.user.createdAt,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      AppPrimaryButton(
                        label: 'Edit Account Information',
                        iconData: Icons.edit_square,
                        onPressed: () {
                          context.pushNamed(
                            Routes.editProfileName,
                            extra: state.user,
                          );
                        },
                      ),

                      const SizedBox(height: 20),

                      AppOutlinedBtn(
                        label: 'Change Password',
                        iconData: Icons.lock_outline,
                        onPressed: () {
                          context.pushNamed(
                            Routes.changePasswordName,
                            extra: state.user,
                          );
                        },
                        foregroundColor: AppColors.primary,
                        backgroundColor: AppColors.tertiary,
                      ),

                      const SizedBox(height: 30),
                      const Divider(),
                      const SizedBox(height: 30),

                      AppOutlinedBtn(
                        label: 'Logout',
                        iconData: Icons.logout,
                        onPressed: () {
                          context.read<AuthBloc>().add(LogoutUser(false));
                        },
                        foregroundColor: AppColors.primaryRed,
                        backgroundColor: AppColors.secondaryRed.withValues(
                          alpha: 0.50,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
