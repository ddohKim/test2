import 'dart:async';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test2/pages/profile_page/profile_image_select.dart';
import 'package:provider/provider.dart';
import 'package:test2/repository/image_storage.dart';
import 'package:test2/repository/user_service.dart';
import '../../constants/common_size.dart';
import '../../states/page_notifier.dart';
import '../../states/select_image_notifier.dart';

class ProfileChangePage extends StatefulWidget {
  final String userKey;
  const ProfileChangePage({Key? key, required this.userKey}) : super(key: key);

  @override
  State<ProfileChangePage> createState() => _ProfileChangePageState();
}

class _ProfileChangePageState extends State<ProfileChangePage> {
  bool _isChangeProfile = false;
  @override
  final _divider = Divider(
    height: 3,
    thickness: 1,
    color: Colors.grey[400],
    indent: common_padding,
    endIndent: common_padding,
  );

  TextEditingController _nickNameController = TextEditingController();
  TextEditingController _introduceController = TextEditingController();

  @override
  void dispose() {
    _nickNameController.dispose();
    _introduceController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {


    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      Size _size = MediaQuery.of(context).size;
      return IgnorePointer(
        ignoring: _isChangeProfile,
        child: Scaffold(
          backgroundColor: Colors.white,
            appBar: AppBar(
              bottom: PreferredSize(
                preferredSize: Size(_size.width, 2),
                //upload 하는 동안 appbar 로딩만들기, 가로, 세로 높이
                child: _isChangeProfile
                    ?  LinearProgressIndicator(color: Colors.green,
                        minHeight: 2,
                      )
                    : Container(),
              ),
              leading: TextButton(
                style: TextButton.styleFrom(
                    primary: Colors.black54, //클릭했을때 색깔 나오도록
                    backgroundColor:
                        Theme.of(context).appBarTheme.backgroundColor),
                child: Text(
                  '뒤로',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                onPressed: () {
                  Navigator.pop(context); //뒤로가기 버튼 만들기
                },
              ),
              title: Text(
                '프로필을 변경할게요',
                style: Theme.of(context).textTheme.headline6,
              ),
              actions: [
                TextButton(
                  style: TextButton.styleFrom(
                      primary: Colors.black54, //클릭했을때 색깔 나오도록
                      backgroundColor:
                          Theme.of(context).appBarTheme.backgroundColor),
                  child: Text(
                    '완료',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  onPressed: () async{
                    _isChangeProfile=true;
                    setState(() {

                    });
                    Uint8List? image=context
                        .read<SelectImageNotifier>().image;
                    String downloadUrl=await ImageStorage.uploadProfileImage(image!, widget.userKey);
                  await  UserService().updateProfile(_nickNameController.text, _introduceController.text, widget.userKey,downloadUrl);
setState(() {

});
                    Navigator.pop(context); //뒤로가기 버튼 만들기
                  },
                ),
              ],
            ),
            body: ListView(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: common_padding),
                      child: TextButton(
                        onPressed: ()  {
                          _changePassword(context);
                        },
                        child: Text("비밀번호 변경하기"),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: common_padding),
                      child: TextButton(
                        onPressed: () {
                          _deleteUser();

                        },
                        child: Text("회원 탈퇴하기"),
                      ),
                    )
                  ],
                ),
                ProfileImageSelect(),
                Padding(
                  padding: const EdgeInsets.only(left: common_padding),
                  child: Text(
                    "프로필 사진 변경하기",
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                ),
                _divider,
                Padding(
                  padding: const EdgeInsets.only(left: common_padding,right: common_padding),
                  child: Row(
                    children: [
                      Text(
                        '닉네임:  ',
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: _nickNameController,
                          maxLines: 1,
                          maxLength: 10,
                          keyboardType: TextInputType.name,
                          //enter가 입력완료가 아니라 한줄 띄기로 입력됨
                          decoration: InputDecoration(
                              labelText: '새로운 닉네임을 입력해주세요!',
                              border: UnderlineInputBorder(
                                  borderSide: BorderSide.none)),
                        ),
                      ),
                    ],
                  ),
                ),
                _divider,
                Padding(
                  padding: const EdgeInsets.only(left: common_padding,right: common_padding),
                  child: Row(
                    children: [
                      Text(
                        '사탕이는?:  ',
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: _introduceController,
                          maxLength: 100,
                          maxLines: 8,
                          keyboardType: TextInputType.text,
                          //enter가 입력완료가 아니라 한줄 띄기로 입력됨
                          decoration: InputDecoration(
                              labelText: '자신을 소개해보아요!',
                              border: UnderlineInputBorder(
                                  borderSide: BorderSide.none)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )),
      );
    });
  }

  void _changePassword(BuildContext context2) {
    showDialog(
        context: context2,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            titleTextStyle: const TextStyle(fontSize: 20, color: Colors.black),
            contentTextStyle:
            const TextStyle(fontSize: 10, color: Colors.black),
            title: const Text('비밀번호를 변경하시겠습니까?'),
            content: const Text(
                '해당 이메일로 비밀번호 변경하도록 메일을 보내드리겠습니다. 다시 로그인해주세요!'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('취소')),
              TextButton(
                  onPressed: () async{
                  // int count=0;
                  //  Navigator.popUntil(context, (route) {return count++==2;});
Navigator.popUntil(context, ModalRoute.withName(Navigator.defaultRouteName) );
                    Navigator.of(context2).popUntil((route) => route.isFirst);
                    final FirebaseAuth fAuth =
                        FirebaseAuth.instance; // Firebase 인증 플러그인의 인스턴스
                    await fAuth.setLanguageCode("ko");
                    fAuth.sendPasswordResetEmail(
                        email: context.read<PageNotifier>().user!.email!);
                    FirebaseAuth.instance.signOut(); //실제로 로그아웃
                   // Provider.of<PageNotifier>(context, listen: false).refresh(context.read<PageNotifier>().userModel!.nickName);
                  },
                  child: const Text('이메일 보내기'))
            ],
          );
        });
  }

  void _deleteUser() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            titleTextStyle: const TextStyle(fontSize: 20, color: Colors.black),
            contentTextStyle:
            const TextStyle(fontSize: 10, color: Colors.black),
            title: const Text('회원을 탈퇴하시겠습니까?'),
            content: const Text(
                '회원을 탈퇴하는 버튼으로 더 이상 솜사탕을 이용할 수 없습니다.'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('취소')),
              TextButton(
                  onPressed: () async{
                    UserService().deleteProfile(widget.userKey);
                    Navigator.of(context).pop();
                    context.read<PageNotifier>().withdrawalAccount();
                  },
                  child: const Text('솜사탕 탈퇴하기'))
            ],
          );
        });
  }
}
