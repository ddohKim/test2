import 'package:extended_image/extended_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test2/states/page_notifier.dart';

class CheckYourEmail extends Page {
  static const pageName = "CheckYourEmail";

  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) {
        return CheckYourEmailWidget();
      },
    );
  }
}

class CheckYourEmailWidget extends StatefulWidget {
  CheckYourEmailWidget({Key? key}) : super(key: key);
  @override
  _AuthWidgetState createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<CheckYourEmailWidget> {
  String? _nickUserName;
  TextEditingController _nickNameController=TextEditingController();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _emailverified=false;
  @override

  void dispose() {
    _nickNameController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    Size _size=MediaQuery.of(context).size;
    return Material(
      child: Container(
        color: Colors.cyanAccent,
        child: SafeArea(
          child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.transparent,
            body: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  Text(
                    '솜사탕',
                    style: TextStyle(fontSize: 40),
                  ),
                  Text('이메일 인증',style: TextStyle(fontSize: 35),),
                  SizedBox(
                    height: 40,
                  ),
                  _sendVerification(),
                  SizedBox(
                    height: 40,
                  ),
                  _signout(),
                  SizedBox(
                    height: 40,
                  ),
                  _emailverified?_emailVerified(context):Container(height: 50,),
                   Expanded(

                     child: Center(
                       child: SizedBox(
                         child: ExtendedImage.asset(
                                    'assets/솜사탕_2.png'),
                       ),
                  ),
                   ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _sendVerification() {
    return FlatButton(
      onPressed: () async {
        FirebaseAuth.instance.currentUser!.sendEmailVerification(); //확인이메일보내기
        SnackBar snackbar = SnackBar(content: Text('보내준 이메일 링크를 확인해주세요'));
        _scaffoldKey.currentState!.showSnackBar(snackbar); //snackbar  보여주기
        _emailverified=true;
        setState(() {

        });
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      padding: EdgeInsets.all(16),
      color: Colors.white54,
      textColor: Colors.black87,
      child: Text(
        "인증 이메일을 발송할게요",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _emailVerified(BuildContext context) {
    return FlatButton(
      onPressed: ()  {
        _nickName();
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      padding: EdgeInsets.all(16),
      color: Colors.white54,
      textColor: Colors.black87,
      child: Text(
        "이메일 인증 확인 버튼입니다",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _signout() {
    return FlatButton(
      onPressed: () async {
        FirebaseAuth.instance.signOut();
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      padding: EdgeInsets.all(16),
      color: Colors.white54,
      textColor: Colors.black87,
      child: Text(
        "다른 게정으로 로그인할게요",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }

  void _nickName() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            titleTextStyle: const TextStyle(fontSize: 20, color: Colors.black),
            contentTextStyle: const TextStyle(fontSize: 10, color: Colors.black),
            title: const Text('닉네임을 설정하세요'),
            content: TextFormField(
          controller: _nickNameController,
          decoration: InputDecoration(
          hintText: '중복하여 닉네임을 설정할 수 있습니다',
          border: UnderlineInputBorder(
          borderSide: BorderSide.none))),
            actions: [
              TextButton(
                    onPressed: () async {_nickUserName=_nickNameController.text;
                      Provider.of<PageNotifier>(context, listen: false).refresh(_nickUserName);
                      Navigator.pop(context);
                    },
           child: Text('완료'),)
            ],
          );
        });
  }

}
