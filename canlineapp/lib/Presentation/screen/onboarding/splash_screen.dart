import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../Presentation/widgets/onboarding/getstarted_button.dart'; // Update the import path as needed

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ShaderMask(
              shaderCallback: (Rect bounds) {
                return const LinearGradient(
                  colors: [Color(0xFF5B50A0), Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ).createShader(bounds);
              },
              child: SvgPicture.asset(
                'lib/assets/images/logo/HeartLogo.svg',
                width: 150,
                height: 150,
                color:
                    Colors.white, // This color will be masked by the gradient
              ),
            ),
            SvgPicture.asset(
              'lib/assets/images/logo/LogoText.svg',
              width: 70,
              height: 70,
            ),
            const SizedBox(
                height: 20), // Add some space between the image and the text
            const Text(
              'With you, through every step',
              style: TextStyle(
                color: Color(0xFF5B50A0),
                fontSize: 19,
                fontWeight: FontWeight.w100,
              ),
            ),
            const SizedBox(
                height: 50), // Add some space between the text and the button
            const GetstartedButton(), // Use the GetstartedButton widget
          ],
        ),
      ),
    );
  }
}
