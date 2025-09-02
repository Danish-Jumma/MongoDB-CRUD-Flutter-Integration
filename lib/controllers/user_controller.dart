import 'package:get/get.dart';
import 'package:mongodb_app/models/user.dart';
import 'package:mongodb_app/services/api_service.dart';

class UserController extends GetxController {
  final ApiService apiService = ApiService();

  // Strongly typed list of User
  RxList<User> users = <User>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  // Fetch users
  Future<void> fetchUsers() async {
    try {
      isLoading.value = true;
      final fetchedUsers = await apiService.fetchUsers();
      users.assignAll(fetchedUsers);
    } catch (e) {
      print("Error fetching users: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Create user
  void addUser(User user) async {
    final newUser = await apiService.createUser(user);
    users.add(newUser);
  }

  // Update user
  void updateUser(String id, User user) async {
    final updatedUser = await apiService.updateUser(id, user);
    int index = users.indexWhere((u) => u.id == id);
    if (index != -1) users[index] = updatedUser;
  }

  // Delete User
  Future<void> deleteUser(String id) async {
    try {
      await apiService.deleteUser(id);
      users.removeWhere((u) => u.id == id);
      Get.snackbar(
        "Success",
        "User deleted successfully",
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }
}
