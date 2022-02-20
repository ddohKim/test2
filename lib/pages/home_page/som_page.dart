import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:test2/constants/common_size.dart';
import 'package:test2/data/item_model.dart';
import 'package:test2/pages/home_page/som_detail_page.dart';
import 'package:test2/repository/item_service.dart';
import 'package:test2/widgets/time_calculator.dart';

class SomPage extends StatelessWidget {
  const SomPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      //화면 사이즈를 가져오려고
      builder: (context, constraints) {
        Size size = MediaQuery
            .of(context)
            .size;
        final imgSize = size.width / 4;
        return FutureBuilder<List<ItemModel>>(
            future: ItemService().getItems(),
            builder: (context, snapshot) {
              return AnimatedSwitcher(
                  duration: Duration(milliseconds: 700),
                  child: (snapshot.hasData && snapshot.data!.isNotEmpty)
                      ? _listView(imgSize, snapshot.data!)
                      : _shimmerListView(imgSize));
            });
      });
            }

  ListView _listView(double imgSize, List<ItemModel> items) {
    return ListView.separated(
      shrinkWrap: true,
      //scroll가능한 ListView
      padding: EdgeInsets.all(common_padding),
      separatorBuilder: (context, index) {
        return Divider(
          height: common_padding * 2 + 1,
          thickness: 1,
          color: Colors.grey,
        );
      },
      itemBuilder: (context, index) {
        ItemModel item = items[items.length-index-1]; //reverse
        return InkWell(
          //클릭을 하도록 만들어줌
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (BuildContext context) {
              return SomDetailScreen(
                itemKey: item.itemKey,
              );
            }));
            //context.beamToNamed('/$LOCATION_ITEM/:${item.itemKey}');
          },
          child: SizedBox(
            height: imgSize, //피드 한개 사이즈 높이 지정
            child: Row(
              children: [
                SizedBox(
                    width: imgSize,
                    height: imgSize,
                    child:
                    item.imageDownloadUrls.isEmpty?Icon(Icons.clear,size: 70,):item.secret==false?ExtendedImage.network(
                        item.imageDownloadUrls[0],
                        fit: BoxFit.cover,
                        shape: BoxShape.rectangle, //shape를 줘야 borderradious가 만들어짐
                        borderRadius: BorderRadius.circular(12),
                      ):Icon(Icons.lock,size: 70,)),
                SizedBox(
                  width: common_small_padding,
                ),
                Expanded(
                  //Expanded를 이용해 나머지 부분을 전부 차지하도록
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                item.secret==false?item.title:'비밀글입니다!',
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                            ),
                            Text('카테고리: ${item.category}',style: Theme.of(context).textTheme.subtitle2,),
                          ],
                        ),
                        Text(""),
                        Text(item.secret==false?
                        item.detail.length>20?
                            '${item.detail.substring(0,20)}...':'${item.detail}':"",style: Theme.of(context).textTheme.subtitle2),
                        Expanded(child: Container()),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '∙ ${TimeCalculator().getTimeDiff(item.createdDate)} ∙',
                              style: Theme.of(context).textTheme.subtitle2,
                            ),
                            SizedBox(
                              height: 18,
                              child: FittedBox(
                                //sizedBox에 튀어 나오지 않게 해줌,글자크기를 한번에 줄이기 위해서! sizedbox를 이용해서 만들어봄
                                fit: BoxFit.fitHeight,
                                child: Row(
                                  children: [
                                    Icon(
                                      CupertinoIcons.chat_bubble_2,
                                      color: Colors.grey,
                                    ),
                                    Text(
                                      '23',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    Icon(
                                      CupertinoIcons.heart,
                                      color: Colors.grey,
                                    ),
                                    Text(
                                      '30',
                                      style: TextStyle(color: Colors.grey),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    )),
              ],
            ),
          ),
        );
      },
      itemCount: items.length,
    );
  }

  Widget _shimmerListView(double imgSize) {
    return Shimmer.fromColors(
      //로딩이 반투명하게 보이도록
      baseColor: Colors.grey[300]!, //색깔이 있을지 없을지 모르기 때문에 ! 찍어줌
      highlightColor: Colors.grey[100]!,
      enabled: true,
      child: ListView.separated(
        //scroll가능한 ListView
        padding: EdgeInsets.all(common_padding),
        separatorBuilder: (context, index) {
          return Divider(
            height: common_padding * 2 + 1,
            thickness: 1,
            color: Colors.grey,
            indent: common_small_padding,
            endIndent: common_small_padding,
          );
        },
        itemBuilder: (context, index) {
          return SizedBox(
            height: imgSize, //피드 한개 사이즈 높이 지정
            child: Row(
              children: [
                Container(
                  width: imgSize,
                  height: imgSize,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(12)),
                ),
                //random image
                SizedBox(
                  width: common_small_padding,
                ),
                Expanded(
                  //Expanded를 이용해 나머지 부분을 전부 차지하도록
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            height: 14,
                            width: 180,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(3))),
                        SizedBox(
                          height: 8,
                        ),
                        Container(
                            height: 12,
                            width: 100,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(3))),
                        SizedBox(
                          height: 8,
                        ),
                        Container(
                            height: 14,
                            width: 150,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(3))),
                        Expanded(child: Container()),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                                height: 16,
                                width: 80,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(3))),
                          ],
                        )
                      ],
                    )),
              ],
            ),
          );
        },
        itemCount: 10,
      ),
    );
  }
}