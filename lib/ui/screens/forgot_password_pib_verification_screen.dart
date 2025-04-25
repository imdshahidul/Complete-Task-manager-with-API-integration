import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:taskui/ui/screens/login_screen.dart';
import 'package:taskui/ui/screens/register_screen.dart';
import 'package:taskui/ui/screens/reset_password_screen.dart';
import 'package:taskui/ui/widgets/screen_background.dart';
import 'login_screen.dart';

class ForgotPasswordPinVerificationScreen extends StatefulWidget {
  const ForgotPasswordPinVerificationScreen({super.key});

  @override
  State<ForgotPasswordPinVerificationScreen> createState() => _ForgotPasswordPinVerificationScreenState();
}

class _ForgotPasswordPinVerificationScreenState extends State<ForgotPasswordPinVerificationScreen> {
  final TextEditingController _pincodecontroller = TextEditingController();

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
                Text('PIN Verification',
                style: Theme.of(context).textTheme.titleLarge,),
                Text('A 6-digit verification PIN has been sent to your Email',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey
                  ),),
                SizedBox(height: 20,),

                PinCodeTextField(
                  length: 6,
                  obscureText: false,
                  animationType: AnimationType.fade,
                  keyboardType: TextInputType.number,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: 50,
                    fieldWidth: 40,
                    activeFillColor: Colors.white,
                    //activeColor: Colors.white,
                    inactiveFillColor: Colors.white,
                    selectedFillColor: Colors.white

                  ),
                  animationDuration: Duration(milliseconds: 300),
                  backgroundColor: Colors.transparent,
                  enableActiveFill: true,
                  //errorAnimationController: errorController,
                  controller: _pincodecontroller,
                  appContext: context,
                ),

                SizedBox(height: 16,),
                ElevatedButton(

                    onPressed: _onTapSubmitButton, child: Text('Verify', style: TextStyle(color: Colors.white,))),
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
                            recognizer: TapGestureRecognizer()..onTap= _onTapSignInButton,
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
  void _onTapSignInButton(){
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
        builder: (context)=>const LoginScreen()), (pre)=>false);
  }

  void _onTapSubmitButton(){
    Navigator.push(context, MaterialPageRoute(
        builder: (context)=>const ResetPasswordScreen()),);
  }
  void _onTapForgotPasswordButton(){}
}
