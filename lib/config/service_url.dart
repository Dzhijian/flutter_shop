// https://www.easy-mock.com/mock/5d74e9a5361c3507b268f628/shop/homePageContent
// 商店首页信息
//https://baixingliangfan.cn/baixing/bxAppIndex/getHomePageContent?lon=115.075234375&lat=35.776455078125
// 商店首页信息火爆专区
//https://baixingliangfan.cn/baixing/bxAppIndex/getHomePageBelowConten?page=2
// const serviceUrl = 'https://www.easy-mock.com/mock/5d74e9a5361c3507b268f628'; 
// 
/*
 * 分类页面 
 * https://baixingliangfan.cn/baixing/bxAppIndex/getCategory
 * https://baixingliangfan.cn/baixing/bxAppIndex/getMallGoods?categoryId=2c9f6c946cd22d7b016cd73fa6de0038&categorySubId=&page=1
 * https://restapi.amap.com/v3/geocode/regeo?key=bf1f026a38b722b43ca613a8a554d747&custom=26260A1F00020002&scode=26b7f1e505cc084bcd39e0561e801676&ts=1573144532619
 * https://baixingliangfan.cn/baixing/bxAppIndex/getMallGoods?categoryId=2c9f6c946cd22d7b016cd732f0f6002f&categorySubId=&page=1
*/

/*
 *  购物车
 *  https://baixingliangfan.cn/baixing/bxAppIndex/getRecommendGoods
 * 
 * */
const serviceUrl = 'https://baixingliangfan.cn'; 

const servicePath = {
'homePageContent':serviceUrl+'/baixing/bxAppIndex/getHomePageContent',//商店首页信息
'homePageBelowContent':serviceUrl+'/baixing/bxAppIndex/getHomePageBelowConten',//商店首页火爆专区
'getCategory':serviceUrl+'/baixing/bxAppIndex/getCategory',//分类页面
'getMallGoods':serviceUrl+'/baixing/bxAppIndex/getMallGoods',// 商品分类的商品列表


} ; 