import 'package:flutter/material.dart';

class BackBtn extends StatelessWidget {
  const BackBtn({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5)
          ),
          padding: const EdgeInsets.all(15),
          backgroundColor: Color(0xFFEBEEF1),
          foregroundColor: Color(0xFF8F8F8F)
        ),
        onPressed: () => Navigator.pop(context), 
        child: const Text('Back')
      ),
    );
  }
}