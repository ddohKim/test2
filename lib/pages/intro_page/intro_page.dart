import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class IntroPage extends StatelessWidget {
  PageController controller; //auth_screen의 pagecontroller를 가져옴
  IntroPage( this.controller,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder( //화면 사이즈가 바뀔때마다 layoutBuilder가 rebuild해주고 있음
      builder: (context, constraints) {
        Size size=MediaQuery.maybeOf(context)!.size; //현재 모바일 사이즈를 가져오는 것,  maybeOf는 사이즈를 가져오지 못할때 null을 부여함 일반적인 경우는 of사용하면 됨
        final imgSize=size.width-32;
        final sizeOfPosImg=(imgSize)*0.1; //패딩 horizontal이 16이니까 양쪽 32

        return Container(
          decoration: BoxDecoration(image: DecorationImage(
              fit: BoxFit.cover, image: AssetImage('assets/솜사탕배경1.png'))),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '솜사탕',
                    style: TextStyle(fontSize: 50, color:Colors.black, fontWeight: FontWeight.bold,fontFamily: 'NAnumAJumMaJaYu')),
                    //Theme.of(context).textTheme.headline2!.copyWith(color: Theme.of(context).colorScheme.primary),),
                 //primaryswatch를 이용해서 글자 색깔을 한번에 바꾸기 나중에 main의 theme만 바꿔주면 됨
                  Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ExtendedImage.asset(
                        'assets/솜사탕_1.png',width: 100,height: 100 ,),
                      ExtendedImage.asset(
                          'assets/솜사탕_2.png',width:100,height:100),
                      ExtendedImage.asset(
                          'assets/솜사탕_3.png',width:100, height:100),
                    ],
                  ),
                  SizedBox(height: 30),
                  Text(
                    '당신만의 연애노트 솜사탕',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Center(child: Text(' 이제부터 솜사탕이 여러분의\n행복한 연애생활을 응원할게요. ',style: TextStyle(fontSize: 15 ),)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextButton(
                        onPressed: () {
                          controller.animateToPage(5, duration: Duration(milliseconds: 3), curve: Curves.fastOutSlowIn);
                        },
                        child: Text(
                          '솜사탕 시작하기',
                          style: TextStyle(color: Colors.black,fontSize: 15)
                          //Theme.of(context).textTheme.button,
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ); },
    );
  }
}




