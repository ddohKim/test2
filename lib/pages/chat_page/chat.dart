

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:test2/data/comment_model.dart';
import 'package:test2/widgets/time_calculator.dart';

import '../../constants/common_size.dart';

const roundedCorner = Radius.circular(20);

class Chat extends StatelessWidget {
  final Size size;
  final bool isMine;
  final CommentModel chatModel;

  const Chat({Key? key, required this.size, required this.isMine, required this.chatModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isMine ? _buildMyMsg(context) : _buildOtherMsg(context);
  }

  Row _buildOtherMsg(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start, //왼쪽 끝으로 옮기고 위 기준으로 정렬한다를 (프로필 사진때문)
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ExtendedImage.network(
          'https://picsum.photos/50',
          width: 30,
          height: 30,
          fit: BoxFit.cover,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(8),
        ),
        SizedBox(width: common_small_padding),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end, //왼쪽 끝으로 옮기고 아래를 기준으로 정렬한다
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              child: Text(
                  chatModel.comment,style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.white)),
              //오른쪽 위만 뾰족하게 만들어준다
              padding: EdgeInsets.symmetric(
                  vertical: common_padding, horizontal: common_padding),
              //text에 padding을 줘서 decoration 안에 잘 자리잡을 수 있도록 설정한다
              constraints:
              BoxConstraints(minHeight: 30, maxWidth: size.width * 0.6),
              //최소 높이를 40으로 설정한다 최대 길이는 휴대폰 가로 길이의 60퍼센트로 설정한다
              decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(2),
                      topRight: roundedCorner,
                      bottomLeft: roundedCorner,
                      bottomRight: roundedCorner)),
            ),
            SizedBox(width: common_small_padding),
            //Text("11:25"),
             Text(TimeCalculator().getTimeDiff(chatModel.createdDate)),
          ],
        ),
      ],
    );
  }

  Row _buildMyMsg(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end, //오른쪽 끝으로 옮기고 아래를 기준으로 정렬한다
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(TimeCalculator().getTimeDiff(chatModel.createdDate)),
       // Text("11:25"),
        SizedBox(width: common_small_padding),
        Container(
          child:
          Text(chatModel.comment,style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.white) ,),
          //오른쪽 위만 뾰족하게 만들어준다
          padding: EdgeInsets.symmetric(
              vertical: common_padding, horizontal: common_padding),
          //text에 padding을 줘서 decoration 안에 잘 자리잡을 수 있도록 설정한다
          constraints:
          BoxConstraints(minHeight: 30, maxWidth: size.width * 0.6),
          //최소 높이를 40으로 설정한다 최대 길이는 휴대폰 가로 길이의 60퍼센트로 설정한다
          decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.only(
                  topLeft: roundedCorner,
                  topRight: Radius.circular(2),
                  bottomLeft: roundedCorner,
                  bottomRight: roundedCorner)),
        ),
      ],
    );
  }
}
