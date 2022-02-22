import 'package:cloud_firestore/cloud_firestore.dart';

class ItemModel {
  late String itemKey;
  late String userKey;
  late List<String> imageDownloadUrls;
  late String title;
  late String category;
  late bool secret;
  late String detail;
  late DateTime createdDate;
  late DocumentReference? reference;
  late String lastComment;
  late String nickName;
  late int heartNumber;
  late int chatNumber;

  ItemModel({
   required this.itemKey,
   required this.userKey,
   required this.imageDownloadUrls,
   required this.title,
   required this.category,
   required this.secret,
   required this.detail,
   required this.createdDate,
    required this.lastComment,
    required this.nickName,
    required this.heartNumber,
    required this.chatNumber,
    this.reference,});

  ItemModel.fromJson(Map<String, dynamic> json,this.itemKey,this.reference) {
    chatNumber=json['chatNumber']??0;
    heartNumber=json['heartNumber']??0;
     nickName= json['nickName']??"";
    userKey = json['userKey']??"";
    imageDownloadUrls = json['imageDownloadUrls'] != null
        ? json['imageDownloadUrls'].cast<String>()
        : [];
    title = json['title']??"";
    category = json['category']??"";
    secret = json['secret']??false;
    detail = json['detail']??"";
    lastComment = json['lastComment']??"";
    createdDate = json['createdDate'] == null
        ? DateTime.now().toUtc()
        : (json['createdDate'] as Timestamp)
        .toDate();
  }

  ItemModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) //: 이니셜라이져라고 불림 {}보다 더 빨리 실행됨
      : this.fromJson(snapshot.data()!, snapshot.id, snapshot.reference);

  ItemModel.fromQuerySnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot) //: 이니셜라이져라고 불림 {}보다 더 빨리 실행됨
      : this.fromJson(snapshot.data(), snapshot.id, snapshot.reference);

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['nickName'] = nickName;
    map['userKey'] = userKey;
    map['imageDownloadUrls'] = imageDownloadUrls;
    map['title'] = title;
    map['category'] = category;
    map['secret'] = secret;
    map['detail'] = detail;
    map['createdDate'] = createdDate;
    map['lastComment']=lastComment;
    map['chatNumber']=chatNumber;
    map['heartNumber']=heartNumber;
    return map;
  }


  static String generateItemKey(String uid){
    String timeInMilli = DateTime.now().millisecondsSinceEpoch.toString();
    return '{$uid}_$timeInMilli';
  }
}