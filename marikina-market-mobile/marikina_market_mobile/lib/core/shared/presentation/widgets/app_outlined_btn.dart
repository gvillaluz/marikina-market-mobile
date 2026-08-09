import 'package:flutter/material.dart';

class AppOutlinedBtn extends StatelessWidget {
  final String label;
  final IconData iconData;
  final VoidCallback onPressed;
  final Color foregroundColor;
  final Color backgroundColor;
  
  const AppOutlinedBtn({
    super.key,
    required this.label,
    required this.iconData,
    required this.onPressed,
    required this.foregroundColor,
    required this.backgroundColor
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          
          iconSize: 25,

          backgroundColor: backgroundColor.withValues(alpha: 0.50),
          foregroundColor: foregroundColor,

          side: BorderSide(
            color: foregroundColor
          ),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7)
          ),

          textStyle: TextStyle(
            fontSize: 14  
          ),
        ),
        onPressed: onPressed, 
        icon: Icon(
          iconData,
          size: 20,
        ),
        label: Text(label)
      )
    );
  }
}