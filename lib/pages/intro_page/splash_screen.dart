import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //column위젯은 위아래 scroll은 못함 ListView를 이용해야함
            ExtendedImage.asset('assets/솜사탕_1.png'),
            const CircularProgressIndicator(color: Colors.cyanAccent,)
          ],
        ),
      ),
    );
  }
}