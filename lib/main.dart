import 'package:flutter/material.dart';
import 'login_screen.dart';

void main() {
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // เอาแถบ DEBUG ออก
      title: 'Todo App',
      theme: ThemeData.light().copyWith(
        primaryColor: Colors.teal,
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.teal,
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system, // ปรับตามระบบ
      home: const LoginScreen(),
    );
  }
}
