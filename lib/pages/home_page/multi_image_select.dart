import 'package:provider/provider.dart';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test2/constants/common_size.dart';
import 'package:test2/states/select_image_notifier.dart';

class MultiImageSelect extends StatefulWidget {
   MultiImageSelect({Key? key}) : super(key: key);

  @override
  _MultiImageSelectState createState() => _MultiImageSelectState();
}

class _MultiImageSelectState extends State<MultiImageSelect> {
  bool _isPickingImages=false;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      SelectImageNotifier selectImageNotifier=context.watch<SelectImageNotifier>();
      Size _size = MediaQuery
          .of(context)
          .size;
      var imageSize = (_size.width / 3) - common_padding * 2;
      var imageCorner = 16.0;
      return SizedBox(
          height: _size.width / 3,
          width: _size.width,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              Padding(
                padding: const EdgeInsets.all(common_padding),
                child: InkWell(
                  onTap: () async { //갤러리에서 이미지 가져오기
                    _isPickingImages = true;
                    setState(() {

                    });
                    final ImagePicker _picker = ImagePicker();
                    final List<XFile>? images = await _picker.pickMultiImage(
                       imageQuality: 10);
                    if (images!=null&&images.isNotEmpty){
                     await context.read<SelectImageNotifier>().setNewImages(images);
                    }
                    _isPickingImages = false;
                    setState(() {

                    });
                  },
                  child: Container(
                      child: _isPickingImages ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      ) : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.grey,
                          ),
                          Text(
                            '${selectImageNotifier.images.length}/10',
                            style: Theme
                                .of(context)
                                .textTheme
                                .subtitle2,
                          )
                        ],
                      ),
                      width: imageSize,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(imageCorner),
                          border: Border.all(
                            color: Colors.grey,
                            width: 1,
                          ))),
                ),
              ),
              ...List.generate(
                  selectImageNotifier.images.length,
                      (index) =>
                      Stack(
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(
                                  right: common_padding,
                                  top: common_padding,
                                  bottom: common_padding),
                              child: ExtendedImage.memory( //메모리에 있는 이미지 가져오기
                                selectImageNotifier.images[index],
                                width: imageSize,
                                height: imageSize,
                                fit: BoxFit.cover,
                                //image를 꽉차게 보이도록
                                loadStateChanged: (
                                    state) { //사진 가져올때 기다리는 시간이 있을 수 도 있으므로 loading 상태변화
                                  switch (state.extendedImageLoadState) {
                                    case LoadState.loading:
                                      return Container(width: imageSize,
                                          height: imageSize,
                                          padding: EdgeInsets.all(
                                              imageSize / 3),
                                          child: CircularProgressIndicator());
                                    case LoadState.completed:
                                      return null;
                                    case LoadState.failed:
                                      return Icon(Icons.cancel);
                                  }
                                },
                                borderRadius: BorderRadius.circular(
                                    imageCorner),
                                shape: BoxShape.rectangle,
                              )
                          ),
                          Positioned( //stack안에서만 positioned 사용할 수 있음
                              right: 0,
                              top: 0,
                              width: 40,
                              //사이즈 지정, 원래 사이즈 24, 24+8+8(위 아래 패딩 생각), 클릭 시 어느정도 클릭(패딩)되는지도 개발시 생각필요!
                              height: 40,
                              //사이즈 지정
                              child: IconButton(
                                padding: EdgeInsets.all(8),
                                onPressed: () {
                                  selectImageNotifier.removeImage(index);
                                },
                                icon: Icon(Icons.remove_circle),
                                color: Colors.black54,
                              ))
                        ],
                      )) //...은 List안에 List 병합하기
            ],
          ));
    });

  }
}
