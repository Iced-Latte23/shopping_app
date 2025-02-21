import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/data/controller/product_controller.dart';
import 'app/data/controller/theme_controller.dart';
import 'app/routes/app_pages.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://vwyeaxdshqljneubhghi.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZ3eWVheGRzaHFsam5ldWJoZ2hpIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzY1NzMzNjQsImV4cCI6MjA1MjE0OTM2NH0.7c5dO6JawqfbX9FGa1Yz4OdGvahBym4IkPl6O8seo24',
  );

  final supabase = Supabase.instance.client;
  final session = supabase.auth.currentSession;

  Get.put(ProductController());
  final ThemeController themeController = Get.put(ThemeController());

  runApp(
    Obx(() {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Application",
        theme: themeController.getTheme(),
        initialRoute: session != null ? AppPages.HOME : AppPages.LOGIN,
        getPages: AppPages.routes,
      );
    }),
  );
}
