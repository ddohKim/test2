import 'package:flutter/material.dart';
import 'package:test2/data/comment_model.dart';
import 'package:test2/data/item_model.dart';
import 'package:test2/repository/comment_service.dart';
import 'package:test2/repository/item_service.dart';

class CommentNotifier extends ChangeNotifier{
  late ItemModel _itemModel;
   List<CommentModel> _commentList=[];
  late String _itemKey;

  CommentNotifier(this._itemKey){
    CommentService().connectComment(_itemKey).listen((itemModel) {
      this._itemModel=itemModel;
      if(this._commentList.isEmpty)
        {
          CommentService().getCommentList(_itemKey).then((commentList) {
            _commentList.addAll(commentList);
            notifyListeners();
          });
        }
      else{
        if(_commentList[0].reference==null)
          _commentList.removeAt(0);
        CommentService().getLatestCommentList(_itemKey, _commentList[0].reference!).then((latestComments){
          _commentList.insertAll(0, latestComments);
          notifyListeners();
        });
      }
    });

  }

  void addNewComment(CommentModel commentModel){ //메세지가 바로바로 뜨도록
    _commentList.insert(0, commentModel);
    notifyListeners();
     CommentService().createdNewComment(
        _itemKey, commentModel);
  }


  ItemModel get itemModel => _itemModel;
  String get itemKey => _itemKey;
  List<CommentModel> get commentList => _commentList;
}