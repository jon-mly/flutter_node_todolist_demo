import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:todolist_client/models/task.dart';
import 'package:todolist_client/providers/tasks_provider.dart';

class TasksPage extends StatefulWidget {
  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  //
  // ############ LIFECYCLE
  //

  @override
  void initState() {
    super.initState();
    Provider.of<TasksProvider>(context, listen: false).prepare();
  }

  //
  // ############ ACTIONS
  //

  Future _addTask(String title) async {
    await Provider.of<TasksProvider>(context, listen: false).addTask(title);
  }

  Future _toggleTask(Task task) async {
    await Provider.of<TasksProvider>(context, listen: false)
        .toggleTaskState(task);
  }

  Future _deleteTask(Task task) async {
    await Provider.of<TasksProvider>(context, listen: false).deleteTask(task);
  }

  //
  // ############ ACTION DIALOG
  //

  void _presentAddTaskActionDialog() {
    showDialog(
        context: context,
        builder: (context) {
          final TextEditingController _controller = TextEditingController();
          return AlertDialog(
            title: Text('Add a new task'),
            content: TextField(
              controller: _controller,
              decoration: InputDecoration(hintText: "What is the task ?"),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text('VALIDATE'),
                onPressed: () {
                  _addTask(_controller.text);
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  //
  // ############ UI
  //

  Widget _buildTaskView() {
    return ListView.builder(
      itemCount: Provider.of<TasksProvider>(context).tasks.length,
      itemBuilder: (BuildContext context, int index) {
        final Task task = Provider.of<TasksProvider>(context).tasks[index];
        return Slidable(
          actionPane: SlidableDrawerActionPane(),
          child: ListTile(
            title: Text(task.title),
            subtitle: Text(task.creatorId),
            leading: Icon(
              Icons.done,
              color: (task.done) ? Colors.lightGreen : Colors.grey,
            ),
          ),
          actions: <Widget>[
            IconSlideAction(
              caption: (task.done) ? "Undo" : "Done",
              icon: (task.done) ? Icons.undo : Icons.done,
              color: (task.done) ? Colors.grey : Colors.green,
              onTap: () => _toggleTask(task),
            ),
            IconSlideAction(
              caption: "Delete",
              icon: Icons.delete,
              color: Colors.red,
              onTap: () => _deleteTask(task),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your tasks"),
      ),
      body: _buildTaskView(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _presentAddTaskActionDialog,
      ),
    );
  }
}
