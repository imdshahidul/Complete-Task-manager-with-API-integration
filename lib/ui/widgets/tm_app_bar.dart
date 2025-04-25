
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:taskui/ui/screens/update_profile_screen.dart';
import '../screens/login_screen.dart';
import 'package:taskui/ui/controllers/auth_controller.dart';

class TMAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TMAppBar({
    super.key, this.fromprofilescreen,
  });
 final bool? fromprofilescreen;
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return AppBar(
      backgroundColor: Colors.green,
      title: GestureDetector(
        onTap: () {
          if (fromprofilescreen?? false) {
            return;
          }
          _onTapTMAppBAr(context);
        },
        child: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundImage: _shoulShowPhoto(AuthController.userModel?.photo)
              ? MemoryImage(base64Decode(AuthController.userModel?.photo ?? ''),
              ): null,
            ),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AuthController.userModel?.fulNmae ?? 'Unknown' , style: textTheme.bodyLarge?.copyWith(color: Colors.white),),
                    Text(AuthController.userModel?.email ?? 'Unknown' , style: textTheme.bodySmall?.copyWith(color: Colors.white),),
                  ]

              ),
            ),
            IconButton(onPressed: ()=> _onTapLogOutButton(context), icon: Icon(Icons.logout))
          ],
        ),
      ),
    );
  }

  bool _shoulShowPhoto(String? photo){
    return photo != null && photo.isNotEmpty;

  }
 void _onTapTMAppBAr(BuildContext context){
    Navigator.push(context,
    MaterialPageRoute(
        builder: (context)=>UpdateProfileScreen()));
 }

  Future<void> _onTapLogOutButton(BuildContext context) async{
    await AuthController.clearUserData();
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(
            builder: (context)=>LoginScreen(),),
        (predicate) => false
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
