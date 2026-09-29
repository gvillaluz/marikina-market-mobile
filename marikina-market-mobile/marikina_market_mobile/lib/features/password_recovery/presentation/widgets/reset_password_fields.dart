import 'package:flutter/material.dart';
import 'package:marikina_market_mobile/core/constants/app_colors.dart';

class ResetPasswordFields extends StatefulWidget {
  final TextEditingController newPasswordController;
  final TextEditingController confirmNewPasswordController;

  const ResetPasswordFields({
    required this.newPasswordController,
    required this.confirmNewPasswordController,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _ResetPasswordFieldsState();
}

class _ResetPasswordFieldsState extends State<ResetPasswordFields> {
  bool isNewPasswordVisible = false;
  bool isConfirmNewPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('NEW PASSWORD'),
        const SizedBox(height: 7),
        TextField(
          controller: widget.newPasswordController,
          obscureText: !isNewPasswordVisible,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.lock_rounded),
            suffixIcon: IconButton(
              onPressed: () => setState(() {
                isNewPasswordVisible = !isNewPasswordVisible;
              }),
              icon: Icon(
                isNewPasswordVisible
                    ? Icons.visibility_off_outlined
                    : Icons.visibility,
              ),
            ),
            hintText: 'Enter your new password',
            hintStyle: TextStyle(color: AppColors.lightGrey, fontSize: 14),
          ),
        ),

        const SizedBox(height: 20),

        const Text('CONFIRM NEW PASSWORD'),
        const SizedBox(height: 7),
        TextField(
          controller: widget.confirmNewPasswordController,
          obscureText: !isConfirmNewPasswordVisible,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.lock_rounded),
            suffixIcon: IconButton(
              onPressed: () => setState(() {
                isConfirmNewPasswordVisible = !isConfirmNewPasswordVisible;
              }),
              icon: Icon(
                isConfirmNewPasswordVisible
                    ? Icons.visibility_off_outlined
                    : Icons.visibility,
              ),
            ),
            hintText: 'Confirm your new password',
            hintStyle: TextStyle(color: AppColors.lightGrey, fontSize: 14),
          ),
        ),
      ],
    );
  }
}
