import 'package:flutter/material.dart';
import '../service/service_method.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'dart:convert';
// 屏幕适配
import 'package:flutter_screenutil/flutter_screenutil.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String homePageContent = '正在获取数据....';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('百姓生活+')),
      //  FutureBuilder 异步加载数据后刷新页面
      body:FutureBuilder(
        future: getHomePageContent(),
        builder: (context,snapshort){
          if(snapshort.hasData){
            var data = json.decode(snapshort.data.toString());
            List<Map> swiperList = (data['data']['slides'] as List).cast(); 
            List<Map> navigatorList = (data['data']['category'] as List).cast(); 

            return Column(
              children: <Widget>[
                SwiperDiy(swiperDataList: swiperList),
                TopNavigator(navigatorList: navigatorList)
              ],
            );
          }else{
            return Center(
              child: Text('没有数据'),
            );
          }
        }
      )
    );
  }
}

// 首页轮播图组件
class SwiperDiy extends StatelessWidget {
  final List swiperDataList;
  SwiperDiy({this.swiperDataList});

  @override
  Widget build(BuildContext context) {
    
    return Container(
      // 屏幕适配
      height: ScreenUtil().setHeight(333),
      child: Swiper(
        itemBuilder: (BuildContext context, int index){
          return Image.network("${swiperDataList[index]['image']}",fit: BoxFit.fill);
        },
        itemCount: swiperDataList.length,
        // page 页码
        pagination: SwiperPagination(),
        // 是否自动播放
        autoplay: true,
      ),
    );
  }
}

// 导航按钮
class TopNavigator extends StatelessWidget {
  
  final List navigatorList;
  TopNavigator({this.navigatorList});
  
  Widget _gridViewItemUI(BuildContext context,item){
    
    return InkWell(
      onTap: (){print('点击了导航');},
      child: Column(
        children: <Widget>[
          Image.network(item['image'],width:ScreenUtil().setWidth(95)),
          Text(item['mallCategoryName']),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    if( this.navigatorList.length > 10 ){
      this.navigatorList.removeRange(10, this.navigatorList.length);
    }
    return Container(
      height: ScreenUtil().setHeight(320),
      padding: EdgeInsets.all(3.0),
      child: GridView.count(
        crossAxisCount: 5,
        padding: EdgeInsets.all(5.0),
        children: navigatorList.map((item){
          return _gridViewItemUI(context, item);
        }).toList(),
      ),
    );
  }
}

