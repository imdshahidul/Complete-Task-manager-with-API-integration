import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:taskui/data/models/task_status_count_list_model.dart';
import 'package:taskui/data/models/task_status_count_model.dart';
import 'package:taskui/data/service/network_client.dart';
import 'package:taskui/ui/controllers/new_task_controller.dart';
import 'package:taskui/ui/screens/add_new_task_screen.dart';
import 'package:taskui/ui/widgets/centered_circular_prog_ind.dart';
import 'package:taskui/ui/widgets/sanck_bar_message.dart';
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
              GetBuilder<NewTaskController>(
                builder:(controller) {
                  return Visibility(
                    visible: controller.getNewTaskInProgress == false,
                    replacement: SizedBox(height: 300,
                        child: CenteredCircularProgInd()),
                    child: ListView.separated(
                        itemCount: controller.newTaskList.length,
                        primary: false,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return TaskCard(
                            taskStatus: TaskStatus.sNew,
                            taskModel: controller.newTaskList[index],
                            refreshList: _getAllNewTaskCount,
                          );
                        },
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 8,)),
                  );

                }
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
    final bool isSuccess = await Get.find<NewTaskController>().getNewTaskList();
    if(!isSuccess){
      showSnackBarMessage(context, Get.find<NewTaskController>().errorMessage!, true);
    }

  }

}



