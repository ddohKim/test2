import 'package:cloud_firestore/cloud_firestore.dart';
class ChatroomModel {

  ChatroomModel(
      {
        required this.itemTitle,
       // required this.itemKey,
        required this.yourKey,
        required this.myKey,
        required this.yourImage,
        required this.myImage,
        this.lastMsg='',
        required this.lastMsgTime,
        this.lastMsgUserKey='',
        required this.chatroomKey,
        required this.myNickName,
        required this.yourNickName,
        this.reference});

  ChatroomModel.fromJson(Map<String, dynamic> json,this.chatroomKey, this.reference) {
    itemTitle = json['itemTitle'] ?? "";
  //  itemKey = json['itemKey'] ?? "";
    yourKey = json['yourKey'] ?? "";
    myKey = json['myKey'] ?? "";
    yourNickName = json['yourNickName'] ?? "";
    myNickName = json['myNickName'] ?? "";
    yourImage = json['yourImage'] ?? "";
    myImage = json['myImage'] ?? "";
    lastMsg = json['lastMsg'] ?? "";
    lastMsgTime = json['lastMsgTime'] == null
        ? DateTime.now().toUtc()
        : (json['lastMsgTime'] as Timestamp).toDate();
    lastMsgUserKey = json['lastMsgUserKey'] ?? "";
  }

  late String itemTitle;
 // late String itemKey;
  late String yourKey;
  late String myKey;
  late String yourImage;
  late String myImage;
  late String lastMsg;
  late DateTime lastMsgTime;
  late String lastMsgUserKey;
  late String chatroomKey;
  late String myNickName;
  late String yourNickName;
  DocumentReference? reference;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    map['itemTitle'] = itemTitle;
   // map['itemKey'] = itemKey;

    map['yourKey'] = yourKey;
    map['myKey'] = myKey;
    map['yourImage'] = yourImage;
    map['myImage'] = myImage;
    map['lastMsg'] = lastMsg;
    map['lastMsgTime'] = lastMsgTime;
    map['lastMsgUserKey'] = lastMsgUserKey;
    map['myNickName']=myNickName;
    map['yourNickName']=yourNickName;
    return map;
  }

  ChatroomModel.fromSnapShot(DocumentSnapshot<Map<String, dynamic>> snapshot) //ChatroomModel.fromSnapshot에서 해당 받아온 snapshot을 fromJson으로 넘겨 json 데이터로 새로 설정해서 휴대폰 cache로 저장
      : this.fromJson(snapshot.data()!, snapshot.id, snapshot.reference);

  ChatroomModel.fromQuerySnapShot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot) //docs 는 UserModel.fromSnapshot 아닌 querydocumentsnapshot으로 받아야 하기 때문에 이걸 사용해줘서 ITemModel List를 받아온다
      : this.fromJson(snapshot.data(), snapshot.id, snapshot.reference); //무조건 snapshot은 데이터가 존재한다

  static String generateChatRoomKey(String myKey,String yourKey){
    return '${myKey}_$yourKey'; //itemKey_buyer로 chatroomKey를 생성한다
  }


}
