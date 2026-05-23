import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        CircleAvatar(
          radius: 45,
          child: Icon(Icons.person_outline_rounded, size: 42),
        ),
        SizedBox(height: 14),
        Text(
          'Ramesh Kumar',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 6),
        Text(
          '⭐ 4.8 • Delhi',
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}