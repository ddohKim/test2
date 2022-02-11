import 'package:flutter/material.dart';
import 'package:test2/pages/login_page/auth_page.dart';
import 'package:test2/pages/intro_page/intro_page_1.dart';
import 'package:test2/pages/intro_page/intro_page_2.dart';
import 'package:test2/pages/intro_page/intro_page_4.dart';

import 'intro_page/intro_page.dart';
import 'intro_page/intro_page_3.dart';

class StartPage extends Page {
  static const pageName = 'StartPage';

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
        settings: this,
        builder: (context) => const StartWidget()); //authwidget으로 가는 route생성
  }
}

class StartWidget extends StatefulWidget {
  const StartWidget({Key? key}) : super(key: key);

  @override
  _StartWidgetState createState() => _StartWidgetState();
}

class _StartWidgetState extends State<StartWidget>{
  PageController _pageController=PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        // physics: NeverScrollableScrollPhysics(),
        children: [
          IntroPage1(),
          IntroPage2(),
          IntroPage3(),
          IntroPage4(),
          IntroPage(_pageController),
          AuthPage(),
        ],
      ),
    );
  }

}