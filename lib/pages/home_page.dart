import 'package:flutter/material.dart';
import '../service/service_method.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String homePageContent = '正在获取数据';
  // @override
  //   void initState() {
  //     // 获取首页数据
  //     getHomePageContent().then((val){
  //       setState(() {
  //         homePageContent = val.toString();
  //         // print(homePageContent);
  //       });
  //     });
  //     super.initState();
  //   }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('百姓生活+')),
      body:FutureBuilder(
        future: getHomePageContent(),
        builder: (context,snapshort){
          print('snapshort------> ${snapshort.data}');
          if(snapshort.hasData){
            var data = json.decode(snapshort.data.toString());
            List<Map> swiperList = (data['data']['slides'] as List).cast(); 
            print("swiperList ===> ${swiperList}");
            return Column(
              children: <Widget>[
                SwiperDiy(swiperDataList: swiperList)
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
      height: 333,
      child: Swiper(
        itemBuilder: (BuildContext context, int index){
          print('image-->${swiperDataList[index]['image']}');
          return Image.network("${swiperDataList[index]['image']}",fit: BoxFit.fill);
        },
        itemCount: swiperDataList.length,
        // page 页码
        pagination: SwiperPagination(),
        // 自动播放
        autoplay: true,
      ),
    );
  }
}