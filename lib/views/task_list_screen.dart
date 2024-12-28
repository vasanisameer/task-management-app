import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sameer_assigment/models/task.dart';
import 'package:sameer_assigment/viewmodels/task_view_model.dart';
import 'package:sameer_assigment/views/add_edit_task_view.dart';
import 'package:sameer_assigment/views/task_detail_view.dart';

class TaskListScreen extends ConsumerStatefulWidget {
  const TaskListScreen({super.key});

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends ConsumerState<TaskListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _statusFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(taskProvider);

    final filteredTasks = tasks.where((task) {
      final matchesSearchQuery = task.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          task.description.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesStatus = _statusFilter == 'All' ||
          (task.status == 'Completed' && _statusFilter == 'Completed') ||
          (task.status == 'Pending' && _statusFilter == 'Pending');
      return matchesSearchQuery && matchesStatus;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Management App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter section
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey, width: 1),
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: 'Search Tasks',
                        prefixIcon: Icon(Icons.search),
                        border: InputBorder.none, // Remove default border
                        contentPadding: EdgeInsets.all(10),
                      ),
                      onChanged: _onSearchChanged,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey, width: 1),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: DropdownButton<String>(
                    value: _statusFilter,
                    onChanged: (newValue) {
                      setState(() {
                        _statusFilter = newValue!;
                      });
                    },
                    items: ['All', 'Pending', 'Completed']
                        .map((status) => DropdownMenuItem<String>(
                      value: status,
                      child: Text(status),
                    ))
                        .toList(),
                    underline: const SizedBox(),
                    isExpanded: false,
                    icon: const Icon(Icons.arrow_drop_down),
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
          // Task list
          Expanded(
            child: filteredTasks.isEmpty
                ? const Center(child: Text('No tasks found! Add some.'))
                : ListView.builder(
              itemCount: filteredTasks.length,
              itemBuilder: (context, index) {
                final task = filteredTasks[index];
                String formattedDueDate =
                DateFormat('dd-MM-yyyy hh:mm a').format(task.dueDate);
                return ListTile(
                  title: Text(task.title),
                  subtitle: Text('Due: $formattedDueDate'),
                  trailing: Checkbox(
                    value: task.status == 'Completed',
                    onChanged: (value) {
                      final updatedTask = Task(
                        id: task.id,
                        title: task.title,
                        description: task.description,
                        status: value! ? 'Completed' : 'Pending',
                        dueDate: task.dueDate,
                      );
                      ref.read(taskProvider.notifier).updateTask(updatedTask);
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TaskDetailView(task: task),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddEditTaskView()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }
}

