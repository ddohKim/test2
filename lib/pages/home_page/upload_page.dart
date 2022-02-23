import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test2/constants/common_size.dart';
import 'package:test2/data/item_model.dart';
import 'package:test2/data/user_model.dart';
import 'package:test2/pages/home_page/category_input_page.dart';
import 'package:test2/pages/home_page/multi_image_select.dart';
import 'package:test2/provider/page_notifier.dart';
import 'package:test2/repository/image_storage.dart';
import 'package:test2/repository/item_service.dart';
import 'package:test2/states/category_notifier.dart';
import 'package:test2/states/select_image_notifier.dart';

class UploadPage extends Page {
  static const pageName = 'UploadPage'; //value key 지정해줌

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
        settings: this,
        builder: (
            context) => const UploadPageWidget());
  }
}

class UploadPageWidget extends StatefulWidget {

  const UploadPageWidget({Key? key}) : super(key: key);

  @override
  _UploadPageWidgetState createState() => _UploadPageWidgetState();
}

class _UploadPageWidgetState extends State<UploadPageWidget> {
  bool _secretSelected = false;
  bool _isCreatingItem = false;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _detailController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
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
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        Size _size = MediaQuery
            .of(context)
            .size;
        return IgnorePointer( //pointer 무시하도록
          ignoring: _isCreatingItem,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.cyanAccent,
              elevation: 2,
              bottom: PreferredSize(preferredSize: Size(_size.width, 2),
                //upload 하는 동안 appbar 로딩만들기, 가로, 세로 높이
                child: _isCreatingItem
                    ? LinearProgressIndicator(minHeight: 2,)
                    : Container(),),
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
                  Navigator.pop(context); //뒤로가기 버튼 만들기
                },
              ),
              title: Text(
                '솜털처럼 포근하게 고민을 들어줄게요',
                style: Theme
                    .of(context)
                    .textTheme
                    .headline6,
              ),
              actions: [
                TextButton(
                  style: TextButton.styleFrom(
                      primary: Colors.black54, //클릭했을때 색깔 나오도록
                      backgroundColor: Theme
                          .of(context)
                          .appBarTheme
                          .backgroundColor),
                  child: Text(
                    '완료',
                    style: Theme
                        .of(context)
                        .textTheme
                        .bodyText2,
                  ),
                  onPressed: ()async{
                    if (FirebaseAuth.instance.currentUser == null) return null;

                    final String userKey=FirebaseAuth.instance.currentUser!.uid;
                    final String itemKey = ItemModel.generateItemKey(userKey);
                    UserModel _userModel =
                    context.read<PageNotifier>().userModel!;
                    String? nickName=_userModel.nickName;
                    _isCreatingItem = true;
                    setState(() {

                    });
                    List<Uint8List> images = context
                        .read<SelectImageNotifier>()
                        .images;
                    List<String> downloadUrls = await ImageStorage.uploadImages(images,itemKey);
                    //firebasestorage에 저장되어 있는 사진의 다운로드url을 받아옴
                    ItemModel itemModel = ItemModel(
                      heartNumber: [],
                      chatNumber: 0,
                        nickName: nickName!,
                        itemKey: itemKey,
                        userKey: userKey,
                        imageDownloadUrls: downloadUrls,
                        title: _titleController.text,
                        category: context
                            .read<CategoryNotifier>()
                            .currentCategory,
                        secret: _secretSelected,
                        detail: _detailController.text,
                        createdDate: DateTime.now().toUtc(), lastComment: '');
                    await ItemService().createdNewItem(itemModel.toJson(), itemKey);
                    images.clear();
                    context.read<CategoryNotifier>().setNewCategory(
                        CategoryNotifier.categories.first);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: common_padding),
                  child: TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                        hintText: '글 제목',
                        border: UnderlineInputBorder(
                            borderSide: BorderSide.none)),
                  ),
                ),
                _divider,
                ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CategoryInputPage()),
                    );

                    //Provider.of<PageNotifier>(context, listen: false)
                    //  .goToOtherPage(CategoryPage.pageName);
                  },
                  dense: true,
                  title: Text(context
                      .watch<CategoryNotifier>()
                      .currentCategory),
                  trailing: Icon(Icons.navigate_next),
                ),
                //dense는 listtile이 압축되있는지 말해줌, listtile로 쉽게 디자인 만들수 있음
                _divider,
                MultiImageSelect(),
                _divider,
                Padding(
                  padding: const EdgeInsets.only(
                      right: common_small_padding),
                  child: TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _secretSelected = !_secretSelected;
                      });
                    },
                    icon: Icon(
                      _secretSelected ? Icons.lock_outline_rounded : Icons
                          .lock_open_rounded,
                      color: _secretSelected ? Theme
                          .of(context)
                          .primaryColor : Colors.black54,
                    ),
                    label: Text(
                      '비밀글쓰기(300사탕 이상인 사람만 댓글을 달 수 있어요!)',
                      style: TextStyle(color: _secretSelected ? Theme
                          .of(context)
                          .primaryColor : Colors.black),
                    ),
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        primary: Colors.black), //primary는 클릭할때 색깔이 나오게 하는 것
                  ),
                ),
                _divider,
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: common_padding),
                  child: TextFormField(
                    controller: _detailController,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    //enter가 입력완료가 아니라 한줄 띄기로 입력됨
                    decoration: InputDecoration(
                        hintText: '올릴 게시글 내용을 작성해주세요.',
                        border: UnderlineInputBorder(
                            borderSide: BorderSide.none)),
                  ),
                ),
              ],
            ),),
        );
      },
    );
  }
}
