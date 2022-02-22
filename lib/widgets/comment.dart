import 'package:flutter/material.dart';
import 'package:test2/data/comment_model.dart';
import 'package:test2/widgets/time_calculator.dart';

const roundedCorner = Radius.circular(20);

class Comment extends StatelessWidget {
  final Size size;
  final bool isMine;
  final CommentModel commentModel;
  const Comment({Key? key,required this.size,required this.isMine,required this.commentModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isMine?_buildMyComment():_buildOtherComment();
  }
  Row _buildOtherComment() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          child: Text(commentModel.comment) ,
          padding: EdgeInsets.symmetric(vertical: 12,horizontal: 16),
          constraints: BoxConstraints(minHeight: 40,maxWidth: size.width*0.6),
          decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.only(
                  topRight: roundedCorner,
                  topLeft: Radius.circular(2),
                  bottomRight: roundedCorner,
                  bottomLeft: roundedCorner)),),
           SizedBox(width: 6,),
        Text(TimeCalculator().getTimeDiff(commentModel.createdDate)),
      ],
    );
  }


  Row _buildMyComment() {
    return Row(
    crossAxisAlignment: CrossAxisAlignment.end,
    mainAxisAlignment: MainAxisAlignment.end,
    children: [Text(TimeCalculator().getTimeDiff(commentModel.createdDate)),
      SizedBox(width: 6,),
      Container(
        child: Text(commentModel.comment),
        padding: EdgeInsets.symmetric(vertical: 12,horizontal: 16),
        constraints: BoxConstraints(minHeight: 40,maxWidth: size.width*0.6),
        decoration: BoxDecoration(
            color: Colors.cyan,
            borderRadius: BorderRadius.only(
                topLeft: roundedCorner,
                topRight: Radius.circular(2),
                bottomRight: roundedCorner,
                bottomLeft: roundedCorner)),
      ),
    ],
  );
  }
}
