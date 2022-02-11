import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test2/pages/home_page/som_page.dart';
import 'package:test2/pages/home_page/upload_page.dart';
import 'package:test2/pages/login_page/auth_page.dart';
import 'package:test2/provider/page_notifier.dart';
import 'package:test2/widgets/expandable_fat.dart';

class MyHomePage extends StatefulWidget {
  static const String? pageName = 'MyHomePage'; //value key 지정해줌
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _bottomSelectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyanAccent,
        elevation: 2,
        centerTitle: false,
        title: _bottomSelectedIndex == 0
            ? _appbartext('솜')
            : _bottomSelectedIndex == 1
                ? _appbartext('사')
                : _bottomSelectedIndex == 2
                    ? _appbartext('탕')
                    : _appbartext('내 정보'),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                CupertinoIcons.search,
              )),
          IconButton(
              onPressed: () {
                FirebaseAuth.instance
                    .signOut(); //실제로 로그아웃
                //Provider.of<PageNotifier>(context,listen: false).goToOtherPage(AuthPage.pageName);
              },
              icon: Icon(CupertinoIcons.nosign)),
        ],
      ),
      floatingActionButton: ExpandableFab(
        distance: 90, //children에서 버튼까지 거리
        children: [
          MaterialButton(
            onPressed: () {
              Provider.of<PageNotifier>(context,listen: false).goToOtherPage(UploadPage.pageName);
            },
            shape: CircleBorder(),
            height: 40,
            color: Theme.of(context).colorScheme.primary,
            child: Icon(Icons.add),
          ),
          MaterialButton(
            onPressed: () {},
            shape: CircleBorder(),
            height: 40,
            color: Theme.of(context).colorScheme.primary,
            child: Icon(Icons.add),
          ),
          MaterialButton(
            onPressed: () {},
            shape: CircleBorder(),
            height: 40,
            color: Theme.of(context).colorScheme.primary,
            child: Icon(Icons.add),
          ),
        ],
      ),
      body: IndexedStack(
        index: _bottomSelectedIndex,
        children: [
          SomPage(),
          Container(
            color: Colors.accents[2],
          ),
          Container(
            color: Colors.accents[3],
          ),
          Container(
            color: Colors.accents[4],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomSelectedIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _bottomSelectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: ''),
          BottomNavigationBarItem(
              icon: Icon(_bottomSelectedIndex == 1
                  ? Icons.screen_share
                  : Icons.screen_share_outlined),
              label: ''),
          BottomNavigationBarItem(
              icon: Icon(_bottomSelectedIndex == 2
                  ? Icons.chat_bubble
                  : Icons.chat_bubble_outline),
              label: ''),
          BottomNavigationBarItem(
              icon: Icon(_bottomSelectedIndex == 3
                  ? Icons.account_circle
                  : Icons.account_circle_outlined),
              label: ''),
        ],
      ),
    );
  }

  Text _appbartext(String text) => Text(text,style: TextStyle(fontWeight: FontWeight.bold));
}
