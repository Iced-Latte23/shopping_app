import 'package:get/get.dart';
import 'package:final_project/app/data/provider/supabase_provider.dart';

class ProfileController extends GetxController {
  var userData = {}.obs;

  Future<void> fetchUserData() async {
    try {
      final email = SupabaseProvider.instance.supabase.auth.currentUser?.email;

      if (email == null) {
        throw Exception('User is not authenticated');
      }
      print('Fetching data for email: $email'); // Debug log

      final response = await SupabaseProvider.instance.fetchUser(email);
      if (response == null) {
        throw Exception('Failed to fetch user data');
      }

      userData.value = response;
    } catch (e) {
      print('Error fetching user data: $e');
      userData.value = {};
    }
  }
}