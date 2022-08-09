import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test2/pages/report_page/report_upload_page.dart';
import 'package:test2/states/report_to_manager_notifier.dart';

class ReportToManagerPage extends StatefulWidget {
  final String itemKey;
  const ReportToManagerPage({Key? key,required this.itemKey}) : super(key: key);

  @override
  State<ReportToManagerPage> createState() => _ReportToManagerPageState();
}

class _ReportToManagerPageState extends State<ReportToManagerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: TextButton(
          style: TextButton.styleFrom(
              primary: Colors.black54, //클릭했을때 색깔 나오도록
              backgroundColor: Theme
                  .of(context)
                  .appBarTheme
                  .backgroundColor),
          child: Text(
            '뒤로',
            style: Theme
                .of(context)
                .textTheme
                .bodyText2,
          ),
          onPressed: () {
            Navigator.popUntil(context, (route) => route.isFirst);
            //Navigator.pop(context); //뒤로가기 버튼 만들기
          },
        ),
        title: Text(
          '신고하기',
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      body:  ListView.separated(
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () {
                context.read<ReportToManagerNotifier>().setNewReport(
                    ReportToManagerNotifier.report.elementAt(index));
                setState(() {

                });
                //Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ReportUploadPage(itemKey: widget.itemKey,)),
                );
              },
              title: Text(
                ReportToManagerNotifier.report.elementAt(index),
                style: TextStyle(
                    color: context.read<ReportToManagerNotifier>().currentCategory ==
                        ReportToManagerNotifier.report.elementAt(index)
                        ? Theme.of(context).primaryColor
                        : Colors.black87),
              ),
            );
          },
          separatorBuilder: (context, index) {
            return Divider(
              height: 1,
              thickness: 1,
              color: Colors.grey[300],
            );
          },
          itemCount: ReportToManagerNotifier.report.length)
      ,
    );
  }
}
