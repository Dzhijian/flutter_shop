import 'package:flutter/material.dart';
import '../service/service_method.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'dart:convert';
// 屏幕适配
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin{
  
  @override
    void initState() {
      // TODO: implement initState
      super.initState();
      print('首页');
    }
  // 保持页面状态
  @override
  bool get wantKeepAlive => true;

  

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
            // 轮播图
            List<Map> swiperList = (data['data']['slides'] as List).cast(); 
            // 导航按钮数据
            List<Map> navigatorList = (data['data']['category'] as List).cast(); 
            // 广告图片
            String adPicture = data['data']['advertesPicture']['PICTURE_ADDRESS'];
            // 店长图片与店长店长电话
            String leaderImage = data['data']['shopInfo']['leaderImage'];
            String leaderPhone = data['data']['shopInfo']['leaderPhone'];
            // 商品推荐数据
            List<Map> recommendList = (data['data']['recommend'] as List).cast(); 
            String floor1Title = data['data']['floor1Pic']['PICTURE_ADDRESS'];
            String floor2Title = data['data']['floor2Pic']['PICTURE_ADDRESS'];
            String floor3Title = data['data']['floor3Pic']['PICTURE_ADDRESS'];
            List<Map> floor1  = (data['data']['floor1'] as List).cast();
            List<Map> floor2  = (data['data']['floor2'] as List).cast();
            List<Map> floor3  = (data['data']['floor3'] as List).cast();

            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SwiperDiy(swiperDataList: swiperList),
                  TopNavigator(navigatorList: navigatorList),
                  AdBanner(adPicture:adPicture),
                  LeaderPhone(leaderImage: leaderImage,leaderPhone: leaderPhone),
                  Recommend(recommendList:recommendList),
                  
                  FloorTitle(picture_address:floor1Title),
                  FloorContent(floorGoodsList:floor1),

                  FloorTitle(picture_address:floor2Title),
                  FloorContent(floorGoodsList:floor2),
                  
                  FloorTitle(picture_address:floor3Title),
                  FloorContent(floorGoodsList:floor3),
                  
                ],
              ),
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

// 广告位区域
class AdBanner extends StatelessWidget {
  
  final String adPicture;
  AdBanner({this.adPicture});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.network(adPicture),
    );
  }
}

// 店长电话模块
class LeaderPhone extends StatelessWidget {
  final String leaderImage;   // 店长图片
  final String leaderPhone;   // 店长电话
  LeaderPhone({this.leaderImage,this.leaderPhone});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: _launchURL,
        child: Image.network(leaderImage),
      ),
    );
  }
  // 拨打电话☎️
  void _launchURL() async {
    String url = 'tel:'+leaderPhone;
    if (await canLaunch(url)) {
      await launch(url);
    }else{
      throw 'url不能进行访问,异常';
    }
  }
}

// 商品推荐类
class Recommend extends StatelessWidget {
  final List recommendList;
  Recommend({this.recommendList});

  // 标题方法
  Widget _titleWidget(){
    return Container(
      // 居中靠左对齐
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(10.0, 2.0, 0, 5.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(width: 0.5,color: Colors.black12)
        )
      ),
      child: Text(
        '商品详情',
        style: TextStyle(color: Colors.pink),
      ),
    );
  }

  // 商品 Item 方法
  Widget _item(index){
    return InkWell(
      onTap: (){},
      child: Container(
        height: ScreenUtil().setHeight(330),
        width: ScreenUtil().setWidth(250),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            left: BorderSide(width: 0.5,color: Colors.black12)
          )
        ),
        child: Column(
          children: <Widget>[
            Image.network(recommendList[index]['image']),
            Text('¥${recommendList[index]['mallPrice']}'),
            Text(
              '¥${recommendList[index]['price']}',
              style: TextStyle(
                decoration: TextDecoration.lineThrough,
                color: Colors.grey
              ),
              ),
          ],
        ),
      ),
    );
  } 

  // 横向列表方法
  Widget _recommendList(){
    return Container(
      height: ScreenUtil().setHeight(330),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recommendList.length,
        itemBuilder:(context,index){
          return _item(index);
        },
      ),
    );
  } 
  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(390),
      margin: EdgeInsets.only(top: 10.0),
      child: Column(
        children: <Widget>[
          _titleWidget(),
          _recommendList()
        ],
      ),
    );
  }
}

// 楼层标题
class FloorTitle extends StatelessWidget {
  
  final String picture_address;
  FloorTitle({this.picture_address});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Image.network(picture_address),
    );
  }
}

// 楼层商品列表
class FloorContent extends StatelessWidget {
  final List<Map> floorGoodsList;
  FloorContent({this.floorGoodsList});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          _firstRow(),
          _otherGoods()
        ],
      ),
    );
  }

  Widget _firstRow(){
    return Row(
      children: <Widget>[
        _goodsItem(floorGoodsList[0]),
        Column(
          children: <Widget>[
            _goodsItem(floorGoodsList[1]),
            _goodsItem(floorGoodsList[2]),
          ],
        )
      ],
    );
  }

  Widget _otherGoods(){
    return Row(
      children: <Widget>[
            _goodsItem(floorGoodsList[3]),
            _goodsItem(floorGoodsList[4])
      ],
    );
  }

  Widget _goodsItem(Map goods){
    return Container(
      width: ScreenUtil().setWidth(375),
      child: InkWell(
        onTap: (){print('点击了楼层商品');},
        child: Image.network(goods['image']),
      ),
    );
  }
}
