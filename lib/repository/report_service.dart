import 'package:cloud_firestore/cloud_firestore.dart';

import '../constants/data_keys.dart';

class ReportService {
  static final ReportService _reportService =
  ReportService._internal(); //하나의 instance만 생성해주기 위해서는 이렇게 해줘야한다
  factory ReportService() => _reportService;

  ReportService._internal();

  Future createdNewReport(Map<String, dynamic>json,String itemKey,String userKey) async{
    DocumentReference<Map<String,dynamic>> documentReference=FirebaseFirestore.instance.collection(COL_REPORT).doc('${itemKey}_$userKey');
    final DocumentSnapshot documentSnapshot=await documentReference.get();
    if(!documentSnapshot.exists){
      await documentReference.set(json);
    }
    else await documentReference.update(json);
  }
}