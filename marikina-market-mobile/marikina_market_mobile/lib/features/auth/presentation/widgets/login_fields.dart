import 'package:flutter/material.dart';
import 'package:marikina_market_mobile/core/constants/app_colors.dart';

class LoginFields extends StatefulWidget {
  final TextEditingController usernameController;
  final TextEditingController passwordController;

  const LoginFields({
    super.key,
    required this.usernameController,
    required this.passwordController
  });

  @override
  State<StatefulWidget> createState() => _LoginFieldsState();
}

class _LoginFieldsState extends State<LoginFields> {
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'USERNAME',
          ),
          const SizedBox(height: 7,),
          TextField(
            controller: widget.usernameController,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.person_rounded),

              hintText: 'Enter your username',
              hintStyle: TextStyle(
                color: AppColors.lightGrey,
                fontSize: 14
              )
            ),
          ),

          const SizedBox(height: 20,),

          const Text(
            'PASSWORD',
          ),
          const SizedBox(height: 7,),
          TextField(
            controller: widget.passwordController,
            obscureText: !isPasswordVisible,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.lock_rounded),
              suffixIcon: IconButton(
                onPressed: () => setState(() {
                  isPasswordVisible = !isPasswordVisible;
                }), 
                icon: Icon(isPasswordVisible ? Icons.visibility_off_outlined : Icons.visibility)
              ),
              hintText: 'Enter your password',
              hintStyle: TextStyle(
                color: AppColors.lightGrey,
                fontSize: 14
              )
            ),
          )
        ],
      ),
    );
  }
}