import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test2/constants/data_keys.dart';
import 'package:test2/data/user_model.dart';
class UserService{

  static final UserService _userService=UserService._internal(); //하나의 instance만 생성해주기 위해서는 이렇게 해줘야한다
  factory UserService()=>_userService;
  UserService._internal();

  Future createdNewUser(Map<String, dynamic>json,String userKey) async{
    DocumentReference<Map<String,dynamic>> documentReference=FirebaseFirestore.instance.collection(COL_USERS).doc(userKey);
    final DocumentSnapshot documentSnapshot=await documentReference.get();
    if(!documentSnapshot.exists){
      await documentReference.set(json);
    }
  }

  Future<UserModel> getUserModel(String userKey)async{ //firebase에서 userModel 가져오기
    DocumentReference<Map<String,dynamic>> documentReference=FirebaseFirestore.instance.collection(COL_USERS).doc(userKey);
    final DocumentSnapshot<Map<String,dynamic>> documentSnapshot=await documentReference.get();
    UserModel userModel=UserModel.fromSnapshot(documentSnapshot);
    return userModel;
  }

}