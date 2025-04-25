import 'package:flutter/material.dart';
import 'package:taskui/data/models/task_model.dart';
import 'package:taskui/ui/widgets/centered_circular_prog_ind.dart';

import '../../data/models/task_list_model.dart';
import '../../data/service/network_client.dart';
import '../../data/utils/urls.dart';
import '../widgets/sanck_bar_message.dart';
import '../widgets/sumary_card.dart';
import '../widgets/task_card.dart';

class CompletedTaskScreen extends StatefulWidget {
  const CompletedTaskScreen({super.key});

  @override
  State<CompletedTaskScreen> createState() => _CompletedTaskScreenState();
}

class _CompletedTaskScreenState extends State<CompletedTaskScreen> {
  bool _getTaskCompletedInProgress = false;
  List<TaskModel> _listCompletedTask=[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getAllCompletedTaskCount();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:
          Visibility(
            visible: _getTaskCompletedInProgress==false,
              replacement: CenteredCircularProgInd(),
            child: ListView.separated(
                itemCount: _listCompletedTask.length,
                primary: false,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return  TaskCard(
                    taskStatus: TaskStatus.completed,
                    taskModel:  _listCompletedTask[index],
                    refreshList: _getAllCompletedTaskCount,
                  );
                },
                separatorBuilder: (context, index) => SizedBox(height: 8,)),
          ),
        );

  }

  Future<void> _getAllCompletedTaskCount() async{
    _getTaskCompletedInProgress = true;
    setState(() {});
    final NetworkResponse response = await NetworkClient.getRequest(
        url: Urls.completedTaskUrl);

    if(response.isSuccess){
      TaskListModel _taskListModel =
      TaskListModel.fromJson(response.data?? {});
      _listCompletedTask = _taskListModel.taskList;


    } else {
      showSnackBarMessage(context, response.errorMessage, true);
    }
    _getTaskCompletedInProgress=false;
    setState(() {});
  }

  }