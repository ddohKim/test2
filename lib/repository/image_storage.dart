import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ImageStorage {
  static Future<List<String>> uploadImages(List<Uint8List> images,String itemKey) async {

    var metaData = SettableMetadata(contentType: 'image/jpeg'); //파일 형태를 jpg로 바꾸는 법

    List<String> downloadUrls=[];

    for (int i = 0; i < images.length; i++) {
      Reference ref =
          FirebaseStorage.instance.ref('images/$itemKey/$i.jpg');
      if (images.isNotEmpty) await ref.putData(images[i], metaData).catchError((onError){
        print('$onError.toString()');
      });
      downloadUrls.add(await ref.getDownloadURL());
    }
  return downloadUrls;
  }

  static Future<String> uploadProfileImage(Uint8List image,String userKey) async {

    var metaData = SettableMetadata(contentType: 'profileImage/jpeg'); //파일 형태를 jpg로 바꾸는 법
String downloadUrl;


      Reference ref =
      FirebaseStorage.instance.ref('profileImage/$userKey.jpg');
      if (image.isNotEmpty) await ref.putData(image, metaData).catchError((onError){
        print('$onError.toString()');
      });
      downloadUrl=await ref.getDownloadURL();

    return downloadUrl;
  }


}
