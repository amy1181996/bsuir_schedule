import 'dart:ui';

import 'package:flutter/material.dart';

class CircleAvatarBarrier extends StatelessWidget {
  const CircleAvatarBarrier({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(
                sigmaX: 5, sigmaY: 5), // Adjust the blur intensity
            child: Container(
              color: Colors.black.withOpacity(0.5), // Adjust the opacity
            ),
          ),
          const Center(
            child: CircleAvatar(
              radius: 50, // Adjust the avatar size
              child: Icon(
                  Icons.person_outline), // Replace with your avatar image path
            ),
          ),
        ],
      ),
    );
  }
}
