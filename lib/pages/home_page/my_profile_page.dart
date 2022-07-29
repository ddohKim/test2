
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test2/data/user_model.dart';
import 'package:test2/provider/page_notifier.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({Key? key}) : super(key: key);

  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  @override
  Widget build(BuildContext context) {
    UserModel userModel =
    context.read<PageNotifier>().userModel!;

    return Scaffold(
      body: Text(userModel.emailAddress,),
    );
  }
}
