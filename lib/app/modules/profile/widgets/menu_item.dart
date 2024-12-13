import 'package:flutter/material.dart';

class ProfileMenuItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool endIcon;
  final Color? textColor;
  final Color primaryColor;
  final Color secondaryColor;

  const ProfileMenuItem(
      {super.key,
      required this.icon,
      required this.title,
      required this.onTap,
      required this.primaryColor,
      required this.secondaryColor,
      this.endIcon = true,
      this.textColor})
      ;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Icon(
          icon,
          color: secondaryColor,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: textColor,
        ),
      ),
    );
  }
}
