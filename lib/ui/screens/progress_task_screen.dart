import 'package:flutter/material.dart';
import 'package:taskui/data/models/task_model.dart';
import 'package:taskui/ui/widgets/centered_circular_prog_ind.dart';

import '../../data/models/task_list_model.dart';
import '../../data/service/network_client.dart';
import '../../data/utils/urls.dart';
import '../widgets/sanck_bar_message.dart';
import '../widgets/sumary_card.dart';
import '../widgets/task_card.dart';

class ProgressTaskScreen extends StatefulWidget {
  const ProgressTaskScreen({super.key});

  @override
  State<ProgressTaskScreen> createState() => _ProgressTaskScreenState();
}

class _ProgressTaskScreenState extends State<ProgressTaskScreen> {
  bool _getTaskProgressInProgress = false;
  List<TaskModel> _progressTaskList=[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getAllProgressTaskCount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:
          Visibility(
            visible: _getTaskProgressInProgress==false,
            replacement: CenteredCircularProgInd(),
            child: ListView.separated(
                itemCount: _progressTaskList.length,
                primary: false,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return TaskCard(
                    taskStatus: TaskStatus.progress,
                    taskModel: _progressTaskList[index],
                    refreshList: _getAllProgressTaskCount,
                  );
                },
                separatorBuilder: (context, index) => SizedBox(height: 8,)),
          ),
        );

  }

  Future<void> _getAllProgressTaskCount() async{
   _getTaskProgressInProgress = true;
    setState(() {});
    final NetworkResponse response = await NetworkClient.getRequest(
        url: Urls.progressTaskUrl);

    if(response.isSuccess){
      TaskListModel _taskListModel =
      TaskListModel.fromJson(response.data?? {});
      _progressTaskList = _taskListModel.taskList;


    } else {
      showSnackBarMessage(context, response.errorMessage, true);
    }
    _getTaskProgressInProgress=false;
    setState(() {});
  }
  }