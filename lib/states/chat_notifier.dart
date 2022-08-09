import 'package:flutter/material.dart';
import 'package:test2/data/chatroom_model.dart';
import 'package:test2/data/comment_model.dart';
import 'package:test2/repository/chat_service.dart';

class ChatNotifier extends ChangeNotifier {
  ChatroomModel? _chatroomModel;
  List<CommentModel> _chatList = [];
  final String _chatroomKey;

  ChatNotifier(this._chatroomKey) {
    ChatService().connectChatroom(_chatroomKey).listen((chatroomModel) {
      _chatroomModel = chatroomModel;
    });
    //connectChatroom으로 firestore 와 연결시켜놓고 ㅣisten을 통해 구독? 하는데 chatroomModel이 전달된다
    if (this._chatList.isEmpty) {
      //10개의 채팅을 가져온다
      ChatService().getChatList(_chatroomKey).then((chatList) {
        _chatList.addAll(chatList);
        notifyListeners();
      });
    } else {
      if (_chatList[0].reference == null) {
        _chatList.removeAt(0);
        ChatService()
            .getLatestChatList(_chatroomKey, _chatList[0].reference!)
            .then((latestChats) {
          _chatList.insertAll(0, latestChats);
          notifyListeners();
        });
      }
    }}
    void addNewChat(CommentModel chatModel){ //채팅 입력이 바로바로 보이도록 하기 위해서 먼저 _chatList에 입력하고 따로 firestore에 새로운 chat을 만듬
      _chatList.insert(0, chatModel); //미리 방금 입력한 채팅을 직접 입력해줌
      notifyListeners();
      ChatService().createNewChat(chatModel, _chatroomKey); //여기서 ChatService의 createNewChat으로 새로운 채팅을 만들어준다
    }




  List<CommentModel> get chatList => _chatList;

  ChatroomModel? get chatroomModel => _chatroomModel;

  String get chatroomKey => _chatroomKey;
}
