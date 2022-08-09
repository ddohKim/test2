

import 'package:extended_image/extended_image.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test2/constants/common_size.dart';
import 'package:test2/data/user_model.dart';
import 'package:test2/pages/profile_page/profile_change_page.dart';
import 'package:test2/pages/home_page/similar_page.dart';
import 'package:test2/repository/user_service.dart';
import 'package:test2/states/page_notifier.dart';

import '../../data/item_model.dart';
import '../../repository/item_service.dart';

class MyProfilePage extends StatefulWidget {
   const MyProfilePage({Key? key}) : super(key: key);

  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {

  @override
  Widget build(BuildContext context) {
    String? userKey = context
        .read<PageNotifier>()
        .user
        ?.uid;
    return FutureBuilder<UserModel>(
      future: UserService().getUserModel(userKey!),
      builder:(context, snapshot){
        Size _size = MediaQuery.of(context).size;
        UserModel? userModel=snapshot.data;
        return  Scaffold(
          backgroundColor: Colors.white,
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: common_padding),
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.all(common_padding),
                    sliver: SliverList(
                        delegate: SliverChildListDelegate([
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userModel!.nickName!,
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          SizedBox(height: common_small_padding,),
                          Row(
                            children: [
                              SizedBox(
                                width: _size.width / 5,
                                child: ExtendedImage.network(
                                  (userModel.profileImageUrl==null)?'https://picsum.photos/50':userModel.profileImageUrl!,
                                  shape: BoxShape.circle,
                                  // borderRadius: BorderRadius.circular(6),
                                  fit: BoxFit.cover,
                                  height: _size.width / 5,
                                ),
                              ),
                              Expanded(child: SizedBox()),

                              Container(
                              decoration: BoxDecoration( borderRadius: BorderRadius.circular(common_padding),border: Border.all(
                                color: Colors.grey,
                                width: 1,
                              )),
                              child: Column(
                                children: [
                              Text('보유 사탕',style:Theme.of(context).textTheme.subtitle1),
                                  Text('  ${userModel.saTang} 사탕  ',style:Theme.of(context).textTheme.subtitle1),
                                ],

                              ),
                              )
                            ],
                          ),
                          SizedBox(height: common_small_padding,),
                          (userModel.introduce==null)?Text("자기소개를 \n프로필 편집에서 해보세요!"):Text(userModel.introduce!,),
                          TextButton(
                            child: const Text('프로필 편집'),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) {
                                return  ProfileChangePage(userKey: userModel.userKey);
                              }));
                            },
                          ),
                        ],
                      ),
                   _divider() ])),
                  ),
                  Expanded(
                    child: SliverToBoxAdapter(
                      //slivertoboxadapter 내에는 일반 widget이 오기 때문에 future를 풀어 user_item을 가져오려면 이를 사용하면 된다
                      child: FutureBuilder<List<ItemModel>>(
                        future: ItemService().getUserItems(userModel.userKey),
                        //userKey를 던져줘서 future를 풀어준다
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: common_small_padding),
                              child: Expanded(
                                child: GridView.count(
                                  padding: EdgeInsets.zero,
                                  physics: NeverScrollableScrollPhysics(),
                                  //physics로 따로 gridview로만 scroll이 불가능하도록 해줌
                                  //GridView.count로 좌우로 개수를 지정해줘서 grid한 list 생성해준다
                                  shrinkWrap: true,
                                  // false면 두개가 있을 때 화면을 꽉 채우게 되는데 true로 두면 꽉 차지 않고 원하는 크기 만큼 채워지게 됨
                                  crossAxisCount: 2,
                                  childAspectRatio: 7 / 9,
                                  //가로가 7, 세로가 8
                                  mainAxisSpacing: common_small_padding,
                                  //padding을 main, cross 모두 줘서 공간을 만들어준다
                                  crossAxisSpacing: common_small_padding,
                                  children: List.generate(
                                      snapshot.data!.length,
                                      (index) =>
                                          SimilarItem(snapshot.data![index])),
                                ),
                              ),
                            );
                          }
                          return SizedBox(width:_size.width/4,height:_size.width/4,child: const CircularProgressIndicator()); //없으면 빈 깡통만 던져줌
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
        );
      },
    );
  }

  Widget _divider() {
    return Divider(
      height: common_small_padding * 2 + 1,
      thickness: 2,
      color: Colors.grey[300]!,
    );
  }
}
