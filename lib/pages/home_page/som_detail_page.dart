import 'package:extended_image/extended_image.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:test2/constants/common_size.dart';

import 'package:test2/data/comment_model.dart';
import 'package:test2/data/item_model.dart';
import 'package:test2/data/user_model.dart';
import 'package:test2/pages/home_page/report_to_manager_page.dart';
import 'package:test2/provider/page_notifier.dart';
import 'package:test2/repository/item_service.dart';
import 'package:test2/states/comment_notifier.dart';
import 'package:test2/widgets/comment.dart';
import 'package:test2/widgets/time_calculator.dart';

class SomDetailScreen extends StatefulWidget {
  final String itemKey;

   SomDetailScreen({
    Key? key,
    required this.itemKey,
  }) : super(key: key);

  @override
  _ItemDetailScreenState createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<SomDetailScreen> {
  TextEditingController _commentController = TextEditingController();
  PageController _pageController = PageController();
  ScrollController _scrollController = ScrollController();
  Size? _size;
  bool selectedHeart=false;

  num? _statusBarHeight;
  num? _statusBottomBarHeight;
  late CommentNotifier _commentNotifier;

  bool isAppbarCollapsed = false;
  Widget _textGap = SizedBox(
    height: common_small_padding,
  );
  Widget _divider = Divider(
    height: common_small_padding * 2 + 1,
    thickness: 2,
    color: Colors.grey[200],
  );

  @override
  void initState() {
    _commentNotifier = CommentNotifier(widget.itemKey);

    _scrollController.addListener(() {
      //얼마나 스크롤 했는지 addListener로 확인하기
      if (_size == null || _statusBarHeight == null) //_size가 사진 높이라고 생각
        return;
      if (isAppbarCollapsed) {
        if (_scrollController.offset <
            _size!.width - kToolbarHeight - _statusBarHeight!) {
          isAppbarCollapsed = false;
          setState(() {});
        } else {
          if (_scrollController.offset >=
              _size!.width - kToolbarHeight - _statusBarHeight!) {
            isAppbarCollapsed = true;
            setState(() {});
          }
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    //  _commentController.dispose();
    _pageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ItemModel>(
        future: ItemService().getItem(widget.itemKey),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            ItemModel itemModel = snapshot.data!;
            UserModel userModel =
                context.read<PageNotifier>().userModel!; //provider를 통해서 가져옴
            return LayoutBuilder(

                builder: (BuildContext context, BoxConstraints constraints) {
                  _size = MediaQuery.of(context).size;
              _statusBarHeight =
                  MediaQuery.of(context).padding.top; //statusbar 길이
              _statusBottomBarHeight = MediaQuery.of(context).padding.bottom;
              return Stack(
                //사진 윗부분이 어둡게 보이게 하기 위해 stack을 사용해서 여러개를 쌓는다고 생각하면 됨
                fit: StackFit.expand, //화면에 꽉 차도록
                children: [
                  Scaffold(
                      bottomNavigationBar: SafeArea(
                        top: false,
                        bottom: true,
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                              border: Border(
                                  top: BorderSide(color: Colors.grey[300]!))),
                          child: Padding(
                            padding: const EdgeInsets.all(common_small_padding),
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () async  {
                                  await  ItemService().toggleLike(userModel.userKey, itemModel.itemKey,itemModel);
                                    setState(() {
                                 });
                                  },
                                  icon: Icon(itemModel.heartNumber.contains(userModel.userKey)
                                      ? Icons.favorite
                                      : Icons.favorite_border),

                                ),
                                VerticalDivider(
                                  thickness: 1,
                                  width: common_small_padding * 2 + 1,
                                  indent: common_small_padding,
                                  endIndent: common_small_padding,
                                ),
                                TextButton(
                                    onPressed: () {}, child: Text('일대일 채팅하기'))
                              ],
                            ),
                          ),
                        ),
                      ),
                      body: Column(
                        children: [
                          Expanded(
                            child: CustomScrollView(
                              //listview 같은 거, slivers를 넣어줌
                              controller: _scrollController,
                              slivers: [
                                _imagesAppBar(itemModel, context),
                                SliverPadding(
                                  //sliverpadding에는 child가 아니 sliver를 넣어줘야 함
                                  padding: EdgeInsets.all(common_padding),
                                  sliver: SliverList(
                                    delegate: SliverChildListDelegate([
                                      _userSection(userModel, itemModel),
                                      _divider,
                                      Text(
                                        itemModel.title,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5,
                                      ),
                                      _textGap,
                                      _textGap,
                                      Text(
                                        itemModel.detail,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                      ),
                                      _textGap,
                                      Text(
                                        '❤️ ${itemModel.heartNumber.length}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2!
                                            .copyWith(color: Colors.grey),
                                      ),
                                      _divider,
                                      MaterialButton(
                                          padding: EdgeInsets.zero,
                                          onPressed: () {
                                            _reportItem();
                                          },
                                          child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text('이 게시글 신고하기'))),
                                      _divider,
                                    ]),
                                  ),
                                ),
                                SliverToBoxAdapter(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: common_padding),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '댓글',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5,
                                        ),
                                        SizedBox(
                                          width: _size!.width / 4,
                                          child: MaterialButton(
                                            //materialbutton은 가로 사이즈가 정해지지 않아서 sizedbox를 사용해서 가로 길이를 정해줌
                                            padding: EdgeInsets.zero,
                                            onPressed: () {},
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                '더보기',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .button!
                                                    .copyWith(
                                                        color: Colors.grey),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                ChangeNotifierProvider<CommentNotifier>.value(
                                  value: _commentNotifier,
                                  child: Consumer<CommentNotifier>(
                                    builder: (context, commentNotifier, child) {
                                      return SliverToBoxAdapter(
                                        child: ListView.separated(
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            padding: const EdgeInsets.all(10),
                                            itemBuilder: (context, index) {
                                              bool isMine = commentNotifier
                                                      .commentList[index]
                                                      .userKey ==
                                                  userModel.userKey;
                                              return Comment(
                                                size: _size!,
                                                isMine: isMine,
                                                commentModel: commentNotifier
                                                    .commentList[index],
                                              );
                                            },
                                            separatorBuilder: (context, index) {
                                              return const SizedBox(
                                                height: 12,
                                              );
                                            },
                                            itemCount: commentNotifier
                                                .commentList.length),
                                      );
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _commentController,
                                  maxLines: null,
                                  keyboardType: TextInputType.multiline,
                                  decoration: InputDecoration(
                                      isDense: true,
                                      fillColor: Colors.white,
                                      filled: true,
                                      hintText: '댓글을 입력해주세요',
                                      hintStyle: const TextStyle(fontSize: 15),
                                      contentPadding: const EdgeInsets.all(10),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      )),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.send),
                                onPressed: () async {
                                  CommentModel commentModel = CommentModel(
                                      comment: _commentController.text,
                                      userKey: userModel.userKey,
                                      createdDate: DateTime.now());
                                  _commentNotifier.addNewComment(commentModel);
                                  _commentController.clear();
                                },
                              ),
                            ],
                          )
                        ],
                      )),
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    height: kToolbarHeight + _statusBarHeight!,
                    //상태바+앱바 길이
                    child: Container(
                      height: kToolbarHeight + _statusBarHeight!,
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                            Colors.black12,
                            Colors.black12,
                            Colors.black12,
                            Colors.black12,
                            Colors.transparent
                          ])),
                    ),
                  ),
                  Positioned(
                      left: 0,
                      right: 0,
                      top: 0,
                      height: kToolbarHeight + _statusBarHeight!,
                      //ktoolbarheight는 appbar 길이
                      child: Scaffold(
                        backgroundColor: Colors.transparent,
                        appBar: AppBar(
                          backgroundColor: isAppbarCollapsed
                              ? Colors.white
                              : Colors.transparent,
                          shadowColor: Colors.transparent, //더 연하게 만들기
                          foregroundColor:
                              isAppbarCollapsed ? Colors.black87 : Colors.white,
                        ),
                      )),
                ],
              );
            });
          }
          return Container();
        });
  }

  SliverAppBar _imagesAppBar(ItemModel itemModel, BuildContext context) {
    return SliverAppBar(
      expandedHeight: _size!.width,
      flexibleSpace: FlexibleSpaceBar(
        //앱바가 스크롤될때 올락다도록해줌
        centerTitle: true, //center 로 오도록 기본값설정
        title: SizedBox(
          child: SmoothPageIndicator(
              //아래 스크롤 버튼 생기도록
              controller: _pageController,
              // PageController
              count: itemModel.imageDownloadUrls.length,
              effect: WormEffect(
                  activeDotColor: Theme.of(context).primaryColor,
                  dotColor: Theme.of(context).colorScheme.background,
                  radius: 2,
                  dotHeight: 4,
                  dotWidth: 4),
              // your preferred effect
              onDotClicked: (index) {}),
        ),
        background: itemModel.imageDownloadUrls.isEmpty
            ? ExtendedImage.asset('assets/솜사탕_3.png')
            : PageView.builder(
                controller: _pageController,
                allowImplicitScrolling: true,
                //미리 다른 화면들을 업로드 시켜 로딩이 시간이 안보이도록 해줌
                itemBuilder: (context, index) {
                  return ExtendedImage.network(
                    itemModel.imageDownloadUrls[index],
                    fit: BoxFit.cover,
                    scale: 0.1,
                  );
                },
                itemCount: itemModel.imageDownloadUrls.length,
              ),
      ),
    );
  }

  Widget _userSection(UserModel userModel, ItemModel itemModel) {
    return Row(
      children: [
        ExtendedImage.network(
          'https://picsum.photos/50',
          fit: BoxFit.cover,
          width: _size!.width / 10,
          height: _size!.width / 10,
          shape: BoxShape.circle,
        ),
        const SizedBox(
          width: common_small_padding,
        ),
        SizedBox(
          height: _size!.width / 10,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                itemModel.nickName.isEmpty
                    ? itemModel.userKey.substring(1, 5)
                    : itemModel.nickName, //
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ],
          ),
        ),
        Expanded(child: Container()),
        Row(
          children: [
            Text(
              itemModel.category,
              style: Theme.of(context)
                  .textTheme
                  .bodyText2!
                  .copyWith(decoration: TextDecoration.underline),
            ),
            Text(
              ' ∙ ${TimeCalculator().getTimeDiff(itemModel.createdDate)}',
              style: Theme.of(context)
                  .textTheme
                  .bodyText2!
                  .copyWith(color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }

  void _reportItem() {
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
            title: const Text('이 게시글을 신고하겠습니까?'),
            content: const Text(
                '광고 및 부적적한 게시글의 경우 신고해주세요!\n담당자가 직접 검토하여 삭제하고 있습니다!\n(검토 후 게시글의 내용에 문제 없을시 삭제가 안될 수도 있어요!)'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('취소')),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ReportToManagerPage()),
                    );
                  },
                  child: const Text('신고'))
            ],
          );
        });
  }
}
