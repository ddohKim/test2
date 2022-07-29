import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
//필수로 들어가야하는 데이터는 late를 쓰고(나중에 데이터를 넣는다는 의미) 넣어도 되고 안넣어도 되는 데이터는 ? 를 사용,
  late String emailAddress;
  late DateTime createdDate;
  late String userKey;
  DocumentReference? reference;
   String? nickName;

  UserModel({
    required this.emailAddress,
    required this.createdDate,
    required this.userKey,
    this.nickName,
    this.reference,
  });

  UserModel.fromJson(Map<String, dynamic> json, this.userKey, this.reference) {
   nickName=json['nickName']??"";
    emailAddress = json['emailAddress'];
    createdDate = json['createdDate'] == null
        ? DateTime.now().toUtc()
        : (json['createdDate'] as Timestamp)
            .toDate(); //json['createdDate']가 Timestamp이고 이걸 Date으로 변경
  }

  UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) //: 이니셜라이져라고 불림 {}보다 더 빨리 실행됨
      : this.fromJson(snapshot.data()!, snapshot.id, snapshot.reference);

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['emailAddress'] = emailAddress;
    map['createdDate'] = createdDate;
    map['nickName']=nickName;
    return map;
  }
}
