import 'package:flutter/material.dart';

ReportToManagerNotifier reportToManagerNotifier=ReportToManagerNotifier();

class ReportToManagerNotifier extends ChangeNotifier{
  String _selectCategory='선택';
  String get currentCategory=>_selectCategory;


  void setNewReport(String report){
    if(report.contains(report)){
      _selectCategory=report;
      notifyListeners();
    }
  }


  static const List<String> report= [
    '광고', '비어있는 글', '범죄성 글','기타'
  ];
}