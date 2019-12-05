import 'package:flutter/material.dart';
import './pages/index_page.dart';
import './provider/child_category.dart';
import 'package:provider/provider.dart';
import './provider/category_goods_list.dart';

void main(){
  var childCategory = ChildCategory();
  var categoryGoodsListProvoder = CategoryGoodsListProvide();
  
  List<SingleChildCloneableWidget> providers = []; 
  
  providers
    ..add(ChangeNotifierProvider.value(value:childCategory))
    ..add(ChangeNotifierProvider.value(value:categoryGoodsListProvoder));


  runApp(MultiProvider(providers: providers,child:MyApp()));
} 

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: MaterialApp(
        title: '百姓生活+',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.pink
        ),
        // home: ChangeNotifierProvider(
        //   builder: (context) => CurrentIndexProvide(),
        //   child: IndexPage(),
        // ),
        home: IndexPage(),
      ),
    );
  }
}