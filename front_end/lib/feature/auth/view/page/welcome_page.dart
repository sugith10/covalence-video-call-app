import '../../../../core/asset_path/app_asset.dart';
import '../../../home/view/page/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../../core/util/transiton.dart';
import '../../../../core/widget/app_logo.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Spacer(flex: 1),
            const Hero(tag: "logo", child: AppLogo()),
            const SizedBox(height: 10),
            Transform.scale(
              scale: 1.2,
              child: SvgPicture.asset(AppAsset.onboarding),
            ),
            ShadButton(
              height: 50,
              width: double.infinity,
              text: const Text('LOGIN'),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const HomePage(),
                      barrierDismissible: true),
                  (route) => false,
                );
              },
            ),
            const SizedBox(height: 20),
            const FittedBox(
                child:
                    Text('Lorem Ipsum is simply dummy text of the printing.')),
            const Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}
