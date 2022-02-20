import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test2/constants/data_keys.dart';
import 'package:test2/data/comment_model.dart';
import 'package:test2/data/item_model.dart';

class CommentService {
  static final CommentService _commentService =
      CommentService._internal(); //하나의 instance만 생성해주기 위해서는 이렇게 해줘야한다
  factory CommentService() => _commentService;

  CommentService._internal();

  Future createdNewComment(String itemKey, CommentModel commentModel) async {
    DocumentReference<Map<String, dynamic>> documentReference =
        FirebaseFirestore.instance
            .collection(COL_ITEMS)
            .doc(itemKey)
            .collection(COL_COMMENTS)
            .doc();

    DocumentReference<Map<String, dynamic>> commentRoomDocRef =
        FirebaseFirestore.instance.collection(COL_ITEMS).doc(itemKey);

    await documentReference.set(commentModel.toJson());

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(documentReference, commentModel.toJson());
      transaction
          .update(commentRoomDocRef, {'lastComment': commentModel.comment});
    });
  }

  Stream<ItemModel> connectComment(String itemKey) {
    return FirebaseFirestore.instance
        .collection(COL_ITEMS)
        .doc(itemKey)
        .snapshots()
        .transform(snapshotToComment);
  }

  var snapshotToComment = StreamTransformer<
      DocumentSnapshot<Map<String, dynamic>>,
      ItemModel>.fromHandlers(handleData: (snapshot, sink) {
    ItemModel itemModel = ItemModel.fromSnapshot(snapshot);
    sink.add(itemModel);
  });

  Future<List<CommentModel>> getCommentList(String itemKey) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection(COL_ITEMS)
        .doc(itemKey)
        .collection(COL_COMMENTS)
        .orderBy('createdDate', descending: true)
        .limit(10)
        .get();
    List<CommentModel> commentList = [];
    snapshot.docs.forEach((docSnapshot) {
      CommentModel commentModel = CommentModel.fromQuerySnapshot(docSnapshot);
      commentList.add(commentModel);
    });
    return commentList;
  }

  Future<List<CommentModel>> getLatestCommentList(
      String itemKey, DocumentReference currentLastestComment) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection(COL_ITEMS)
        .doc(itemKey)
        .collection(COL_COMMENTS)
        .orderBy('createdDate', descending: true)
        .endBeforeDocument(await currentLastestComment.get())
        .get();
    List<CommentModel> commentList = [];
    snapshot.docs.forEach((docSnapshot) {
      CommentModel commentModel = CommentModel.fromQuerySnapshot(docSnapshot);
      commentList.add(commentModel);
    });
    return commentList;
  }

  Future<List<CommentModel>> getOlderCommentList(
      String itemKey, DocumentReference currentOldestComment) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection(COL_ITEMS)
        .doc(itemKey)
        .collection(COL_COMMENTS)
        .orderBy('createdDate', descending: true)
        .startAfterDocument(await currentOldestComment.get())
        .limit(10)
        .get();
    List<CommentModel> commentList = [];
    snapshot.docs.forEach((docSnapshot) {
      CommentModel commentModel = CommentModel.fromQuerySnapshot(docSnapshot);
      commentList.add(commentModel);
    });
    return commentList;
  }
}
