import 'package:flutter/material.dart';

class ProfileWidget extends StatelessWidget {
  final String name;
  final int age;
  final String imageUrl;
  final String info;
  final String email;

  const ProfileWidget({
    super.key,
    required this.name,
    required this.age,
    required this.imageUrl,
    required this.info,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          const SizedBox(height: 20),
          CircleAvatar(
            radius: 70,
            backgroundImage: AssetImage(imageUrl),
          ),
          const SizedBox(height: 20),
          Text(
            name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            email,
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '$age years old',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Text(
              info,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
