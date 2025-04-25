import 'package:flutter/material.dart';
import 'package:taskui/data/models/task_model.dart';
import 'package:taskui/data/service/network_client.dart';
import 'package:taskui/ui/widgets/centered_circular_prog_ind.dart';
import 'package:taskui/ui/widgets/sanck_bar_message.dart';
import '../../data/utils/urls.dart';

enum TaskStatus {
  sNew,
  progress,
  completed,
  canceled
}
class TaskCard extends StatefulWidget {
  const TaskCard({
    super.key, required this.taskStatus,
    required this.taskModel,
    required this.refreshList});

  final TaskStatus taskStatus;
  final TaskModel taskModel;
  final VoidCallback refreshList;

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  bool inProgress =false;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.taskModel.title, style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600

            ),),
            Text(widget.taskModel.description),
            //TODO: format it with date formatter (intl)
            Text('Date:${widget.taskModel.createdDate}'),
            Row(
              children: [

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Chip(label: Text(widget.taskModel.status, style: TextStyle(color: Colors.white),), shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)
                  ),
                    backgroundColor: _getStatusChipColor(),
                    side: BorderSide.none,
                  ),
                ),
                Spacer(),
                Visibility(
                  visible: inProgress==false,
                  replacement: CenteredCircularProgInd(),
                  child: Row(
                    children: [
                      IconButton(onPressed: (){}, icon: Icon(Icons.delete)),
                      IconButton(onPressed: _showUpdateStatusDialog, icon: Icon(Icons.edit)),
                    ],
                  ),
                ),

              ],
            )
          ],
        ),
      ),
    );
  }

  Color _getStatusChipColor(){
    late Color color;
    switch(widget.taskStatus){

      case TaskStatus.sNew:

        color=Colors.blue;
      case TaskStatus.progress:

        color=Colors.purple;
      case TaskStatus.completed:

        color=Colors.green;
      case TaskStatus.canceled:

        color= Colors.red;
    }
    return color;
  }

  void _showUpdateStatusDialog(){
    showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text('Update Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              onTap: () {
                _popDialog();
                if (isSelected('New')) return;
                _changeTskStatus('New');
              },
              title: Text('New'),
              //trailing: widget.taskModel.status=='New'? Icon(Icons.done) : null,
              trailing: isSelected('New') ? Icon(Icons.done) : null,
            ),
            ListTile(
              onTap: () {
                _popDialog();
                if (isSelected('Progress')) return;
                _changeTskStatus('Progress');
              },
              title: Text('Progress'),
              trailing: isSelected('Progress') ? Icon(Icons.done) : null,
            ),
            ListTile(
              onTap: () {
                _popDialog();
                if (isSelected('Completed')) return;
                _changeTskStatus('Completed');
              },
              title: Text('Completed'),
              trailing: isSelected('Completed') ? Icon(Icons.done) : null,
            ),
            ListTile(
              onTap: () {
                _popDialog();
                if (isSelected('Cancelled')) return;
                _changeTskStatus('Cancelled');
              },
              title: Text('Cancelled'),
              trailing: isSelected('New') ? Icon(Icons.done) : null,
            ),
          ],
        ),
      );
    });
  }

  void _popDialog () {
    Navigator.pop(context);
  }

  bool isSelected(String status)=> widget.taskModel.status==status;

  Future<void> _changeTskStatus (String status) async{
    inProgress=true;
    setState(() {});
    NetworkResponse response = await NetworkClient.getRequest(
        url: Urls.updateTaskStatusUrl(widget.taskModel.id, status));
    inProgress=false;
    if(response.isSuccess){
    widget.refreshList();
    } else {
      setState(() {});
      showSnackBarMessage(context, response.errorMessage);
    }
  }
}
