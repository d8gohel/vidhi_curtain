import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vidhiadmin/app/data/usermodel.dart';
// import '../models/user_model.dart';

class UserController extends GetxController {
  final SupabaseClient _supabase = Supabase.instance.client;
  var users = <UserModel>[].obs;
  var filteredUsers = <UserModel>[].obs;
  var searchQuery = ''.obs;
  var logger = Logger(
    filter: null, // Use the default LogFilter (-> only log in debug mode)
    printer: PrettyPrinter(), // Use the PrettyPrinter to format and print log
    output: null, // Use the default LogOutput (-> send everything to console)
  );

  @override
  void onInit() {
    fetchUsers();
    super.onInit();
  }

  // Fetch Users from Supabase
  Future<void> fetchUsers() async {
    final response = await _supabase.from('users').select();
    // final res1 = await _supabase.from("windows").select();
    // logger.i(res1);

    users.value = response.map((json) => UserModel.fromJson(json)).toList();
    filteredUsers.value = users;
  }

  // Search Users
  void searchUsers(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredUsers.value = users;
    } else {
      filteredUsers.value =
          users.where((user) {
            return user.firstName.toLowerCase().contains(query.toLowerCase()) ||
                user.lastName.toLowerCase().contains(query.toLowerCase()) ||
                user.email.toLowerCase().contains(query.toLowerCase());
          }).toList();
    }
  }

  // Add User to Supabase
  Future<void> addUser(UserModel user) async {
    bool flag = false;
    String message = '';
    // Debugging: Print user data to ensure it's being passed correctly
    // print('Checking if user exists: ${user.firstName}');

    for (var element in users) {
      if (element.firstName == user.firstName &&
          element.lastName == user.lastName) {
        flag = true;
        message = "Name already exists";
        break;
      }
      if (element.phoneNumber == user.phoneNumber) {
        flag = true;
        message = "contact no already exists";
        break;
      }
    }
    if (flag) {
      Get.snackbar(
        message,
        "",
        backgroundColor: Colors.white,
        // padding: EdgeInsets.only(top: 15),
        margin: EdgeInsets.only(top: 15),
      );
    } else {
      await _supabase.from('users').insert(user.toJson());
    }

    fetchUsers();
  }

  // Update User in Supabase
  Future<void> updateUser(int id, UserModel user) async {
    await _supabase.from('users').update(user.toJson()).eq('id', id);
    fetchUsers();
  }

  // Delete User from Supabase
  Future<void> deleteUser(int id) async {
    await _supabase.from('users').delete().eq('id', id);
    fetchUsers();
  }
}
