// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors
import 'package:example_app/constants/colors.dart';
import 'package:example_app/constants/routes.dart';
import 'package:example_app/constants/strings.dart';
import 'package:example_app/utils/device_utils.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.splashPageBackgroundColor,
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: DeviceUtils.getScaledWidth(context, 0.4),
                child: Image.asset(
                  AppStrings.assetLocation,
                  scale: 0.5,
                ),
              ),
              SizedBox(height: 50,),
              SizedBox(
                height: DeviceUtils.getScaledHeight(context, 0.06),
                width: DeviceUtils.getScaledWidth(context, 0.5),
                child: ElevatedButton(onPressed: (){
                  Navigator.pushNamedAndRemoveUntil(context, AppRoutes.homePage, (route) => false);
                }, child: Text(AppStrings.loginText),style: ElevatedButton.styleFrom(
                  shape: StadiumBorder(),
                  primary: AppColors.buttonColor,
                ),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}