import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'task_provider.dart';
import 'task_model.dart';
import 'dart:ui';


class GlassMorphism extends StatelessWidget {
  final Widget child;
  final double blur;
  final double opacity;
  final Color color;
  final BorderRadius borderRadius;
  final bool hasPremiumBorder;

  const GlassMorphism({
    super.key,
    required this.child,
    this.blur = 30,
    this.opacity = 0.05,
    this.color = const Color(0xFF0F1322),
    this.borderRadius = BorderRadius.zero,
    this.hasPremiumBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: BoxDecoration(
            color: color.withOpacity(opacity),
            borderRadius: borderRadius,
            border: hasPremiumBorder
                ? Border.all(
              color: Colors.white.withOpacity(0.08),
              width: 0.8,
            )
                : null,
          ),
          child: child,
        ),
      ),
    );
  }
}

class BackgroundGlowMesh extends StatelessWidget {
  const BackgroundGlowMesh({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Container(
      color: const Color(0xFF04060A),
      width: size.width,
      height: size.height,
      child: Stack(
        children: [
          Positioned(
            top: -size.height * 0.2,
            left: -size.width * 0.3,
            child: Container(
              width: size.width * 1.2,
              height: size.width * 1.2,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF4F46E5).withOpacity(0.12),
                    const Color(0xFF4F46E5).withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: size.height * 0.05,
            right: -size.width * 0.4,
            child: Container(
              width: size.width * 1.3,
              height: size.width * 1.3,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF0EA5E9).withOpacity(0.08),
                    const Color(0xFF0EA5E9).withOpacity(0.0),
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
// WORKSPACE INTERFACE
// ==========================================

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final Color primaryColor = const Color(0xFF4F46E5);
  final Color premiumCyan = const Color(0xFF0EA5E9);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF04060A),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'MY SPHERE',
          style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 20,
              color: Colors.white,
              letterSpacing: 4.0
          ),
        ),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Icon(Icons.grid_view_rounded, color: Colors.white.withOpacity(0.5), size: 18),
          )
        ],
      ),
      body: Stack(
        children: [
          const BackgroundGlowMesh(),
          SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                const DynamicTaskMetricsHeader(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(26.0, 24.0, 26.0, 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "ACTIVE OPERATIONS",
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Colors.white.withOpacity(0.4),
                            letterSpacing: 1.5
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          border: Border.all(color: premiumCyan.withOpacity(0.2), width: 0.8),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          "SYSTEM LIVE",
                          style: TextStyle(fontSize: 8, color: premiumCyan, fontWeight: FontWeight.w800, letterSpacing: 1.2),
                        ),
                      ),
                    ],
                  ),
                ),
                const Expanded(child: TaskListView()),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(0.25),
              blurRadius: 30,
              offset: const Offset(0, 8),
            )
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: () => showTaskBottomSheet(context),
          backgroundColor: const Color(0xFF4F46E5),
          elevation: 0,
          highlightElevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          label: const Row(
            children: [
              Icon(Icons.add_rounded, color: Colors.white, size: 18),
              SizedBox(width: 6),
              Text(
                  "DEPLOY MISSION",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12, letterSpacing: 1.0)
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DynamicTaskMetricsHeader extends StatelessWidget {
  const DynamicTaskMetricsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final pending = context.watch<TaskProvider>().pendingTasksCount;
    final completed = context.watch<TaskProvider>().completedTasksCount;
    final total = pending + completed;

    final double completionPercent = total == 0 ? 0.0 : (completed / total);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      child: IntrinsicHeight(
        child: GlassMorphism(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(24),
            color: Colors.white.withOpacity(0.01),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                          '$total TOTAL UNITS REGISTERED',
                          style: TextStyle(fontSize: 9, color: Colors.white.withOpacity(0.3), fontWeight: FontWeight.w800, letterSpacing: 2.0)
                      ),
                      const SizedBox(height: 10),
                      Text(
                        completionPercent == 1.0 && total > 0 ? 'SYSTEM OPTIMIZED' : '$pending ACTIVE UNITS',
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            letterSpacing: -0.2
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '$completed Completed',
                        style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 12, fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                // ==========================================
                // FIX: EXPLICIT STACK BOUNDARY FOR TEXT RENDERING
                // ==========================================
                SizedBox(
                  width: 64,
                  height: 64,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned.fill(
                        child: CircularProgressIndicator(
                          value: completionPercent,
                          strokeWidth: 4,
                          backgroundColor: Colors.white.withOpacity(0.05),
                          color: const Color(0xFF0EA5E9),
                          strokeCap: StrokeCap.round,
                        ),
                      ),
                      Center(
                        child: Text(
                          '${(completionPercent * 100).toInt()}%',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Colors.white.withOpacity(0.95),
                              fontFeatures: const [FontFeature.tabularFigures()]
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TaskListView extends StatelessWidget {
  const TaskListView({super.key});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final tasks = taskProvider.tasks;

    if (tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.layers_clear_rounded, size: 40, color: Colors.white.withOpacity(0.15)),
            const SizedBox(height: 16),
            Text(
              'No structural processes found.\nInitialize pipeline routing.',
              style: TextStyle(
                  color: Colors.white.withOpacity(0.3),
                  fontSize: 13,
                  height: 1.5,
                  letterSpacing: 0.3,
                  fontWeight: FontWeight.w300
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: tasks.length,
      padding: const EdgeInsets.fromLTRB(24, 4, 24, 100),
      itemBuilder: (context, index) {
        final task = tasks[index];

        return Dismissible(
          key: Key(task.id),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 24),
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF43F5E).withOpacity(0.08),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.delete_outline_rounded, color: Color(0xFFF43F5E), size: 20),
          ),
          onDismissed: (direction) {
            Provider.of<TaskProvider>(context, listen: false).deleteTask(task.id);
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: GlassMorphism(
              blur: 15,
              opacity: task.isCompleted ? 0.01 : 0.03,
              borderRadius: BorderRadius.circular(14),
              child: Theme(
                data: Theme.of(context).copyWith(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
                child: Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      width: 3, height: 64,
                      decoration: BoxDecoration(
                        color: task.isCompleted ? Colors.transparent : const Color(0xFF0EA5E9),
                        borderRadius: const BorderRadius.horizontal(left: Radius.circular(14)),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                        leading: GestureDetector(
                          onTap: () => taskProvider.toggleTaskStatus(task.id),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeInOut,
                            width: 20, height: 20,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: task.isCompleted ? const Color(0xFF10B981) : Colors.white.withOpacity(0.15),
                                width: 1.2,
                              ),
                              color: task.isCompleted ? const Color(0xFF10B981).withOpacity(0.1) : Colors.transparent,
                            ),
                            child: task.isCompleted
                                ? const Icon(Icons.check_rounded, size: 12, color: Color(0xFF10B981))
                                : null,
                          ),
                        ),
                        title: Text(
                          task.title,
                          style: TextStyle(
                            fontSize: 14,
                            color: task.isCompleted ? Colors.white.withOpacity(0.2) : Colors.white.withOpacity(0.95),
                            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                          ),
                        ),
                        subtitle: task.description.isNotEmpty
                            ? Text(
                          task.description,
                          style: TextStyle(
                            fontSize: 11,
                            color: task.isCompleted ? Colors.white.withOpacity(0.12) : Colors.white.withOpacity(0.4),
                          ),
                        )
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

void showTaskBottomSheet(BuildContext context, {Task? task}) {
  final titleController = TextEditingController(text: task?.title ?? '');
  final descController = TextEditingController(text: task?.description ?? '');
  final taskProviderRef = Provider.of<TaskProvider>(context, listen: false);

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withOpacity(0.75),
    builder: (sheetContext) => GlassMorphism(
      blur: 40,
      opacity: 0.2,
      color: const Color(0xFF060913),
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 32,
          left: 28, right: 28, top: 16,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 32, height: 3,
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                task == null ? 'NEW CONFIGURATION' : 'UPDATE MANIFEST',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white.withOpacity(0.9), letterSpacing: 1.5),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              TextField(
                controller: titleController,
                autofocus: task == null,
                style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w300),
                decoration: _customInputDecoration('IDENTIFIER', Icons.fingerprint_rounded),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descController,
                style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w300),
                maxLines: null,
                minLines: 3,
                decoration: _customInputDecoration('DOSIER INSTRUCTIONS', Icons.layers_outlined),
              ),
              const SizedBox(height: 28),
              Container(
                height: 48,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      if (titleController.text.trim().isEmpty) return;
                      if (task == null) {
                        taskProviderRef.addTask(titleController.text, descController.text);
                      }
                      Navigator.pop(sheetContext);
                    },
                    child: const Center(
                      child: Text(
                        'DEPLOY OPERATION',
                        style: TextStyle(fontSize: 11, color: Color(0xFF04060A), fontWeight: FontWeight.w900, letterSpacing: 1.2),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

InputDecoration _customInputDecoration(String label, IconData icon) {
  return InputDecoration(
    labelText: label,
    labelStyle: TextStyle(color: Colors.white.withOpacity(0.25), fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 1.5),
    floatingLabelBehavior: FloatingLabelBehavior.always,
    prefixIcon: Icon(icon, color: Colors.white.withOpacity(0.25), size: 16),
    filled: true,
    fillColor: Colors.white.withOpacity(0.015),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.white.withOpacity(0.04), width: 0.8),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.white.withOpacity(0.25), width: 0.8),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
  );
}