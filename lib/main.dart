import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import 'splash_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => TaskProvider(),
      child: const TaskSphereApp(),
    ),
  );
}

class TaskSphereApp extends StatelessWidget {
  const TaskSphereApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaskSphere',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const SplashScreen(),
    );
  }
}

// ==========================================
// DATA ENGINE & STATE MANAGEMENT
// ==========================================

class Task {
  final String id;
  final String title;
  final String description;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
  });
}

class TaskProvider extends ChangeNotifier {
  final List<Task> _tasks = [];

  List<Task> get tasks => List.unmodifiable(_tasks);

  int get pendingTasksCount =>
      _tasks.where((task) => !task.isCompleted).length;

  int get completedTasksCount =>
      _tasks.where((task) => task.isCompleted).length;

  void addTask(String title, String description) {
    _tasks.add(
      Task(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        description: description,
      ),
    );
    notifyListeners();
  }

  void updateTask(String id, String title, String description) {
    final index = _tasks.indexWhere((task) => task.id == id);

    if (index != -1) {
      _tasks[index] = Task(
        id: id,
        title: title,
        description: description,
        isCompleted: _tasks[index].isCompleted,
      );

      notifyListeners();
    }
  }

  void toggleTaskStatus(String id) {
    final index = _tasks.indexWhere((task) => task.id == id);

    if (index != -1) {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
      notifyListeners();
    }
  }

  void deleteTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
    notifyListeners();
  }
}

// ==========================================
// GLASS COMPONENT
// ==========================================

class GlassMorphism extends StatelessWidget {
  final Widget child;
  final double blur;
  final double opacity;
  final Color color;
  final BorderRadius borderRadius;

