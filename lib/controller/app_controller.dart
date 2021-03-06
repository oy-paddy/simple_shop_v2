

import 'package:dd_taoke_sdk/dd_taoke_sdk.dart';
import 'package:dd_taoke_sdk/model/category.dart';
import 'package:dd_tk_shop/service/impl/api_service_impl.dart';
import 'package:get/get.dart';


// 初始化 app 全局属性

class AppController extends GetxController {

  static AppController get instance => Get.find<AppController>();

  final api = ApiService.instance;

  var categorys = RxList<Category>([]);



  @override
  void onInit() {
    loadCategory();
    super.onInit();
  }



  // 加载分类
  void loadCategory() {
    DdTaokeSdk.instance.getCategorys().then((value) {
      categorys.addAllIf(value!=null && value.isNotEmpty, value);
    });
  }

}