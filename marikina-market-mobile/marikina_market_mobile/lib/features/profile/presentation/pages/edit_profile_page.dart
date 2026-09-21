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
import 'package:marikina_market_mobile/features/profile/presentation/widgets/edit_appbar.dart';
import 'package:marikina_market_mobile/features/profile/presentation/widgets/edit_profile_card.dart';

class EditProfilePage extends StatefulWidget {
  final User user;

  const EditProfilePage({super.key, required this.user});

  @override
  State<StatefulWidget> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _lastNameController.text = widget.user.lastName;
    _firstNameController.text = widget.user.firstName;
    _middleNameController.text = widget.user.middleName ?? '';
  }

  @override
  void dispose() {
    _lastNameController.dispose();
    _firstNameController.dispose();
    _middleNameController.dispose();
    super.dispose();
  }

  void onSaveChanges() {
    context.read<ProfileBloc>().add(
      EditProfileSubmitted(
        userId: widget.user.userId,
        lastName: _lastNameController.text,
        firstName: _firstNameController.text,
        middleName: _middleNameController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EditAppbar(
        title: 'Edit Account Information',
        onPressed: () => context.pop(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: BlocListener<ProfileBloc, ProfileState>(
            listener: (context, state) {
              if (state is EditProfileError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: AppColors.primaryRed,
                  ),
                );
              }

              if (state is ProfileUpdated) {
                context.read<AuthBloc>().add(UserUpdated(state.user));

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Account information updated successfully!'),
                    backgroundColor: AppColors.primary,
                    duration: Duration(seconds: 2),
                  ),
                );

                context.pop();
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Update your account information',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  EditProfileCard(
                    lastNameController: _lastNameController,
                    firstNameController: _firstNameController,
                    middleNameController: _middleNameController,
                    onSaveChanges: onSaveChanges,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
