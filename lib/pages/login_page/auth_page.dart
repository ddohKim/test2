import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:test2/provider/page_notifier.dart';

class AuthPage extends StatefulWidget {
  static const String? pageName = 'AuthPage'; //value key 지정해줌
  const AuthPage({Key? key}) : super(key: key);

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>(); //global key 생성
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<
      ScaffoldState>(); //error snackbar를 보여주기 위해서
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmpasswordController = TextEditingController();

  bool isRegister = false;

  OutlineInputBorder _border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.transparent, width: 0));

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmpasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.cyanAccent,
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.transparent, //바탕화면을 투명한 색으로 해야함
          body: SafeArea(
            child: Form(
              //입력창을 만드는 form
              key: _formKey,
              child: ListView(
                reverse: true, //아래쪽으로 쌓임
                padding: EdgeInsets.all(16),
                children: [Center(child: Text("솜사탕",style: TextStyle(fontFamily: 'NanumAJUMMAJAYU',fontSize: 60,fontWeight: FontWeight.bold),)),
                  SizedBox(
                    height: 100,
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.white54,
                    radius: 36,
                    child: Image.asset('assets/솜사탕_1.png'),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  ButtonBar(
                    children: [
                      TextButton(
                          onPressed: () {
                            setState(() {
                              isRegister = false;
                            });
                          },
                          child: Text(
                            '로그인',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: isRegister
                                    ? FontWeight.w400
                                    : FontWeight.w600,
                                color: isRegister
                                    ? Colors.black45
                                    : Colors.black87),
                          )),
                      TextButton(
                          onPressed: () {
                            setState(() {
                              isRegister = true;
                            });
                          },
                          child: Text(
                            '새 계정',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: isRegister
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: isRegister
                                    ? Colors.black87
                                    : Colors.black45),
                          ))
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  _buildTextFormField("이메일주소를 입력하세요", _emailController),
                  SizedBox(
                    height: 8,
                  ),
                  _buildTextFormField("비밀번호를 입력하세요", _passwordController),
                  SizedBox(
                    height: 8,
                  ),
                  AnimatedContainer(
                    height: isRegister ? 60 : 0,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.fastOutSlowIn,
                    child: _buildTextFormField(
                        "비밀번호를 다시 입력해주세요", _confirmpasswordController),
                  ),

                  SizedBox(
                    height: 16,
                  ),
                  TextButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (isRegister) {
                          try {
                            //create user
                            UserCredential userCredential = await FirebaseAuth
                                .instance.createUserWithEmailAndPassword(
                                email: _emailController.text,
                                password: _passwordController
                                    .text); //파이어베이스에서 이메일, 패스워드 생성해달라고 요청
                          } on FirebaseAuthException catch (e) { //firebaseAuthException의 error만 받아옴
                            if (e.code == 'email-already-in-use') {
                              SnackBar snackbar = SnackBar(
                                content: Text('해당 이메일은 이미 사용중입니다'),);
                              _scaffoldKey.currentState!.showSnackBar(snackbar);
                            } else if (e.code == 'invalid-email') {
                              SnackBar snackbar = SnackBar(
                                content: Text('이메일이 유효하지 않습니다'),);
                              _scaffoldKey.currentState!.showSnackBar(snackbar);
                            } else if (e.code == 'operation-not-allowed') {
                              SnackBar snackbar = SnackBar(
                                content: Text('해당유저는 허락되지 않습니다'),);
                              _scaffoldKey.currentState!.showSnackBar(snackbar);
                            } else if (e.code == 'weak-password') {
                              SnackBar snackbar = SnackBar(
                                content: Text('패스워드보안이 약합니다'),);
                              _scaffoldKey.currentState!.showSnackBar(snackbar);
                            }
                          }
                        } else {
                          //login user
                          try {
                            await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                                email: _emailController.text,
                                password: _passwordController.text);
                          }on FirebaseAuthException catch(e){
                            if (e.code == 'invalid-email') {
                              SnackBar snackbar = SnackBar(
                                content: Text('이메일이 유효하지 않습니다'),);
                              _scaffoldKey.currentState!.showSnackBar(snackbar);
                            } else if (e.code == 'user-disabled') {
                              SnackBar snackbar = SnackBar(
                                content: Text('해당유저는 이용할 수 없습니다'),);
                              _scaffoldKey.currentState!.showSnackBar(snackbar);
                            } else if (e.code == 'user-not-found') {
                              SnackBar snackbar = SnackBar(
                                content: Text('유저를 찾을 수 없습니다'),);
                              _scaffoldKey.currentState!.showSnackBar(snackbar);
                            } else if (e.code == 'wrong-password') {
                              SnackBar snackbar = SnackBar(
                                content: Text('패스워드가 틀렸습니다'),);
                              _scaffoldKey.currentState!.showSnackBar(snackbar);
                            }

                      }
                        }
                      }
                    },
                    child: Text(
                      isRegister ? "새로만들기" : "로그인하기",
                      style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                    ),
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        backgroundColor: Colors.white54),
                  ),
                  Divider(
                    height: 51,
                    thickness: 1,
                    color: Colors.white,
                    indent: 10,
                    endIndent: 10,
                  ), //thickness는 divider의 두께, height는 높이
                  ButtonBar(
                    alignment: MainAxisAlignment.center,
                    children: [
                      _buildSocialButton('assets/icons8-google-48.png', () {
                       // _signInwithGoogle();
                      }),
                      _buildSocialButton(
                          'assets/icons8-facebook-48.png', () {
                        Provider.of<PageNotifier>(context, listen: false)
                            .goToMain();
                      }),
                      _buildSocialButton(
                          'assets/icons8-apple-logo-48.png', () {
                        Provider.of<PageNotifier>(context, listen: false)
                            .goToMain();
                      }),
                    ],
                  ) //button을 나열하는 것
                ]
                    .reversed
                    .toList(), //reverse해주고 iterable로 reverse가 받기 때문에 toList를 이용해 List로 바꿔줌
              ),
            ),
          ),
        ),
      ),
    );
  }


  Future<UserCredential> _signInwithGoogle()async{
  final GoogleSignInAccount? googleUser=await GoogleSignIn().signIn(); //구글 로그인 팝업이 뜸, 로그인 입력
  final GoogleSignInAuthentication googleAuth=await googleUser!.authentication; //로그인 정보를 가져
  final AuthCredential credential=GoogleAuthProvider.credential(accessToken: googleAuth.accessToken,idToken: googleAuth.idToken);//firebase에 로그인 하기 위햇 credential생성
  final UserCredential userCredential=await FirebaseAuth.instance.signInWithCredential(credential); //firebase에 로그인하는 것
  return userCredential;
  }

  Container _buildSocialButton(String imagePath, Function()? onPressed) {
    return Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25), color: Colors.white54),
        child: IconButton(
            onPressed: onPressed, icon: ImageIcon(AssetImage(imagePath))));
  }

  TextFormField _buildTextFormField(String hintText,
      TextEditingController controller) {
    return TextFormField(
      cursorColor: Colors.white,
      obscureText: controller != _emailController,
      controller: controller,
      validator: (text) {
        //입력했는지 안했는지 error 잡기
        if (controller != _confirmpasswordController &&
            (text == null || text.isEmpty)) {
          return "입력창이 비어있어요";
        }
        if (controller == _confirmpasswordController && isRegister) {
          if ((text == null && text!.isEmpty) ||
              text != _passwordController.text)
            return "비밀번호 확인부분 다시 확인해주세요";
        }
        return null;
      },
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hintText,
        border: _border,
        errorBorder: _border.copyWith(
            borderSide: BorderSide(color: Colors.black, width: 3)),
        //copywidth는 그대로 가져와서 입력값을 다르게 바꿔줌
        enabledBorder: _border,
        focusedBorder: _border,
        errorStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        hintStyle: TextStyle(color: Colors.white),
        filled: true,
        fillColor: Colors.black45,
      ),
    );
  }
}
