import 'package:flutter/material.dart';

CategoryNotifier categoryNotifier=CategoryNotifier();

class CategoryNotifier extends ChangeNotifier{
  String _selectCategory='선택';
  String get currentCategory=>_selectCategory;


  void setNewCategory(String newCategory){
    if(categories.contains(newCategory)){
      _selectCategory=newCategory;
      notifyListeners();
    }
  }


 static const List<String> categories= [
    '선택', '썸', '짝사랑', '권태기', '헤어짐', '기타'
  ];
}