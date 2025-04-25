import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:taskui/data/service/network_client.dart';
import 'package:taskui/ui/screens/forgot_password_verify_email_screen.dart';
import 'package:taskui/ui/screens/main_bottom_navigation_bar_screen.dart';
import 'package:taskui/ui/screens/register_screen.dart';
import 'package:taskui/ui/widgets/centered_circular_prog_ind.dart';
import 'package:taskui/ui/widgets/sanck_bar_message.dart';
import 'package:taskui/ui/widgets/screen_background.dart';

import '../../data/utils/urls.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key});

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  final TextEditingController _titlecontroller = TextEditingController();
  final TextEditingController _descriptioncontroller = TextEditingController();
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  bool _addNewTaskInProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formkey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 80,),
                Text('Add New task',
                  style: Theme
                      .of(context)
                      .textTheme
                      .titleLarge,),

                SizedBox(height: 20,),
                TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: _titlecontroller,
                    decoration: InputDecoration(
                      hintText: 'Title',
                    ),
                    validator: (String? value) {
                      if (value
                          ?.trim()
                          .isEmpty ?? true) {
                        return 'Enter your Title';
                      }
                      return null;
                    }
                ),
                SizedBox(height: 16,),
                TextFormField(
                    maxLines: 6,
                    controller: _descriptioncontroller,
                    decoration: InputDecoration(
                        hintText: 'Description',
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8)
                    ),
                    validator: (String? value) {
                      if (value
                          ?.trim()
                          .isEmpty ?? true) {
                        return 'Enter your Description';
                      }
                      return null;
                    }
                ),
                SizedBox(height: 16,),
                Visibility(
                  visible: _addNewTaskInProgress == false,
                  replacement: CenteredCircularProgInd(),
                  child: ElevatedButton(

                      onPressed: _onTapSubmitButton,
                      child: Icon(Icons.arrow_circle_right_outlined,
                        color: Colors.white,)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onTapSignUpButton() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => RegisterScreen()));
  }

  void _onTapForgotPasswordButton() {
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => ForgotPasswordVerifyEmailScreen()));
  }

  _onTapSubmitButton() {
    if (_formkey.currentState!.validate()) {
      _addNewTask();
    }
  }

  void _clearTextFields() {
    _titlecontroller.clear();
    _descriptioncontroller.clear();
  }

  Future<void> _addNewTask() async {
    _addNewTaskInProgress = true;

    Map<String, dynamic> requestBody = {
      'title': _titlecontroller.text.trim(),
      'description': _descriptioncontroller.text.trim(),
      'status': 'New'
    };
    final NetworkResponse response = await NetworkClient.postRequest(
        url: Urls.createTaskUrl, body: requestBody);
    _addNewTaskInProgress = false;
    setState(() {});
    if (response.isSuccess) {
      _clearTextFields();
      showSnackBarMessage(context, 'New Task Added Successfully');
    } else {
      showSnackBarMessage(context, response.errorMessage);
    }

    @override
    void dispose() {
      _titlecontroller.dispose();
      _descriptioncontroller.dispose();
      super.dispose();
    }
  }
}
