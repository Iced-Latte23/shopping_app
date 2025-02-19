import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/provider/supabase_provider.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        actions: [
          // Add Logout Button in AppBar
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              // Call the signOut function from SupabaseProvider
              await SupabaseProvider.instance.signOut();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'ProfileView is working',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            // Add a Logout Button in the Body (Optional)
            ElevatedButton(
              onPressed: () async {
                // Call the signOut function from SupabaseProvider
                await SupabaseProvider.instance.signOut();
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}