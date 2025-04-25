import 'package:flutter/material.dart';
import 'package:taskui/data/models/task_status_count_list_model.dart';
import 'package:taskui/data/models/task_status_count_model.dart';
import 'package:taskui/data/service/network_client.dart';
import 'package:taskui/ui/screens/add_new_task_screen.dart';
import 'package:taskui/ui/widgets/centered_circular_prog_ind.dart';
import 'package:taskui/ui/widgets/sanck_bar_message.dart';
import '../../data/models/task_model.dart';
import '../../data/models/task_list_model.dart';
import '../widgets/sumary_card.dart';
import '../widgets/task_card.dart';
import '../../data/utils/urls.dart';


class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  bool _getStatusCountInProgress = false;
  List<TaskStatusCountModel> _taskStatusCountList =[];

  bool _getNewTaskCountInProgress = false;
  List<TaskModel> _newTaskList =[];


  @override

  void initState(){
    super.initState();
    _getAllTaskStatusCount();
    _getAllNewTaskCount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SingleChildScrollView(
        child: Column(
          children: [
          Visibility(
            visible: _getStatusCountInProgress==false,
          replacement: Padding(
            padding: const EdgeInsets.all(16),
            child: CenteredCircularProgInd(),
          ),
          child: _buildSummarySection(),
          ),
              Visibility(
                visible: _getNewTaskCountInProgress==false,
                replacement: SizedBox(height: 300,
                    child: CenteredCircularProgInd()),
                child: ListView.separated(
                  itemCount: _newTaskList.length,
                    primary: false,
                    shrinkWrap: true,
                    itemBuilder: (context, index){
                      return TaskCard(
                        taskStatus: TaskStatus.sNew,
                        taskModel: _newTaskList[index],
                        refreshList: _getAllNewTaskCount,
                      );
                    },
                    separatorBuilder: (context, index)=>SizedBox(height: 8,)),
              ),

            ],
          ),
      ),
        floatingActionButton: FloatingActionButton(onPressed: _onTapAddNewTaskScreen, child: Icon(Icons.add),)
      );
  }

  void _onTapAddNewTaskScreen(){
    Navigator.push(
        context, MaterialPageRoute(
        builder: (context)=>AddNewTaskScreen()));
  }

  Widget _buildSummarySection() {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(height: 100,
            child: ListView.builder(
              itemCount: _taskStatusCountList.length,
                itemBuilder: (context, index) {
                return SummaryCard(title: _taskStatusCountList[index].status,
                    count: _taskStatusCountList[index].count);
                }),
          ),

        ),
      );
  }

  Future<void> _getAllTaskStatusCount() async{
    _getStatusCountInProgress=true;
    setState(() {});
    final NetworkResponse response = await NetworkClient.getRequest(
        url: Urls.taskStatusCountUrl);

    if(response.isSuccess){
      TaskStatusCountListModel _taskStatusCountListModel =
      TaskStatusCountListModel.fromJson(response.data?? {});
      _taskStatusCountList = _taskStatusCountListModel.statusCountList;


    } else {
      showSnackBarMessage(context, response.errorMessage, true);
    }
    _getStatusCountInProgress=false;
    setState(() {});
  }

  Future<void> _getAllNewTaskCount() async{
    _getNewTaskCountInProgress=true;
    setState(() {});
    final NetworkResponse response = await NetworkClient.getRequest(
        url: Urls.newTaskUrl);

    if(response.isSuccess){
      TaskListModel _taskListModel =
      TaskListModel.fromJson(response.data?? {});
      _newTaskList = _taskListModel.taskList;


    } else {
      showSnackBarMessage(context, response.errorMessage, true);
    }
    _getNewTaskCountInProgress=false;
    setState(() {});
  }

}



