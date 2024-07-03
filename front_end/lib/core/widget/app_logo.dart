import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        FittedBox(
          child: Text(
            "COVALENCE",
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 40,
              letterSpacing: 16,
            ),
          ),
        ),
        SizedBox(height: 2.5),
        Text(
          "Making Moments Matter",
          style: TextStyle(
            fontWeight: FontWeight.w200,
            fontSize: 20,
            letterSpacing: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
