import 'package:flutter/material.dart';

class TaskManager extends StatelessWidget {
  final List<Map<String, dynamic>> tasks = [
    {'name': 'AI Agent', 'status': 'Running', 'color': Colors.green},
    {'name': 'Sensor Monitor', 'status': 'Idle', 'color': Colors.yellow},
    {'name': 'Process Scheduler', 'status': 'Running', 'color': Colors.brown},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[50],
      appBar: AppBar(
        backgroundColor: Colors.yellow[700],
        title: Text('Task Manager'),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return Card(
            color: task['color'][100],
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              leading: Icon(Icons.work, color: task['color'][700]),
              title: Text(
                task['name'],
                style: TextStyle(color: Colors.brown[900]),
              ),
              subtitle: Text('Status: ${task['status']}'),
              trailing: Icon(
                task['status'] == 'Running'
                    ? Icons.check_circle
                    : Icons.pause_circle,
                color: task['color'][700],
              ),
            ),
          );
        },
      ),
    );
  }
}