  const GlassMorphism({
    super.key,
    required this.child,
    this.blur = 15,
    this.opacity = 0.1,
    this.color = Colors.white,
    this.borderRadius = BorderRadius.zero,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: blur,
          sigmaY: blur,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: color.withOpacity(opacity),
            borderRadius: borderRadius,
            border: Border.all(
              color: Colors.white.withOpacity(opacity * 0.5),
              width: 1,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

// ==========================================
// BACKGROUND
// ==========================================

class BackgroundGlowMesh extends StatelessWidget {
  const BackgroundGlowMesh({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      color: const Color(0xFF070A11),
      width: size.width,
      height: size.height,
      child: Stack(
        children: [
          Positioned(
            top: -size.height * 0.15,
            left: -size.width * 0.2,
            child: Container(
              width: size.width * 0.9,
              height: size.width * 0.9,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF6366F1).withOpacity(0.22),
                    const Color(0xFF6366F1).withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: size.height * 0.1,
            right: -size.width * 0.3,
            child: Container(
              width: size.width * 1.1,
              height: size.width * 1.1,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF38BDF8).withOpacity(0.18),
                    const Color(0xFF38BDF8).withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// HOME SCREEN
// ==========================================

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const Color primaryColor = Color(0xFF6366F1);
  static const Color accentColor = Color(0xFF38BDF8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF070A11),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "My Sphere",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.blur_circular_rounded),
            onPressed: () {},
          ),
        ],
      ),

      body: Stack(
        children: [
          const BackgroundGlowMesh(),

          SafeArea(
            child: Column(
              children: [
                const DynamicTaskMetricsHeader(),

                const Expanded(
                  child: TaskListView(),
                ),
              ],
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: primaryColor,

        onPressed: () {
          showTaskBottomSheet(context);
        },

        icon: const Icon(Icons.add),
        label: Row(
          children: const [
            SizedBox(width: 5),
            Text("Deploy Mission"),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// HEADER
// ==========================================

class DynamicTaskMetricsHeader extends StatelessWidget {
  const DynamicTaskMetricsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final pending =
    context.select<TaskProvider, int>((p) => p.pendingTasksCount);

    final completed =
    context.select<TaskProvider, int>((p) => p.completedTasksCount);

    final total = pending + completed;

    final completionPercent =
    total == 0 ? 0.0 : completed / total;

    return Container(
      margin: const EdgeInsets.all(20),

      child: GlassMorphism(
        blur: 20,
        opacity: 0.05,
        borderRadius: BorderRadius.circular(20),

        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    "$pending Active Units",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "$completed Completed",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ],
              ),

              SizedBox(
                width: 60,
                height: 60,

                child: CircularProgressIndicator(
                  value: completionPercent,
                  color: const Color(0xFF6366F1),
                  backgroundColor: Colors.white12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// TASK LIST
// ==========================================

class TaskListView extends StatelessWidget {
  const TaskListView({super.key});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    final tasks = taskProvider.tasks;

    if (tasks.isEmpty) {
      return const Center(
        child: Text(
          "No Tasks Yet",
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return ListView.builder(
      itemCount: tasks.length,
      padding: const EdgeInsets.all(20),

      itemBuilder: (context, index) {
        final task = tasks[index];

        return Card(
          color: const Color(0xFF111827),

          child: ListTile(
            leading: Checkbox(
              value: task.isCompleted,

              onChanged: (value) {
                taskProvider.toggleTaskStatus(task.id);
              },
            ),

            title: Text(
              task.title,
              style: TextStyle(
                color: Colors.white,
                decoration: task.isCompleted
                    ? TextDecoration.lineThrough
                    : null,
              ),
            ),

            subtitle: Text(
              task.description,
              style: const TextStyle(
                color: Colors.white70,
              ),
            ),

            trailing: Row(
              mainAxisSize: MainAxisSize.min,

              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  color: Colors.blue,

                  onPressed: () {
                    showTaskBottomSheet(
                      context,
                      task: task,
                    );
                  },
                ),

                IconButton(
                  icon: const Icon(Icons.delete),
                  color: Colors.red,

                  onPressed: () {
                    taskProvider.deleteTask(task.id);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ==========================================
// BOTTOM SHEET
// ==========================================

void showTaskBottomSheet(
    BuildContext context, {
      Task? task,
    }) {
  final titleController =
  TextEditingController(text: task?.title ?? '');

  final descController =
  TextEditingController(text: task?.description ?? '');

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,

    builder: (sheetContext) {
      return GlassMorphism(
        blur: 20,
        opacity: 0.12,
        color: const Color(0xFF0D1321),

        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(28),
        ),

        child: Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom:
            MediaQuery.of(sheetContext).viewInsets.bottom + 24,
          ),

          child: Column(
            mainAxisSize: MainAxisSize.min,

            children: [
              TextField(
                controller: titleController,

                decoration: _customInputDecoration(
                  'Mission Title',
                  Icons.rocket_launch_rounded,
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: descController,
                maxLines: 3,

                decoration: _customInputDecoration(
                  'Description',
                  Icons.description,
                ),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  const Color(0xFF6366F1),
                ),

                onPressed: () {
                  final provider =
                  Provider.of<TaskProvider>(
                    context,
                    listen: false,
                  );

                  if (titleController.text
                      .trim()
                      .isEmpty) {
                    return;
                  }

                  if (task == null) {
                    provider.addTask(
                      titleController.text,
                      descController.text,
                    );
                  } else {
                    provider.updateTask(
                      task.id,
                      titleController.text,
                      descController.text,
                    );
                  }

                  Navigator.pop(sheetContext);
                },

                child: Text(
                  task == null
                      ? "Add Task"
                      : "Update Task",
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

// ==========================================
// INPUT DECORATION
// ==========================================

InputDecoration _customInputDecoration(
    String label,
    IconData icon,
    ) {
  return InputDecoration(
    labelText: label,

    prefixIcon: Icon(
      icon,
      color: Colors.cyan,
    ),

    filled: true,
    fillColor: Colors.white12,

    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  );
}