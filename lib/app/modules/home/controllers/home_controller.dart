import 'package:get/get.dart';

class HomeController extends GetxController {
  var selectedCategory = ''.obs; // Tracks the selected category

  final List<Map<String, String>> categories = [
    {'name': 'TV', 'image': 'assets/images/tv.png'},
    {'name': 'Headphones', 'image': 'assets/images/audio.png'},
    {'name': 'Laptop', 'image': 'assets/images/laptop.png'},
    {'name': 'Mobile', 'image': 'assets/images/mobile.png'},
    {'name': 'Gaming', 'image': 'assets/images/gaming.png'},
  ];

  // Method to update the selected category
  void setSelectedCategory(String category) {
    selectedCategory.value = category;
  }
}