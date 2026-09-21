import 'package:flutter/material.dart';

void main() {
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TP2 - Todo List',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF9C27B0),
          foregroundColor: Colors.white,
        ),
      ),
      home: const TodoList(),
    );
  }
}

// TodoList : StatefulWidget - gère l'état de la liste de tâches

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  
  final List<String> _todos = [];

  // Contrôleur pour le champ de texte
  final TextEditingController _controller = TextEditingController();

  
  void addTodo() {
    final String text = _controller.text.trim();

    if (text.isEmpty) {
      // Afficher un message si le champ est vide
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez entrer une tâche !'),
          duration: Duration(seconds: 1),
        ),
      );
      return;
    }

    setState(() {
      _todos.add(text);
      _controller.clear();
    });
  }

  
  void removeTodo(int index) {
    final String removed = _todos[index];

    setState(() {
      _todos.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tâche supprimée : "$removed"'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
//ui utilisateur
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ma Todo List'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Entrer une nouvelle tâche...',
                prefixIcon: const Icon(Icons.edit, color: Colors.purple),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.purple, width: 2),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add, color: Colors.purple),
                  onPressed: addTodo,
                ),
              ),
              onSubmitted: (_) => addTodo(),
            ),
          ),

          
          Expanded(
            child: _todos.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.checklist, size: 80, color: Colors.grey),
                        SizedBox(height: 12),
                        Text(
                          'Aucune tâche pour le moment',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Appuyez longuement sur une tâche pour la supprimer',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _todos.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        elevation: 2,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.purple.shade100,
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(
                                color: Colors.purple,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            _todos[index],
                            style: const TextStyle(fontSize: 16),
                          ),
                          trailing: const Icon(
                            Icons.delete_outline,
                            color: Colors.grey,
                          ),
                          // Suppression par appui long
                          onLongPress: () => removeTodo(index),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),

      
      floatingActionButton: FloatingActionButton(
        onPressed: addTodo,
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        tooltip: 'Ajouter une tâche',
        child: const Icon(Icons.add),
      ),
    );
  }
}