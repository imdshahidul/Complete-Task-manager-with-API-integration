import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:taskui/data/service/network_client.dart';
import 'package:taskui/data/utils/urls.dart';
import 'package:taskui/ui/widgets/centered_circular_prog_ind.dart';
import 'package:taskui/ui/widgets/sanck_bar_message.dart';
import 'package:taskui/ui/widgets/screen_background.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailTEcontroller = TextEditingController();
  final TextEditingController _fnTEcontroller = TextEditingController();
  final TextEditingController _lnTEcontroller = TextEditingController();
  final TextEditingController _mobileTEcontroller = TextEditingController();
  final TextEditingController _passwordTEcontroller = TextEditingController();
 final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
bool _registrationInProgress = false;

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 80,),
                  Text('Join With Us',
                  style: Theme.of(context).textTheme.titleLarge,),
                        
                  SizedBox(height: 20,),
                  TextFormField(
                    controller: _emailTEcontroller,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Email',
                    ),
                    validator: (String? value){
                      String email = value?.trim() ?? '';
                      if(EmailValidator.validate(email)== false){
                        return "Enter a valid Email";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16,),
                  TextFormField(
                    controller: _fnTEcontroller,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      hintText: 'First Name',
                    ),
                    validator: (String? value){
                      if(value?.trim().isEmpty ?? true){
                        return "Enter a your First Name";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16,),
                  TextFormField(
                    controller: _lnTEcontroller,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      hintText: 'Last Name',
                    ),
                    validator: (String? value){
                      if(value?.trim().isEmpty ?? true){
                        return "Enter a Last Name";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16,),
                  TextFormField(
                    controller: _mobileTEcontroller,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: 'Mobile',
                    ),
                    validator: (String? value){
                      String mobile = value?.trim() ??'';
                      RegExp regEx = RegExp(r'(^(\+88|0088)?(01){1}[3456789]{1}(\d){8})$');
                      if(regEx.hasMatch(mobile)==false){
                        return "Enter your valid mobile no.";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16,),
                  TextFormField(
                    controller: _passwordTEcontroller,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      hintText: 'Password',
                    ),
                    validator: (String? value){
                      if((value?.isEmpty ?? true) || (value!.length<6)){
                        return "Your password must be at least 6 letters";
                      }
                      return null;
                    },
                  ),
                        
                  SizedBox(height: 16,),
                  Visibility(
                    visible: _registrationInProgress==false,
                    replacement: const CenteredCircularProgInd(),
                    child: ElevatedButton(

                        onPressed: _onTapSubmitButton, child: Icon(Icons.arrow_circle_right_outlined, color: Colors.white,)),
                  ),
                  SizedBox(height: 20,),
                  Center(
                    child: Column(
                      children: [
                         RichText(text: TextSpan(
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.black54,
                              fontSize: 16
                          ),
                          children: [
                            TextSpan(text: "Already have an account? "),
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
      ),
    );
  }
void _onTapSubmitButton(){
   if(_formkey.currentState!.validate()){
    _registerUser();
   }

}

Future<void> _registerUser() async {
   _registrationInProgress=true;
   setState(() {});
  Map<String, dynamic> requestBody = {
    'email': _emailTEcontroller.text.trim(),
    'firstName': _fnTEcontroller.text.trim(),
    'lastName':  _lnTEcontroller.text.trim(),
    'mobile': _mobileTEcontroller.text.trim(),
    'password': _passwordTEcontroller.text
  };
  NetworkResponse response = await NetworkClient.postRequest(
      url: Urls.registerUrl,
      body: requestBody);
_registrationInProgress=false;
setState(() {});

  if (response.isSuccess){
    _clearTextField();
showSnackBarMessage(context, 'User Registered Successfully');
  }else {
    showSnackBarMessage(context, response.errorMessage, true);
  }
}
  void _onTapSignInButton(){
    Navigator.pop(context);
  }

  @override
  void dispose(){
    _emailTEcontroller.dispose();
    _fnTEcontroller.dispose();
    _lnTEcontroller.dispose();
    _mobileTEcontroller.dispose();
    _passwordTEcontroller.dispose();

    super.dispose();
  }

  void _clearTextField(){
   _emailTEcontroller.clear();
   _fnTEcontroller.clear();
   _lnTEcontroller.clear();
   _mobileTEcontroller.clear();
   _passwordTEcontroller.clear();
  }

}
