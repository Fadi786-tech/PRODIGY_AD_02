import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do List App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TodoListScreen(),
    );
  }
}

class Todo {
  String title;
  bool isDone;

  Todo({
    required this.title,
    this.isDone = false,
  });
}

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final List<Todo> _todos = [];

  void _addTodo() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Add New Task'),
          content: TextField(
            onSubmitted: (value) {
              setState(() {
                _todos.add(Todo(title: value));
              });
              Navigator.of(ctx).pop();
            },
            decoration: const InputDecoration(labelText: 'Task Title'),
          ),
        );
      },
    );
  }

  void _editTodo(int index) {
    showDialog(
      context: context,
      builder: (ctx) {
        final TextEditingController controller = TextEditingController(text: _todos[index].title);
        return AlertDialog(
          title: const Text('Edit Task'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: 'Task Title'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _todos[index].title = controller.text;
                });
                Navigator.of(ctx).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deleteTodo(int index) {
    setState(() {
      _todos.removeAt(index);
    });
  }

  void _toggleTodoStatus(int index) {
    setState(() {
      _todos[index].isDone = !_todos[index].isDone;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addTodo,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _todos.length,
        itemBuilder: (ctx, index) {
          final todo = _todos[index];
          return ListTile(
            title: Text(
              todo.title,
              style: TextStyle(
                decoration: todo.isDone ? TextDecoration.lineThrough : null,
              ),
            ),
            leading: Checkbox(
              value: todo.isDone,
              onChanged: (value) {
                _toggleTodoStatus(index);
              },
            ),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _editTodo(index),
            ),
            onLongPress: () => _deleteTodo(index),
          );
        },
      ),
    );
  }
}
