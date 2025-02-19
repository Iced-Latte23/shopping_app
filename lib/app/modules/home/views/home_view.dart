import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/bottom_nav_bar.dart';
import '../controllers/home_controller.dart';
import 'package:final_project/app/data/controller/product_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({super.key});

  final productController = Get.put(ProductController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // Sticky Category Section with Search Field
          SliverPersistentHeader(
            pinned: true, // Makes the header sticky
            delegate: _StickyCategoryHeaderWithSearch(
              categories: controller.categories,
              selectedCategory: controller.selectedCategory,
              onCategoryTap: (category) {
                controller.setSelectedCategory(category);
              },
            ),
          ),

          // Product Grid View
          Obx(() {
            if (productController.filterProducts.isEmpty) {
              return SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()));
            }
            return SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.7,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    var product = productController.filterProducts[index];
                    return GestureDetector(
                      onTap: () {
                        Get.offNamed(Routes.PRODUCT_DETAIL, arguments: {'product': product, 'backRoute': '/home'});
                      },
                      child: Card(
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side:
                              BorderSide(color: Colors.grey[300]!, width: 0.5),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Product Image with Hero Animation
                            Expanded(
                              child: Hero(
                                tag: product.id,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(15),
                                  ),
                                  child: Stack(
                                    children: [
                                      // Product Image
                                      Image.network(
                                        product.image,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Center(
                                            child: Icon(
                                              Icons
                                                  .image_not_supported_outlined,
                                              size: 30,
                                              color: Colors.red,
                                            ),
                                          );
                                        },
                                      ),
                                      // Favorite Icon in the Top-Right Corner
                                      Positioned(
                                        top: 8,
                                        right: 8,
                                        child: Obx(() {
                                          return GestureDetector(
                                            onTap: () async {
                                              final userId = Supabase.instance
                                                  .client.auth.currentUser?.id;
                                              if (userId == null) {
                                                print("User not logged in!");
                                                return;
                                              }

                                              // Toggle favorite state
                                              await productController
                                                  .toggleFavorite(product.id);
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                color: Colors.grey
                                                    .withOpacity(0.4),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Icon(
                                                productController
                                                        .isFavorite(product.id)
                                                    ? Icons.favorite
                                                    : Icons.favorite_border,
                                                color: productController
                                                        .isFavorite(product.id)
                                                    ? Colors.red
                                                    : Colors.white,
                                                size: 18,
                                              ),
                                            ),
                                          );
                                        }),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // Product Details
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Text(
                                        '\$${product.price.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                        ),
                                      ),
                                      const Spacer(),
                                      Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '4.5',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: productController.filterProducts.length,
                ),
              ),
            );
          }),
        ],
      ),
      bottomNavigationBar: StyledBottomNavigationBar(index: 0),
    );
  }
}

// Delegate for Sticky Category Header with Search Field
class _StickyCategoryHeaderWithSearch extends SliverPersistentHeaderDelegate {
  final List<Map<String, String>> categories;
  final RxString selectedCategory; // Reactive variable
  final Function(String) onCategoryTap;

  _StickyCategoryHeaderWithSearch({
    required this.categories,
    required this.selectedCategory,
    required this.onCategoryTap,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.only(left: 20, right: 20, top: 65, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Field
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: TextField(
              controller: Get.find<ProductController>().searchController,
              decoration: InputDecoration(
                hintText: "Search products...",
                hintStyle: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                  fontFamily: 'Roboto', // Custom font
                ),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                    color: Colors.grey[400]!,
                    width: 1.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                    color: Colors.blue,
                    width: 2.0,
                  ),
                ),
                prefixIcon: Icon(Icons.search, color: Colors.grey[700]),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear, color: Colors.grey[700]),
                  onPressed: () {
                    Get.find<ProductController>().searchController.clear();
                    Get.find<HomeController>().selectedCategory.value = "";
                    Get.find<ProductController>().applyFilters("", "");
                  },
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
              style: const TextStyle(fontSize: 14, color: Colors.black87),
              onChanged: (query) {
                Get.find<ProductController>()
                    .applyFilters(selectedCategory.value, query);
              },
            ),
          ),

          // Horizontal Scrollable Categories
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Obx(() {
              return Row(
                children: categories.map((category) {
                  bool isSelected = category['name'] == selectedCategory.value;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: GestureDetector(
                      onTap: () {
                        selectedCategory.value = category['name']!;
                        Get.find<ProductController>().applyFilters(
                          category['name']!,
                          Get.find<ProductController>().searchController.text,
                        );
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Category Image
                          Container(
                            width: 75,
                            height: 75,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(40),
                              border: Border.all(color: Colors.grey, width: 2),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(40),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    width: 45,
                                    height: 45,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: ClipRRect(
                                      child: Image.asset(
                                        category['image']!,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Center(
                                            child: Icon(
                                              Icons
                                                  .image_not_supported_outlined,
                                              size: 30,
                                              color: Colors.red,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            category['name']!,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.black : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            }),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 245;

  @override
  double get minExtent => 245;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
