import 'package:flutter/material.dart';
import '../service/service_method.dart';
import 'dart:convert';
import '../model/category.dart';
import '../model/categoryGoodsList.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../provider/child_category.dart';
import '../provider/category_goods_list.dart';


class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
     
    return Scaffold(
      appBar: AppBar(title: Text('商品分类'),),
      body: Container(
        child: Row(
          children: <Widget>[
            LeftCategoryNav(),
            Column(
              children: <Widget>[
                RightCategoryNav(),
                CategoryGoodsList()
              ],
            )
          ],
        ),
      ),
    );
  }

}

// 左侧类别导航 
class LeftCategoryNav extends StatefulWidget {
  @override
  _LeftCategoryNavState createState() => _LeftCategoryNavState();
}

class _LeftCategoryNavState extends State<LeftCategoryNav> {
  List list = [];
  var listIndex = 0;

  @override
    void initState() {
      _getCategory();
      _getGoodsList();
      super.initState();
    }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(180),
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(width: 1,color: Colors.black12)
        )
      ),
      child: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context,index){
          return _leftInkWell(index);
        },
      ),
    );
  }

  Widget _leftInkWell(int index){
    bool isClick = false;
    isClick = (index == listIndex) ? true : false;
    return InkWell(
      onTap: (){
        setState(() {
                  listIndex = index;
                });
        var childList = list[index].bxMallSubDto;
        var categoryId = list[index].mallCategoryId;
        // print('categoryId:${categoryId}');
        Provider.of<ChildCategory>(context).getChildCategory(childList,categoryId);
        _getGoodsList(categoryId:categoryId);
      },
      child: Container(
        height: ScreenUtil().setHeight(100),
        padding: EdgeInsets.only(left: 10,top:20),
        decoration: BoxDecoration(
          color: isClick ? Color.fromRGBO(236, 236, 236, 1.0) : Colors.white,
          border: Border(
            bottom: BorderSide(width: 1,color: Colors.black12)
          ),
        ),
        child: Text(list[index].mallCategoryName,style:TextStyle(fontSize: ScreenUtil().setSp(28))),
      ),
    );
  }

  void _getCategory() async {
    await request('getCategory').then((val){
      var data = json.decode(val.data.toString());
      CategoryModel category = CategoryModel.fromJson(data);
      setState(() {
              list = category.data;
            });
      Provider.of<ChildCategory>(context).getChildCategory(list[0].bxMallSubDto,list[0].mallCategoryId);      
    });
  }


   void _getGoodsList({String categoryId}) async{
    var data = {
      'categoryId': categoryId == null ? '2c9f6c946cd22d7b016cd732f0f6002f' : categoryId, //'2c9f6c946cd22d7b016cd73fa6de0038',
      'categorySubId':"",
      'page':1
    };

    request('getMallGoods',parameters: data).then((val){
      var data = json.decode(val.data.toString());
      CategoryGoodsListModel goodList = CategoryGoodsListModel.fromJson(data);
      Provider.of<CategoryGoodsListProvide>(context).getGoodsList(goodList.data);      

    });

  }
}

class RightCategoryNav extends StatefulWidget {
  @override
  _RightCategoryNavState createState() => _RightCategoryNavState();
}

class _RightCategoryNavState extends State<RightCategoryNav> {
  
  @override
  Widget build(BuildContext context) {
    
    ChildCategory childCategory = Provider.of<ChildCategory>(context);
    return Container(
      height: ScreenUtil().setHeight(80),
      width: ScreenUtil().setWidth(570),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(width: 1,color: Colors.black12)
        )
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: childCategory.childCategoryList.length,
        itemBuilder: (context,index){
          return _rightInkWell(childCategory.childCategoryList[index],index);
        },
      ),
    );
  }

  Widget _rightInkWell(BxMallSubDto item,int index){
    ChildCategory childCategory = Provider.of<ChildCategory>(context);

    bool isClick = false;
    isClick = (index == childCategory.childIndex) ? true : false;
    return InkWell(
      onTap: (){
        childCategory.changeChildIndex(index,item.mallSubId);
        _getGoodsList(item.mallSubId);
      },

      child: Container(
        padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
        child: Text(
          item.mallSubName,
          style: TextStyle(
            fontSize: ScreenUtil().setSp(28),
            color: isClick ? Colors.pink : Colors.black
            ),
        ),
      ),
    );
  }
  void _getGoodsList(String categorySubId) async{
    var data = {
      'categoryId':  Provider.of<ChildCategory>(context).categoryId,
      'categorySubId':categorySubId,
      'page':1
    };

    request('getMallGoods',parameters: data).then((val){
      var data = json.decode(val.data.toString());
      CategoryGoodsListModel goodList = CategoryGoodsListModel.fromJson(data);
      if (goodList.data == null){
        // 如果数据为空 传一个空的数组过去,不然会报错
        Provider.of<CategoryGoodsListProvide>(context).getGoodsList([]);      
      }else{
        Provider.of<CategoryGoodsListProvide>(context).getGoodsList(goodList.data);      
      }
    });

  }
}

//商品列表
class CategoryGoodsList extends StatefulWidget {
  @override
  _CategoryGoodsListState createState() => _CategoryGoodsListState();
}

class _CategoryGoodsListState extends State<CategoryGoodsList> {
  // List list =[];

  @override
    void initState() {
      super.initState();
    }
  @override 
  Widget build(BuildContext context) {

    CategoryGoodsListProvide goodsListProvide = Provider.of<CategoryGoodsListProvide>(context);
    if (goodsListProvide.goodsList.length > 0){
      return Expanded(
        child: Container(
          width: ScreenUtil().setWidth(570),
          child: ListView.builder(
            itemCount: goodsListProvide.goodsList.length,
            itemBuilder: (context,index){
              return _listWidget(goodsListProvide.goodsList,index);
            },
          ),
        ),
      );
    }else{
      return Text('暂时没有数据');
    }
  }
 

  Widget _goodsImage(List newList, index){
    return Container(
      width: ScreenUtil().setWidth(200),
      child: Image.network(newList[index].image),
    );
  }

  Widget _goodsName(List newList,index){
    return Container(
      padding: EdgeInsets.all(5.0),
      width: ScreenUtil().setWidth(370),
      child: Text(
        newList[index].goodsName,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: ScreenUtil().setSp(28)),
      ),
    );
  }

  Widget _goodsPrice(List newList,index){
    return Container(
      margin: EdgeInsets.only(top: 20.0),
      width: ScreenUtil().setWidth(370),
      child: Row(
        children: <Widget>[
          Text(
            '价格: ¥${newList[index].presentPrice}',
            style: TextStyle(color: Colors.pink,fontSize: ScreenUtil().setSp(30)),
          ),
          Text(
            '${newList[index].oriPrice}',
            style: TextStyle(color: Colors.black26,decoration: TextDecoration.lineThrough),
          ),
        ],
      )
    );
  }

  Widget _listWidget(List newList,int index){
    return InkWell(
      onTap: (){},
      child: Container(
        padding: EdgeInsets.only(top: 5.0,bottom: 5.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(width: 1.0,color: Colors.black12)
          )
        ),
        child: Row(
          children: <Widget>[
            _goodsImage(newList,index),
            Column( 
              children: <Widget>[ 
                _goodsName(newList,index),
                _goodsPrice(newList,index)
              ],
            )
          ],
        ),
      ),
    );
  }
}