import 'dart:async';

import '../../core/widget/app_logo.dart';
import '../auth/view/page/welcome_page.dart';
import 'package:flutter/material.dart';

import '../../core/util/transiton.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    Timer(
      const Duration(seconds: 2),
      () {
        Navigator.pushAndRemoveUntil(
          context,
          FadePageRoute(builder: (_) => const WelcomePage()),
          (route) => false,
        );
      },
    );

    return const Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Hero(
              tag: "logo",
              child: AppLogo(),
            ),
          ),
        ],
      ),
    );
  }
}
