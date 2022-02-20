import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel{
  String? commentKey;
  late String comment;
  late DateTime createdDate;
  late String userKey;
  DocumentReference? reference;

  CommentModel({
    required this.comment,
    required this.createdDate,
    required this.userKey,
    this.reference});

  CommentModel.fromJson(Map<String, dynamic> json,this.commentKey,this.reference) {
    comment = json['comment']??"";
    createdDate = json['createdDate'] == null
        ? DateTime.now().toUtc()
        : (json['createdDate'] as Timestamp)
        .toDate();
    userKey = json['userKey']??"";
  }


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['comment'] = comment;
    map['createdDate'] = createdDate;
    map['userKey'] = userKey;
    return map;
  }

  CommentModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) //: 이니셜라이져라고 불림 {}보다 더 빨리 실행됨
      : this.fromJson(snapshot.data()!, snapshot.id, snapshot.reference);

  CommentModel.fromQuerySnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot) //: 이니셜라이져라고 불림 {}보다 더 빨리 실행됨
      : this.fromJson(snapshot.data(), snapshot.id, snapshot.reference);


}