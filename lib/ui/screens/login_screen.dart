import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:taskui/data/models/login_model.dart';
import 'package:taskui/ui/controllers/auth_controller.dart';
import 'package:taskui/ui/screens/forgot_password_verify_email_screen.dart';
import 'package:taskui/ui/screens/main_bottom_navigation_bar_screen.dart';
import 'package:taskui/ui/screens/register_screen.dart';
import 'package:taskui/ui/widgets/centered_circular_prog_ind.dart';
import 'package:taskui/ui/widgets/screen_background.dart';

import '../../data/service/network_client.dart';
import '../../data/utils/urls.dart';
import '../widgets/sanck_bar_message.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  bool _loginInProgress = false;

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
                Visibility(
                  visible: _loginInProgress==false,
                  replacement: const CenteredCircularProgInd(),

                  child: ElevatedButton(

                      onPressed: _onTapSubmitButton, child: Icon(Icons.arrow_circle_right_outlined, color: Colors.white,)),
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
      _loginUser();
    }
  }

  Future<void> _loginUser() async {
    _loginInProgress=true;
    setState(() {});
    Map<String, dynamic> requestBody = {
      'email': _emailcontroller.text.trim(),

      'password': _passwordcontroller.text
    };
    NetworkResponse response = await NetworkClient.postRequest(
        url: Urls.loginUrl,
        body: requestBody);
    _loginInProgress=false;
    setState(() {});

    if (response.isSuccess){
      LoginModel loginModel = LoginModel.fromJson(response.data!);
      //TODO: save token to local
      AuthController.saveUserInformation(loginModel.token, loginModel.userModel);
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
          builder: (context)=>MainBottomNavigationBarScreen()),
              (predicate)=>false);
    }else {
      showSnackBarMessage(context, response.errorMessage, true);
    }
  }

}
