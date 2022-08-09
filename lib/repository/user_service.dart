import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test2/constants/data_keys.dart';
import 'package:test2/data/user_model.dart';

class UserService {
  static final UserService _userService =
  UserService._internal(); //하나의 instance만 생성해주기 위해서는 이렇게 해줘야한다
  factory UserService() => _userService;

  UserService._internal();

  Future createdNewUser(Map<String, dynamic> json, String userKey) async {
    DocumentReference<Map<String, dynamic>> documentReference =
    FirebaseFirestore.instance.collection(COL_USERS).doc(userKey);
    final DocumentSnapshot documentSnapshot = await documentReference.get();
    if (!documentSnapshot.exists) {
      await documentReference.set(json);
    }
  }

  Future<UserModel> getUserModel(String userKey) async {
    //firebase에서 userModel 가져오기
    DocumentReference<Map<String, dynamic>> documentReference =
    FirebaseFirestore.instance.collection(COL_USERS).doc(userKey);
    final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
    await documentReference.get();
    UserModel userModel = UserModel.fromSnapshot(documentSnapshot);
    return userModel;
  }

  Future updateSaTang(String userKey, bool saTang,String saTangList) async {
    DocumentReference<Map<String, dynamic>>
    documentReference = //users의 해당 userKey의 document를 가져온다
    FirebaseFirestore.instance.collection(COL_USERS).doc(userKey);
    UserModel _userModel=await getUserModel(userKey);
    if (saTang) {
      await documentReference.update({'saTang':_userModel.saTang!+10});
      await documentReference.update(
          {'saTangList': FieldValue.arrayUnion([saTangList])});
    }
    else{
      await documentReference.update({'saTang':_userModel.saTang!-10});
      documentReference.update(
          {'saTangList': FieldValue.arrayRemove([saTangList])});
    }
  }


  Future updateProfile(String? nickName, String? introduce, String userKey,
      String? profileImageUrl) async {
    DocumentReference<Map<String, dynamic>>
    userDocReference = //users의 해당 userKey의 document를 가져온다
    FirebaseFirestore.instance.collection(COL_USERS).doc(userKey);
    if (profileImageUrl != null) {
      await userDocReference.update({'profileImageUrl': profileImageUrl});
    }
    if (nickName != "") {
      await userDocReference.update({'nickName': nickName});
    }
    if (introduce != "") {
      await userDocReference.update({'introduce': introduce});
    }
  }

  Future deleteProfile(String userKey) async {
    await FirebaseFirestore.instance
        .collection(COL_USERS)
        .doc(userKey)
        .delete();
    // QuerySnapshot<Map<String, dynamic>> itemDelete=await FirebaseFirestore.instance.collection(COL_ITEMS).where('userKey',isEqualTo: userKey).;
  }
}
