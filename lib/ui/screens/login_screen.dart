import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:taskui/ui/controllers/login_controller.dart';
import 'package:taskui/ui/screens/forgot_password_verify_email_screen.dart';
import 'package:taskui/ui/screens/main_bottom_navigation_bar_screen.dart';
import 'package:taskui/ui/screens/register_screen.dart';
import 'package:taskui/ui/widgets/centered_circular_prog_ind.dart';
import 'package:taskui/ui/widgets/screen_background.dart';
import '../widgets/sanck_bar_message.dart';
import 'package:get/get.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  bool loginInProgress = false;
  final LoginController _loginController =
  Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 80,),
                Text('Get Started With',
                style: Theme.of(context).textTheme.titleLarge,),

                SizedBox(height: 20,),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailcontroller,
                  decoration: InputDecoration(
                    hintText: 'Email',
                  ),
                ),
                SizedBox(height: 16,),
                TextFormField(
                  controller: _passwordcontroller,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                  ),
                ),
                SizedBox(height: 16,),
                GetBuilder<LoginController>(
                builder: (controller) {

                  return Visibility(
                    visible: controller.loginInProgress == false,
                    replacement: const CenteredCircularProgInd(),

                    child: ElevatedButton(

                        onPressed: _onTapSubmitButton,
                        child: Icon(
                          Icons.arrow_circle_right_outlined, color: Colors
                            .white,)),
                  );

                }
                ),
                Center(
                  child: Column(
                    children: [
                      TextButton(onPressed: _onTapForgotPasswordButton, child: Text('Forgot Password?')),
                      RichText(text: TextSpan(
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.black54,
                            fontSize: 16
                        ),
                        children: [
                          TextSpan(text: "Don't have account? "),
                          TextSpan(text: 'Sign up', style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold
                          ),
                            recognizer: TapGestureRecognizer()..onTap= _onTapSignUpButton,
                          ),

                        ],

                      ))
                    ],
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
  void _onTapSignUpButton(){
    Navigator.push(context, MaterialPageRoute(
        builder: (context)=>RegisterScreen()));
  }
  void _onTapForgotPasswordButton(){

    Navigator.push(context, MaterialPageRoute(
        builder: (context)=>ForgotPasswordVerifyEmailScreen()));
  }

  _onTapSubmitButton(){
    if(_formkey.currentState!.validate()) {
      loginUser();
    }
  }

  Future<void> loginUser() async {
    final bool isSuccess = await _loginController.
    loginUser(_emailcontroller.text.trim(), _passwordcontroller.text);
    if (isSuccess){

      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
          builder: (context)=>MainBottomNavigationBarScreen()),
              (predicate)=>false);
    }else {
      showSnackBarMessage(context, _loginController.errorMessage!, true);
    }
  }

}
