import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SelectImageNotifier extends ChangeNotifier{
  final List<Uint8List> _images=[];
    Uint8List? _image;

  Future setNewImages(List<XFile>? newImages) async{
    if(newImages!=null&&newImages.isNotEmpty){
        _images.clear();
        for(int index=0;index<newImages.length;index++){
          _images.add(await newImages[index].readAsBytes());
        }
      notifyListeners();
    }
  }

  Future setUpdateImage(XFile? newImage) async{
    if(newImage!=null){
       _image=await newImage.readAsBytes();
      notifyListeners();
    }
  }



  void removeImage(int index){
    if(_images.length>=index){
      _images.removeAt(index);
      notifyListeners();
    }
  }
  List<Uint8List> get images=>_images;
  Uint8List? get image=>_image;
}