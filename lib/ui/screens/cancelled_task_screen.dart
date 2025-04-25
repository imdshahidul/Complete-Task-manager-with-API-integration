import 'package:flutter/material.dart';
import 'package:taskui/data/models/task_model.dart';
import 'package:taskui/ui/widgets/centered_circular_prog_ind.dart';

import '../../data/models/task_list_model.dart';
import '../../data/service/network_client.dart';
import '../../data/utils/urls.dart';
import '../widgets/sanck_bar_message.dart';
import '../widgets/sumary_card.dart';
import '../widgets/task_card.dart';

class CancelledTaskScreen extends StatefulWidget {
  const CancelledTaskScreen({super.key});

  @override
  State<CancelledTaskScreen> createState() => _CancelledTaskScreenState();
}

class _CancelledTaskScreenState extends State<CancelledTaskScreen> {
  bool  _getTaskCancelledInProgress = false;
  List<TaskModel> _listCancelledTask =[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getAllCancelledTaskCount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:
          Visibility(
            visible: _getTaskCancelledInProgress==false,
            replacement: CenteredCircularProgInd(),
            child: ListView.separated(
                itemCount: _listCancelledTask.length,
                primary: false,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return  TaskCard(
                    taskStatus: TaskStatus.canceled,
                    taskModel: _listCancelledTask[index],
                    refreshList: _getAllCancelledTaskCount,
                  );
                },
                separatorBuilder: (context, index) => SizedBox(height: 8,)),
          ),
        );

  }

  Future<void> _getAllCancelledTaskCount() async{
    _getTaskCancelledInProgress = true;
    setState(() {});
    final NetworkResponse response = await NetworkClient.getRequest(
        url: Urls.cancelledTaskUrl);

    if(response.isSuccess){
      TaskListModel _taskListModel =
      TaskListModel.fromJson(response.data?? {});
      _listCancelledTask= _taskListModel.taskList;


    } else {
      showSnackBarMessage(context, response.errorMessage, true);
    }
    _getTaskCancelledInProgress=false;
    setState(() {});
  }
  }