import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test2/states/page_notifier.dart';
import 'package:test2/widgets/time_calculator.dart';
import '../../data/chatroom_model.dart';
import '../../repository/chat_service.dart';
import 'chatroom_page.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({Key? key}) : super(key: key);

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  @override
  Widget build(BuildContext context) {
    String? userKey = context
        .read<PageNotifier>()
        .user
        ?.uid;
    if(userKey!=null)
   { return FutureBuilder<List<ChatroomModel>>(
      //ChatroomModel list를 받아올 수 있는 futuerbuilder 생성
        future: ChatService().getMyChatList(userKey),
        //userKey를 전달해줘서 getmychatList를 불러옴, 이걸 아래 snapshot이란 이름으로 사용한다
        builder: (context, snapshot) {
          Size _size = MediaQuery
              .of(context)
              .size;
          return Scaffold(
            backgroundColor: Colors.white,
            body: ListView.separated(
                itemBuilder: (context, index) {
                  ChatroomModel chatroomModel =
                  snapshot.data![index]; //snapshot에서 charoomModel 하나씩 가져온다
                  bool my = chatroomModel.myKey ==
                      userKey; //내 채팅이 마지막인지 아닌지 확인
                  return ListTile(
                      onTap: () {
                        //context.beamToNamed('/${chatroomModel.chatroomKey}');
                        Navigator.of(context).push(
                            MaterialPageRoute(builder:
                                (BuildContext context) {
                              return ChatroomScreen(chatroomModel.chatroomKey);
                            }));
                      }, //클릭 시 해당 chatscreen으로 갈 수 있도록
                      leading: ExtendedImage.network(
                        chatroomModel.yourImage,
                        shape: BoxShape.rectangle,
                        scale: 0.1,
                        borderRadius: BorderRadius.circular(6),
                        fit: BoxFit.cover,
                        height: _size.width / 8,
                        width: _size.width / 8,
                      ),
                    trailing: Text(TimeCalculator().getTimeDiff(chatroomModel.lastMsgTime)),
                   //  trailing: ExtendedImage.network(
                   //    chatroomModel.myImage,
                   //    shape: BoxShape.rectangle,
                   //    fit: BoxFit.cover,
                   //    borderRadius: BorderRadius.circular(4),
                   //    height: _size.width / 8,
                   //    width: _size.width / 8,
                   //  ),
                      title: RichText(
                          maxLines: 2,
                          //최대 줄은 2줄로 설정
                          overflow: TextOverflow.ellipsis,
                          //overflow가 나면 ...으로 보여준다
                          text: TextSpan(
                              style: Theme
                                  .of(context)
                                  .textTheme //글씨체를 다르게 하려면 richtext를 써서 해주면 된다
                                  .subtitle1,
                              text: chatroomModel.yourNickName,
                          children: [
                          TextSpan(text: " "),
                         //TextSpan(
                         //    style: Theme
                         //        .of(context)
                         //        .textTheme
                         //        .subtitle2,
                         //    text: chatroomModel.yourNickName)
                          ])),
                  //  title: Row(
                  //    children: [
                  //      Expanded( //주소가 다 보이도록 하고 싶음
                  //        child: Text(
                  //            iamBuyer
                  //                ? chatroomModel
                  //                .sellerKey //내가 buyer라면 sellerkey를 보여줘야 한다(상대방 이름이 보이도록 나중에 설정해주면 된다)
                  //                : chatroomModel.buyerKey, style: Theme
                  //            .of(context)
                  //            .textTheme //글씨체를 다르게 하려면 richtext를 써서 해주면 된다
                  //            .subtitle1,      maxLines: 1, //최대 줄은 1 설정
                  //             overflow: TextOverflow.ellipsis, //overflow가 나면 ...으로 보여준다
                  //        ),
                  //      ),Text(
                  //          chatroomModel.itemAddress, style: Theme
                  //          .of(context)
                  //          .textTheme
                  //          .subtitle2,    maxLines: 1, //최대 줄은 1줄로 설정
                  //        //     overflow: TextOverflow.ellipsis, //overflow가 나면 ...으로 보여준다
                  //      )
                  //    ],
                  //  ),
                  subtitle: Text(

                  chatroomModel.lastMsg,
                  maxLines: 1, //최대 줄은 2줄로 설정
                  overflow: TextOverflow.ellipsis, //overflow가 나면 ...으로 보여준다
                  style: Theme
                      .of(context)
                      .textTheme
                      .bodyText1!.copyWith(color: Colors.grey),
                  )
                  ,
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider(
                    thickness: 1,
                    height: 1,
                    color: Colors.grey[300],
                  );
                },
                itemCount: snapshot.hasData
                    ? snapshot.data!.length
                    : 0), //snapshot 데이터가 존재한다면 그 길이를 itemCount로 준다
          );
        });
  }
  else{
   return Container(color: Colors.blue,);
  }
}}
