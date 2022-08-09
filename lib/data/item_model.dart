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
  late List<dynamic> heartNumber;
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
    heartNumber=json['heartNumber']??[];
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

 // ItemModel.fromQuerySnapShot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot) //docs 는 UserModel.fromSnapshot 아닌 querydocumentsnapshot으로 받아야 하기 때문에 이걸 사용해줘서 ITemModel List를 받아온다
   //   : this.fromJson(snapshot.data(), snapshot.id, snapshot.reference); //무조건 snapshot은 데이터가 존재한다


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

  Map<String, dynamic> toMinJson() { //firestore에 user에 최소한의 item 정보들을 저장할때
    final map = <String, dynamic>{};
    map['imageDownloadUrls'] = imageDownloadUrls.isEmpty?'':imageDownloadUrls.sublist(0,1); //1개의 list 내 index 만 필요하다
    map['title'] = title;
    map['createdDate'] = createdDate;
    map['category']=category;
    return map;
  }
  static String generateItemKey(String uid){
    String timeInMilli = DateTime.now().millisecondsSinceEpoch.toString();
    return '{$uid}_$timeInMilli';
  }
}