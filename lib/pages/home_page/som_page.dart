import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:test2/constants/common_size.dart';

class SomPage extends StatelessWidget {
  const SomPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      //화면 사이즈를 가져오려고
      builder: (context, constraints) {
        Size size = MediaQuery.of(context).size;
        final imgSize = size.width / 4;
        return _shimmerListView(imgSize);
            }
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