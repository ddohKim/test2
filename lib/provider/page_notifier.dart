import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test2/data/user_model.dart';
import 'package:test2/pages/login_page/check_your_email.dart';
import 'package:test2/pages/my_home.dart';
import 'package:test2/pages/start_page.dart';
import 'package:test2/repository/user_service.dart';

class PageNotifier extends ChangeNotifier{
  String? _currentPage=StartPage.pageName; //_가 들어있기 때문에 다른 코드에서 접근을 못함
  User? _user;
  UserModel? _userModel;
  PageNotifier(){
    FirebaseAuth.instance.authStateChanges().listen((user) { //로그인이 되면서 페이지 이동이 됨
      _user=user;
      if(user==null) //로그인이 안된것
        goToOtherPage(StartPage.pageName);
      else{
        if(user.emailVerified) //email이 verified되어 있는지 확인
        goToMain();
      else goToOtherPage(CheckYourEmail.pageName);} //vertified가 안되어있으면 여기로 이동
    });
  }
  String? get currentPage=>_currentPage; //접근하도록
  void goToMain()async{
    await _setNewUser(user);
    _currentPage=MyHomePage.pageName;
    notifyListeners();
  }
  void goToOtherPage(String? name){
    _currentPage=name;
    notifyListeners();
  }

  void refresh()async{
    await FirebaseAuth.instance.currentUser!.reload(); //먼저 reload를 통해 sink를 맞춰줌
    User? user=FirebaseAuth.instance.currentUser; //이메일 verification이 true인지 아닌지 확인

    if(user==null) //로그인이 안된것
      goToOtherPage(StartPage.pageName);
    else{
      if(user.emailVerified) //email이 verified되어 있는지 확인
        goToMain();
      else goToOtherPage(CheckYourEmail.pageName);} //vertified가 안되어있으면 여기로 이동
  }

  Future _setNewUser(User? user)async{
    _user=user;
    if(user!=null&&user.email!=null)
    {String emailAddress=user.email!;
    String userKey=user.uid;
    UserModel userModel=UserModel(emailAddress: emailAddress, createdDate: DateTime.now().toUtc(), userKey: userKey);
    await UserService().createdNewUser(userModel.toJson(), userKey);//UserService()가 한번만 생성되도록 해줌!
    _userModel=await UserService().getUserModel(userKey); //_userModel 받아오기
    }
  }

  User? get user=>_user;
}