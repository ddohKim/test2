import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class IntroPage3 extends StatelessWidget {
  const IntroPage3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        Size size=MediaQuery.maybeOf(context)!.size; //현재 모바일 사이즈를 가져오는 것,  maybeOf는 사이즈를 가져오지 못할때 null을 부여함 일반적인 경우는 of사용하면 됨
        final imgSize=size.width;
        final sizeOfPosImg=(imgSize); //패딩 horizontal이 16이니까 양쪽 32
        return Container(color: Colors.cyanAccent,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 40,),
                  Text('사',style: TextStyle(fontSize: 40),),
                  Text('사랑의 설레이는 일기장',style: TextStyle(fontSize: 35),),
                  SizedBox(width: imgSize,height: imgSize,
                    child: Positioned(//left, right 값을 줬으면 width값은 주면 안됨(이미 결정되있기 때문)
                        width: sizeOfPosImg,
                        left: imgSize*0.3,
                        height: sizeOfPosImg,
                        top: imgSize*0.5,
                        child: ExtendedImage.asset(
                            'assets/솜사탕_1.png')),
                  ),
                  SizedBox(height: 40,),
                  Text('우리의 사랑이야기를 추억하세요.\n원한다면 이야기 공유를 통해\n같이 추억에 빠져 보세요!',style: TextStyle(fontSize: 30),),
                  Expanded(
                    child: Container(alignment: Alignment.bottomCenter,
                      child: Row(mainAxisAlignment: MainAxisAlignment.center,
                        children: [Icon(Icons.circle_outlined,size: 10,),Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Icon(Icons.circle,size: 10,),
                        ),Icon(Icons.circle_outlined,size: 10,)],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );},
    );
  }
}
