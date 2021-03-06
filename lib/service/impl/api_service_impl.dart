import 'package:dd_taoke_sdk/model/product.dart';
import 'package:dd_tk_shop/constant/api_constant.dart';
import 'package:dd_tk_shop/model/product_detail_model.dart';
import 'package:dd_tk_shop/model/taobao_detail_info.dart';
import 'package:dd_tk_shop/model/tkl_model.dart';
import 'package:dd_tk_shop/model/topic_model.dart';
import 'package:dd_tk_shop/util/extended_util.dart';
import 'package:dd_tk_shop/util/net/network/http_request.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

/// 接口服务实现
class ApiService extends GetxService{
  final box = GetStorage();
  static ApiService get instance => Get.find<ApiService>();

  Future<List<Topic>> getTopics() async {
    final response = await HttpRequest.req(DTK_API + '/topic');
    if (response.isNotEmpty) return topicFromJson(response);
    return [];
  }

  Future<List<Product>> getTopList(int rankType,
      {int pageId, int pageSize, int cid}) async {
    var params = Map<String, String>();
    params["rankType"] = "$rankType";
    if (pageId != null) params["pageId"] = "$pageId";
    if (pageSize != null) params["pageSize"] = "$pageSize";
    if (cid != null) params["cid"] = "$cid";
    final response = await HttpRequest.req(DTK_API + "/top", data: params);
    return response.isNotEmpty && response != null
        ? productFromJson(response)
        : [];
  }

  Future<ProductDetail> detail({String id, String goodsId}) async {
    var params = Map<String, String>();
    if (id != null) params["id"] = id;
    if (goodsId != null) params["goodsId"] = goodsId;
    final response = await HttpRequest.req(DTK_API + "/detail", data: params);
    return productDetailFromJson(response);
  }

  Future getComments(String id) async {
    final response =
        await HttpRequest.req(DTK_API + "/comment", data: {"id": id});
    return response;
  }

  Future<List<Product>> getLikeProducts(String id, int size) async {
    final response = await HttpRequest.req("$DTK_API/similar",
        data: {"id": id, "size": '$size'});
    return response.isNotEmpty && response != null
        ? productFromJson(response)
        : [];
  }

  Future<TklModel> createTkl(String text, String url,
      {String userId = "", String logo = ""}) async {
    var map = Utils().initParamsMap();
    map["text"] = text;
    map["url"] = Uri.encodeComponent(url);
    map["userId"] = userId;
    map["logo"] = logo;
    final response = await HttpRequest.req('$DTK_API/create-tkl', data: map);
    return response.isNotEmpty && response != null
        ? tklModelFromJson(response)
        : null;
  }

  Future createTklWithTaobao(String text, String url,
      {String userId, String logo}) async {
    var map = Utils().initParamsMap();
    map["text"] = text;
    map["url"] = Uri.encodeComponent(url);
    map["userId"] = userId;
    map["logo"] = logo;
    final response =
        await HttpRequest.req("$DTK_API/tpwd", data: map, showLog: true);
    // 失败返回:{"error_response":{"code":15,"msg":"Remote service error","sub_code":"20000","sub_msg":"口令跳转url不支持口令转换","request_id":"4pppcugj30xh"}}
    return response;
  }

  Future<TaobaoDetailInfo> getInfo(String goodsId) async {
    var map = Utils().initParamsMap();
    map["goodsId"] = goodsId;
    final response = await HttpRequest.req(
      '$DTK_API/tb-getInfo',
      data: map,
    );
    if (response.isNotEmpty && response != null) {
      return taobaoDetailInfoFromJson(response);
    }
    return null;
  }


}
