import 'package:flutter/material.dart';
import '../model/category.dart';


class ChildCategory with ChangeNotifier{
  
  List<BxMallSubDto> childCategoryList = [];
  int childIndex = 0; //子类选中索引
  String categoryId = '2c9f6c946cd22d7b016cd732f0f6002f'; // 大类的 ID
  String subId = '';  // 小类 ID

  getChildCategory(List<BxMallSubDto> list,String id){
    
    childIndex = 0;//每次点击大类,子类的索引清0
    categoryId = id;

    BxMallSubDto all = BxMallSubDto();
    all.mallSubId = '00';
    all.mallSubName = '全部';
    all.mallCategoryId = '00';
    all.comments = 'null';
    
    childCategoryList = [all];
    childCategoryList.addAll(list);
    // 发送通知
    notifyListeners();
  }

  // 改变子类索引
  changeChildIndex(index,String subId){
    childIndex = index;
    subId = subId;
    notifyListeners();
  }

}