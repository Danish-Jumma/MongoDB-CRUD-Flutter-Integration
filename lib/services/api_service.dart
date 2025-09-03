import 'dart:convert';

import 'package:mongodb_app/models/user.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://API_Address:5000/users";

  // Fetch Users
  Future<List<User>> fetchUsers() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => User.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load users");
    }
  }

  // Create user
  Future<User> createUser(User user) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to create user");
    }
  }

  // Update User
  Future<User> updateUser(String id, User user) async {
    final response = await http.put(
      Uri.parse("$baseUrl/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to update");
    }
  }

  // Delete User
  Future<void> deleteUser(String id) async {
    final response = await http.delete(Uri.parse("$baseUrl/$id"));
    if (response.statusCode == 200) {
      print("User deleted successfully");
    } else if (response.statusCode == 404) {
      throw Exception("User not found");
    } else {
      throw Exception("Failed to delete user: ${response.body}");
    }
  }
}
