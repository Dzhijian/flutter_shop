import 'package:dio/dio.dart';
import 'dart:async';
import 'dart:io';
import '../config/service_url.dart';

// 获取首页主题内容
Future getHomePageContent() async {
  try{
    print('开始获取首页数据');
    Response response;
    Dio dio = new Dio();
    dio.options.contentType = ContentType.parse("application/x-www-form-urlencoded");
    var formData = {'lon':'113.890427','lat':'22.560033'};
    response = await dio.get(servicePath['homePageContent'],queryParameters:formData);
    if(response.statusCode==200){
      return response;
    }else{
      throw Exception('后端接口出现异常');
    }
  }catch(e){
    return print('Error: ======>${e}');
  }
  
}