import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taskui/ui/controllers/auth_controller.dart';
import 'package:taskui/ui/widgets/centered_circular_prog_ind.dart';
import 'package:taskui/ui/widgets/screen_background.dart';
import 'package:taskui/ui/widgets/tm_app_bar.dart';
import '../../data/models/user_model.dart';
import '../../data/service/network_client.dart';
import '../../data/utils/urls.dart';
import '../widgets/sanck_bar_message.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final TextEditingController _emailTEcontroller = TextEditingController();
  final TextEditingController _fnTEcontroller = TextEditingController();
  final TextEditingController _lnTEcontroller = TextEditingController();
  final TextEditingController _mobileTEcontroller = TextEditingController();
  final TextEditingController _passwordTEcontroller = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _pickedImage;
  bool _updateProfileInProgress = false;

  @override
  void initState() {
    super.initState();

    UserModel userModel = AuthController.userModel!;
    _emailTEcontroller.text = userModel.email;
    _fnTEcontroller.text = userModel.firstName;
    _lnTEcontroller.text = userModel.lastName;
    _mobileTEcontroller.text = userModel.mobile;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMAppBar(
        fromprofilescreen: true,
      ),
      body: ScreenBackground(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formkey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 40,),
                    Text('Update Profile',
                      style: Theme.of(context).textTheme.titleLarge,),
                    const SizedBox(height: 16,),
                    build_photo(),
                    const SizedBox(height: 10,),
                    TextFormField(
                      controller: _emailTEcontroller, //Do Validation
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      enabled: false,
                      decoration: InputDecoration(
                        hintText: 'Email'
                      ),
                
                    ),
                
                    const SizedBox(height: 10,),
                    TextFormField(
                      controller: _fnTEcontroller,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          hintText: 'First Name'
                      ),
                      validator: (String?value){
                        if(value?.trim().isEmpty??true) {
                          return 'Enter your First Name';
                        }
                        return null;
                      },
                    ),
                
                    const SizedBox(height: 10,),
                    TextFormField(
                      controller: _lnTEcontroller,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          hintText: 'Last Name'
                      ),
                      validator: (String?value){
                        if(value?.trim().isEmpty??true) {
                          return 'Enter your Last Name';
                        }
                        return null;
                      },
                    ),
                
                    const SizedBox(height: 10,),
                    TextFormField(
                      controller: _mobileTEcontroller,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                          hintText: 'Phone'
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
                
                    const SizedBox(height: 10,),
                    TextFormField(
                      controller: _passwordTEcontroller, //here no need to validate
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                          hintText: 'Password'
                      ),

                    ),
                    SizedBox(height: 16,),
                    Visibility(
                      visible: _updateProfileInProgress==false,
                      replacement:CenteredCircularProgInd(),
                      child: ElevatedButton(

                          onPressed: _onTapSubmitButton, child: Icon(Icons.arrow_circle_right_outlined, color: Colors.white,)),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );

  }

  void _onTapSubmitButton(){
    if(_formkey.currentState!.validate()){
      _updateUser();

    }
  }

  Future<void> _updateUser() async {
    _updateProfileInProgress=true;
    setState(() {});
    Map<String, dynamic> requestBody = {
      'email': _emailTEcontroller.text.trim(),
      'firstName': _fnTEcontroller.text.trim(),
      'lastName': _lnTEcontroller.text.trim(),
      'mobile': _mobileTEcontroller.text.trim(),
    };
      if(_passwordTEcontroller.text.isNotEmpty){
        requestBody['password'] = _passwordTEcontroller.text;
      }

      if(_pickedImage != null){
        List<int> imageBytes = await _pickedImage!.readAsBytes();
        String encodeImage = base64Encode(imageBytes);
        requestBody['photo'] = encodeImage;
      }

    NetworkResponse response = await NetworkClient.postRequest(
        url: Urls.updateProfileUrl,
        body: requestBody);
    _updateProfileInProgress=false;
    setState(() {});

    if (response.isSuccess){
      //TODO: Update UserData in Catche
      _passwordTEcontroller.clear();
      showSnackBarMessage(context, 'User Data Updated Successfully');
    }else {
      showSnackBarMessage(context, response.errorMessage, true);
    }
  }

  void _onTapSignInButton(){
    Navigator.pop(context);
  }


  Widget build_photo() {
    return GestureDetector(
      onTap: _onTapPhotoPicker,
      child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8)
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 50,
                          width: 80,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                              bottomLeft: Radius.circular(8)
                            )
                          ),
                          alignment: Alignment.center,
                          child: Text('Photo', style: TextStyle(color: Colors.white),),
                        ),
                        const SizedBox(width: 8,),
                        Text(_pickedImage?.name ?? 'Add your picture')
                      ],
                    ),
                  ),
    );
  }

  void _onTapPhotoPicker() async{
   XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
   if (image != null){
     _pickedImage = image;
     setState(() {});
   }
  }
}
