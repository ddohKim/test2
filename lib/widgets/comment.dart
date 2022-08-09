import 'package:flutter/material.dart';
import 'package:test2/data/comment_model.dart';
import 'package:test2/repository/user_service.dart';
import 'package:test2/widgets/time_calculator.dart';

const roundedCorner = Radius.circular(20);

class Comment extends StatefulWidget {
  final Size size;
  final bool isMine;
  final CommentModel commentModel;
  final String nickName;
  final String saTangList;
  final bool isSaTang;

  Comment(
      {Key? key,
      required this.size,
      required this.isMine,
      required this.commentModel,
      required this.nickName,
        required this.isSaTang,
      required this.saTangList})
      : super(key: key);

  @override
  State<Comment> createState() => _CommentState();
}

class _CommentState extends State<Comment> {
bool _getSomSaTang=false;
  @override
  Widget build(BuildContext context) {
    _getSomSaTang=widget.isSaTang;
    return widget.isMine ? _buildMyComment() : _buildOtherComment();
  }

  Widget _buildOtherComment() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.nickName != null
            ? Text(
                widget.nickName,
                textAlign: TextAlign.start,
              )
            : Text(""),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              child: Text(widget.commentModel.comment),
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              constraints:
                  BoxConstraints(minHeight: 40, maxWidth: widget.size.width * 0.6),
              decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.only(
                      topRight: roundedCorner,
                      topLeft: Radius.circular(2),
                      bottomRight: roundedCorner,
                      bottomLeft: roundedCorner)),
            ),
            SizedBox(
              width: 6,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                    width: 50,
                    height: 50,
                    child: IconButton(
                      alignment: Alignment.centerLeft,
                      onPressed: () async{
                     if(mounted){
                       _getSomSaTang=!_getSomSaTang;
                        await UserService().updateSaTang(widget.commentModel.userKey, _getSomSaTang,widget.saTangList);
                        setState(() {

                        });
                      }},
                      icon: _getSomSaTang?Icon(Icons.emoji_emotions):Icon(Icons.emoji_emotions_outlined),
                      padding: EdgeInsets.only(left: 0, right: 0),
                    )),
                Text(TimeCalculator().getTimeDiff(widget.commentModel.createdDate)),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Row _buildMyComment() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(TimeCalculator().getTimeDiff(widget.commentModel.createdDate)),
        SizedBox(
          width: 6,
        ),
        Container(
          child: Text(widget.commentModel.comment),
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          constraints:
              BoxConstraints(minHeight: 40, maxWidth: widget.size.width * 0.6),
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
