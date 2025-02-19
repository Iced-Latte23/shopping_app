import 'package:final_project/app/modules/cart/controllers/cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../data/controller/product_controller.dart';
import '../../../data/modal/product.dart';
import '../controllers/product_detail_controller.dart';

class ProductDetailView extends GetView<ProductDetailController> {
  ProductDetailView({super.key});
  final productController = Get.put(ProductController());
  final cartController = Get.put(CartController());
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = Get.arguments;
    final Products product = args['product'];
    final String backRoute = args['backRoute'] ?? '/home';

    // State for tracking if the product is a favorite
    bool isFavorite = false;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // SliverAppBar with Gradient Overlay, Back Button, and Favorite Icon
          SliverAppBar(
            expandedHeight: 400, // Slightly reduced height for balance
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Product Image with Parallax Effect
                    Positioned.fill(
                      child: Hero(
                        tag: product.id,
                        // Add Hero animation for smooth transitions
                        child: GestureDetector(
                          onTap: () {
                            Get.offNamed('/product_detail', arguments: product);
                          },
                          child: Image.network(
                            product.image,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Center(
                                child: Icon(
                                  Icons.image_not_supported_outlined,
                                  size: 50,
                                  color: Colors.grey,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    // Gradient Overlay
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.4),
                              Colors.transparent,
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                      ),
                    ),
                    // Back Button in the Top-Left Corner
                    Positioned(
                      top: 40,
                      left: 16,
                      child: CircleAvatar(
                        backgroundColor: Colors.black54,
                        child: IconButton(
                          icon: Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Get.offNamed(backRoute),
                        ),
                      ),
                    ),
                    // Favorite Icon in the Top-Right Corner
                    Positioned(
                      top: 40,
                      right: 16,
                      child: Obx(() {
                        // Check if the product is favorited using the favorites map
                        bool isFavorite = productController.favorites[product.id] ?? false;

                        return GestureDetector(
                          onTap: () async {
                            final userId = Supabase.instance.client.auth.currentUser?.id;
                            if (userId == null) {
                              print("User not logged in!");
                              return;
                            }
                            // Toggle favorite state
                            await productController.toggleFavorite(product.id);
                          },
                          behavior: HitTestBehavior.opaque,
                          child: CircleAvatar(
                            backgroundColor: Colors.black54,
                            child: Icon(
                              isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: isFavorite ? Colors.red : Colors.white,
                              size: 24,
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

          // SliverList for the Product Details
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Title with Shadow Effect
                      Text(
                        product.title,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          shadows: [
                            Shadow(
                              offset: Offset(1, 1),
                              blurRadius: 2,
                              color: Colors.black26,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Product Price with Gradient Background
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.green.shade400,
                              Colors.green.shade700
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Description Section with Card Layout
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Description:",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Divider(thickness: 1, color: Colors.grey[300]),
                              const SizedBox(height: 8),
                              Text(
                                product.description,
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black87),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Additional Details with Modern Styling
                      _buildDetailRow(
                          Icons.branding_watermark, "Brand", product.brand),
                      _buildDetailRow(
                          Icons.model_training, "Model", product.model),
                      _buildDetailRow(Icons.color_lens, "Color", product.color),
                      _buildDetailRow(Icons.local_offer, "Discount",
                          "${product.discount}%"),
                      const SizedBox(height: 16),

                      // Add to Cart Button with Ripple Animation
                      ElevatedButton(
                        onPressed: () {
                          cartController.addToCart(product.id, product.price, product.image, product.title);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          minimumSize: Size(double.infinity, 50),
                        ),
                        child: Text(
                          'ADD TO CART',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      SizedBox(height: 25)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build detail rows
  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 24, color: Colors.grey),
          const SizedBox(width: 8),
          Text(
            "$label:",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
