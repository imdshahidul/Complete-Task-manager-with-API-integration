import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:taskui/ui/screens/register_screen.dart';
import 'package:taskui/ui/widgets/screen_background.dart';

import 'forgot_password_pib_verification_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _newpasswordcontroller = TextEditingController();
  final TextEditingController _confirmpasswordcontroller = TextEditingController();
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
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
                Text('Reset Password',
                style: Theme.of(context).textTheme.titleLarge,),
                Text('Set a new password of minimum length 6 digit',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey
                  ),),
                SizedBox(height: 20,),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  controller: _newpasswordcontroller,
                  decoration: InputDecoration(
                    hintText: 'New Password',
                  ),
                ),

                SizedBox(height: 16,),
                TextFormField(
                  controller: _confirmpasswordcontroller,
                  decoration: InputDecoration(
                    hintText: 'Confirm New Password',
                  ),
                ),

                SizedBox(height: 16,),
                ElevatedButton(

                    onPressed: _onTapSubmitButton, child: Icon(Icons.arrow_circle_right_outlined, color: Colors.white,)),
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
                          TextSpan(text: "Have account? "),
                          TextSpan(text: 'Sign In', style: TextStyle(
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
    Navigator.push(context, MaterialPageRoute(builder: (context)=>RegisterScreen()));
  }

  void _onTapSubmitButton(){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>ForgotPasswordPinVerificationScreen()));
  }
  void _onTapForgotPasswordButton(){}

  @override
  void dispose(){
    _newpasswordcontroller.dispose();
    _confirmpasswordcontroller.dispose();
    super.dispose();
  }
}
