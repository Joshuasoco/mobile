import 'package:flutter/material.dart';

class SocialLoginRow extends StatelessWidget {
  const SocialLoginRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _socialIcon('assets/images/apple.png'),
        const SizedBox(width: 20),
        _socialIcon('assets/images/google.png'),
        const SizedBox(width: 20),
        _socialIcon('assets/images/facebook.png'),
      ],
    );
  }

  Widget _socialIcon(String path) {
    return CircleAvatar(
      radius: 20,
      backgroundImage: AssetImage(path),
      backgroundColor: Colors.white,
    );
  }
}
