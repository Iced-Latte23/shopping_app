import 'package:get/get.dart';

class ProductDetailController extends GetxController {
  var product = {}.obs;

  @override
  void onInit() {
    final productData = Get.arguments;
    if (productData != null) {
      product.value = productData;
    }
    super.onInit();
  }
}
