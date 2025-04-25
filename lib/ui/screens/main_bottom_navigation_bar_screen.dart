import 'package:flutter/material.dart';
import 'package:taskui/ui/screens/cancelled_task_screen.dart';
import 'package:taskui/ui/screens/new_task_screen.dart';
import 'package:taskui/ui/screens/progress_task_screen.dart';

import '../widgets/tm_app_bar.dart';
import 'completed_task_screen.dart';

class MainBottomNavigationBarScreen extends StatefulWidget {
  const MainBottomNavigationBarScreen({super.key});

  @override
  State<MainBottomNavigationBarScreen> createState() => _MainBottomNavigationBarScreenState();
}

class _MainBottomNavigationBarScreenState extends State<MainBottomNavigationBarScreen> {
  int _selectedindex =0;
  final List<Widget> _screens = [
    NewTaskScreen(),
    ProgressTaskScreen(),
    CompletedTaskScreen(),
    CancelledTaskScreen(),
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: TMAppBar(),
      body: _screens[_selectedindex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedindex,
          onDestinationSelected: (index){
          _selectedindex=index;
          setState(() {

          });
          },


          destinations:[
            NavigationDestination(icon: Icon(Icons.new_label), label: 'New'),
            NavigationDestination(icon: Icon(Icons.done), label: 'Progress'),
            NavigationDestination(icon: Icon(Icons.comment), label: 'Completed'),
            NavigationDestination(icon: Icon(Icons.cancel), label: 'Cancel'),
          ]
      ),
    );
  }
}

