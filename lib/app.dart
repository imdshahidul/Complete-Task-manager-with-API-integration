import 'package:flutter/material.dart';
import 'package:taskui/ui/screens/splash_screen.dart';

class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: TaskManagerApp.navigatorKey,
      theme: ThemeData(
          colorSchemeSeed: Colors.green,
          inputDecorationTheme: InputDecorationTheme(
            hintStyle: TextStyle(
                fontWeight: FontWeight.w400,
                color: Colors.green
            ),
            fillColor: Colors.white,
            filled: true,
            contentPadding: EdgeInsets.symmetric(
                horizontal: 16
            ),
            border: _zeroBorder(),
            enabledBorder: _zeroBorder(),
            errorBorder: _zeroBorder(),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
                fixedSize: Size.fromWidth(double.maxFinite),
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)
                )
            ),
          ),
          textTheme: TextTheme(
            titleLarge:TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 24
            ),

          )
      ),
      home: splash_screen(),
    );
  }

  OutlineInputBorder _zeroBorder(){
    return OutlineInputBorder(
      borderSide: BorderSide.none,
    );
  }
}
