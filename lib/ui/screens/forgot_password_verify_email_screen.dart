import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:taskui/ui/screens/register_screen.dart';
import 'package:taskui/ui/widgets/screen_background.dart';

import 'forgot_password_pib_verification_screen.dart';

class ForgotPasswordVerifyEmailScreen extends StatefulWidget {
  const ForgotPasswordVerifyEmailScreen({super.key});

  @override
  State<ForgotPasswordVerifyEmailScreen> createState() => _ForgotPasswordVerifyEmailScreenState();
}

class _ForgotPasswordVerifyEmailScreenState extends State<ForgotPasswordVerifyEmailScreen> {
  final TextEditingController _emailcontroller = TextEditingController();

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
                Text('Your Email Address',
                style: Theme.of(context).textTheme.titleLarge,),
                Text('A 6-digit verification PIN will be sent to your Email',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey
                  ),),
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
}
