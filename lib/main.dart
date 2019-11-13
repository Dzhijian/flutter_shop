import 'package:flutter/material.dart';
import './pages/index_page.dart';
import './provider/child_category.dart';
import 'package:provider/provider.dart';

void main(){
  var childCategory = ChildCategory();
  runApp(
    ChangeNotifierProvider<ChildCategory>.value(
      value: childCategory,
      child: MyApp()
    ),
  );
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
        home: IndexPage(),
      ),
    );
  }
}