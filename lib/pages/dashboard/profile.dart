import 'package:flutter/material.dart';
import '../../shared/widgets/stars_animation.dart';

class DashboardProfilePage extends StatelessWidget {
  const DashboardProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const StarsAnimation(starCount: 50),
        Center(
          child: Text('Profile Page', style: TextStyle(fontSize: 24)),
        ),
      ],
    );
  }
} 