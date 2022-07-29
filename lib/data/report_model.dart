import 'package:cloud_firestore/cloud_firestore.dart';

class ReportModel {
  late String itemKey;
  late String userKey;
  late String detail;
  late DateTime createdDate;
  DocumentReference? reference;
  late String category;

  ReportModel({
    required this.itemKey,
    required this.userKey,
    required this.detail,
    required this.createdDate,
    required this.category,
    this.reference,
  });

  ReportModel.fromJson(
      Map<String, dynamic> json, this.itemKey, this.reference) {
    category = json['category'] ?? '';
    userKey = json['userKey'] ?? '';
    detail = json['detail'] ?? '';
    createdDate = json['createdDate'] == null
        ? DateTime.now().toUtc()
        : (json['createdDate'] as Timestamp).toDate();
  }

  ReportModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>>
          snapshot) //: 이니셜라이져라고 불림 {}보다 더 빨리 실행됨
      : this.fromJson(snapshot.data()!, snapshot.id, snapshot.reference);

  ReportModel.fromQuerySnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>>
          snapshot) //: 이니셜라이져라고 불림 {}보다 더 빨리 실행됨
      : this.fromJson(snapshot.data(), snapshot.id, snapshot.reference);

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['userKey'] = userKey;
    map['detail'] = detail;
    map['createdDate'] = createdDate;
    map['category'] = category;
    return map;
  }
}
