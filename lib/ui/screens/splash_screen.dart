import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:taskui/ui/controllers/auth_controller.dart';
import 'package:taskui/ui/widgets/screen_background.dart';
import '../utils/assets_path.dart';
import 'login_screen.dart';
import 'main_bottom_navigation_bar_screen.dart';


class splash_screen extends StatefulWidget {
  const splash_screen({super.key});

  @override
  State<splash_screen> createState() => _splash_screenState();
}

class _splash_screenState extends State<splash_screen> {

  @override
  void initState() {
    super.initState();
        _moveToNextScreen();
  }

  Future<void> _moveToNextScreen() async {
    await Future.delayed(const Duration(seconds: 2));
    final bool isLoggedIn = await AuthController.checkIsUserLoggedIn();

        Navigator.pushReplacement(context, 
            MaterialPageRoute(
                builder: (context)=>
                isLoggedIn? MainBottomNavigationBarScreen() :  const LoginScreen()));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Stack(
        children: [
          ScreenBackground(
          child: Center(child: SvgPicture.asset(AssetPath.logoSvg,width: 160,)),
          )
    ],
      ),

    );
  }
}
