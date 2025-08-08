import 'package:flutter/material.dart';
import 'models/todo_model.dart';
import 'widgets/todo_tile.dart';
import 'services/local_storage.dart';
import 'add_edit_todo_screen.dart';
import 'login_screen.dart';

class TodoScreen extends StatefulWidget {
  final String username;

  const TodoScreen({super.key, required this.username});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  List<Todo> todos = [];

  @override
  void initState() {
    super.initState();
    loadTodos();
  }

  Future<void> loadTodos() async {
    todos = await LocalStorage.loadTodos(widget.username);
    setState(() {});
  }

  Future<void> saveTodos() async {
    await LocalStorage.saveTodos(widget.username, todos);
  }

  void addTodo(Todo todo) {
    setState(() {
      todos.add(todo);
    });
    saveTodos();
  }

  void updateTodo(int index, Todo updatedTodo) {
    setState(() {
      todos[index] = updatedTodo;
    });
    saveTodos();
  }

  void deleteTodo(int index) {
    setState(() {
      todos.removeAt(index);
    });
    saveTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFB2FEFA), Color(0xFF0ED2F7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text("Todo ของคุณ: ${widget.username}"),
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          elevation: 4,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              },
              tooltip: "ออกจากระบบ",
            ),
          ],
        ),
        body: todos.isEmpty
            ? const Center(
                child: Text(
                  "ยังไม่มีรายการที่เพิ่ม",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: todos.length,
                itemBuilder: (_, index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: InkWell(
                      onTap: () async {
                        final updatedTodo = await Navigator.push<Todo>(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                AddEditTodoScreen(existingTodo: todos[index]),
                          ),
                        );
                        if (updatedTodo != null) {
                          updateTodo(index, updatedTodo);
                        }
                      },
                      child: TodoTile(
                        todo: todos[index],
                        onDelete: () => deleteTodo(index),
                      ),
                    ),
                  );
                },
              ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.teal,
          icon: const Icon(Icons.add),
          label: const Text("เพิ่มรายการ"),
          onPressed: () async {
            final newTodo = await Navigator.push<Todo>(
              context,
              MaterialPageRoute(builder: (_) => const AddEditTodoScreen()),
            );
            if (newTodo != null) {
              addTodo(newTodo);
            }
          },
        ),
      ),
    );
  }
}
