import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test2/constants/common_size.dart';
import 'package:test2/data/item_model.dart';
import 'package:test2/data/report_model.dart';
import 'package:test2/pages/my_home.dart';
import 'package:test2/repository/report_service.dart';

import '../../states/report_to_manager_notifier.dart';

class ReportUploadPage extends StatefulWidget {
  final String itemKey;

  const ReportUploadPage({Key? key, required this.itemKey}) : super(key: key);

  @override
  _ReportUploadPageState createState() => _ReportUploadPageState();
}

class _ReportUploadPageState extends State<ReportUploadPage> {
  TextEditingController _detailController = TextEditingController();

  @override
  void dispose() {
    _detailController.dispose();
    super.dispose();
  }

  var _divider = Divider(
    height: 1,
    thickness: 1,
    color: Colors.grey[400],
    indent: common_padding,
    endIndent: common_padding,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: TextButton(
          style: TextButton.styleFrom(
              primary: Colors.black54, //클릭했을때 색깔 나오도록
              backgroundColor: Theme.of(context).appBarTheme.backgroundColor),
          child: Text(
            '뒤로',
            style: Theme.of(context).textTheme.bodyText2,
          ),
          onPressed: () {
            Navigator.pop(context); //뒤로가기 버튼 만들기
          },
        ),
        title: Text(
          '신고하기',
          style: Theme.of(context).textTheme.headline6,
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
                primary: Colors.black54, //클릭했을때 색깔 나오도록
                backgroundColor: Theme.of(context).appBarTheme.backgroundColor),
            child: Text(
              '신고 완료',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            onPressed: () async{
              if (FirebaseAuth.instance.currentUser == null) {return null;}

              final String userKey = FirebaseAuth.instance.currentUser!.uid;
              ReportModel reportModel = ReportModel(
                  itemKey: widget.itemKey,
                  userKey: userKey,
                  detail: _detailController.text,
                  createdDate: DateTime.now(),
                  category:
                      context.read<ReportToManagerNotifier>().currentCategory);
              await ReportService().createdNewReport(reportModel.toJson(), widget.itemKey, userKey);
             // Navigator.push(
             //   context,
             //   MaterialPageRoute(
             //       builder: (context) => MyHomePage()),
             // );
             Navigator.popUntil(context, (route) => route.isFirst); //첫번째 route로 돌아가기
            //  Navigator.popUntil(context, ModalRoute.withName(Navigator.defaultRouteName)); //첫번째 route로 돌아가기
              // Navigator.pop(context); //뒤로가기 버튼 만들기
            },
          )
        ],
      ),
      body: ListView(
        children: [
          Row(children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: common_padding, vertical: common_small_padding),
              child: Text(
                "분류 : ",
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
            Text(
              '${context.read<ReportToManagerNotifier>().currentCategory}',
              style: Theme.of(context).textTheme.headline4,
            )
          ]),
          _divider,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: common_padding),
            child: TextFormField(
              controller: _detailController,
              maxLines: null,
              keyboardType: TextInputType.multiline, //여러줄가능
              //enter가 입력완료가 아니라 한줄 띄기로 입력됨
              decoration: InputDecoration(hintText: '''신고 내용을 자세히 작성해주세요.
검토 후 처리하겠습니다.''', border: UnderlineInputBorder(borderSide: BorderSide.none)),
            ),
          )
        ],
      ),
    );
  }
}
