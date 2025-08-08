import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/todo_model.dart';

class LocalStorage {
  /// ดึง Directory สำหรับจัดเก็บไฟล์ในเครื่อง
  static Future<Directory> _getLocalDirectory() async {
    return await getApplicationDocumentsDirectory();
  }

  /// สร้าง path สำหรับไฟล์ของผู้ใช้แต่ละคน โดยอิงจาก username
  static Future<String> _getFilePath(String username) async {
    final dir = await _getLocalDirectory();
    return "${dir.path}/todos_${username.toLowerCase()}.json";
  }

  /// โหลดรายการ Todo จากไฟล์ของผู้ใช้
  static Future<List<Todo>> loadTodos(String username) async {
    try {
      final path = await _getFilePath(username);
      final file = File(path);

      if (!await file.exists()) return [];

      final contents = await file.readAsString();
      final List<dynamic> jsonList = jsonDecode(contents);

      return jsonList.map((json) => Todo.fromJson(json)).toList();
    } catch (e) {
      print("❌ Failed to load todos for $username: $e");
      return [];
    }
  }

  /// บันทึกรายการ Todo ลงไฟล์ของผู้ใช้
  static Future<void> saveTodos(String username, List<Todo> todos) async {
    try {
      final path = await _getFilePath(username);
      final file = File(path);

      final jsonList = todos.map((todo) => todo.toJson()).toList();
      final jsonString = const JsonEncoder.withIndent(
        '  ',
      ).convert(jsonList); // สวยงามขึ้น

      await file.writeAsString(jsonString);
    } catch (e) {
      print("❌ Failed to save todos for $username: $e");
    }
  }
}
