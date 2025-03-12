import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../data/windowmodel.dart';

class WindowController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;
  var windows = <WindowModel>[].obs;

  @override
  void onInit() {
    fetchWindows();
    super.onInit();
  }

  // Fetch all windows
  Future<void> fetchWindows() async {
    final response = await supabase.from('windows').select();
    windows.value = response.map((data) => WindowModel.fromJson(data)).toList();
  }

  // Add a new window
  Future<void> addWindow(WindowModel window) async {
    final response =
        await supabase
            .from('windows')
            .insert(window.toJson()) // Do NOT include 'id'
            .select()
            .single();

    windows.add(WindowModel.fromJson(response));
  }

  // Update an existing window
  Future<void> updateWindow(int id, WindowModel window) async {
    await supabase.from('windows').update(window.toJson()).eq('id', id);
    fetchWindows();
  }

  // Delete a window
  Future<void> deleteWindow(int id) async {
    await supabase.from('windows').delete().eq('id', id);
    windows.removeWhere((w) => w.id == id);
  }
}
