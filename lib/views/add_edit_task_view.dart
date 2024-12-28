import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sameer_assigment/models/task.dart';
import 'package:sameer_assigment/viewmodels/task_view_model.dart';

class AddEditTaskView extends ConsumerStatefulWidget {
  final Task? task;

  const AddEditTaskView({super.key, this.task});

  @override
  _AddEditTaskViewState createState() => _AddEditTaskViewState();
}

class _AddEditTaskViewState extends ConsumerState<AddEditTaskView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  DateTime? _dueDate;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController = TextEditingController(text: widget.task?.description ?? '');
    _dueDate = widget.task?.dueDate ?? DateTime.now();
  }

  Future<void> _selectDateAndTime() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _dueDate!,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_dueDate!),
      );

      if (pickedTime != null) {
        setState(() {
          _dueDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Add Task' : 'Edit Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (value) => value == null || value.isEmpty ? 'Title is required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text('Due Date and Time: '),
                    TextButton(
                      onPressed: _selectDateAndTime,
                      child: Text(
                        '${_dueDate!.toLocal().toString().split(' ')[0]} ${_dueDate!.hour}:${_dueDate!.minute.toString().padLeft(2, '0')}',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final task = Task(
                        id: widget.task?.id,
                        title: _titleController.text,
                        description: _descriptionController.text,
                        status: widget.task?.status ?? 'Pending',
                        dueDate: _dueDate!,
                      );
                      if (widget.task == null) {
                        ref.read(taskProvider.notifier).addTask(task);
                      } else {
                        ref.read(taskProvider.notifier).updateTask(task);
                      }
                      Navigator.pop(context);
                    }
                  },
                  child: Text(widget.task == null ? 'Add Task' : 'Update Task'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
