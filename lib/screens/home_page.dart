// ignore_for_file: prefer_const_constructors, prefer_typing_uninitialized_variables, unused_local_variable, prefer_const_literals_to_create_immutables, avoid_print


import 'package:example_app/constants/colors.dart';
import 'package:example_app/constants/strings.dart';
import 'package:example_app/constants/text_style.dart';
import 'package:example_app/models/earthquake_model.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../services/http_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Result>? finalList;
  double? myLat;
  double? myLong;

  @override
  void initState() {
    super.initState();

    getCurrentLocation();
    finalList = [];
  }

  getCurrentLocation() async {
    if (await Geolocator.isLocationServiceEnabled() != false &&
        (await Geolocator.checkPermission() == LocationPermission.always ||
            await Geolocator.checkPermission() ==
                LocationPermission.whileInUse)) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        myLat = position.latitude;
        myLong = position.longitude;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    finalList = [];
    return Scaffold(
      body: Center(
          child: FutureBuilder<Earthquake>(
        future: HttpService.getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppStrings.loadingText,
                      style: AppTextStyle.boldText,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CircularProgressIndicator(
                      color: AppColors.circularProgressColor,
                    ),
                  ],
                ),
              );
            default:
              if (snapshot.hasError) {
                return Center(
                  child: Text('${AppStrings.errorText}: ${snapshot.error}',style: AppTextStyle.boldText,),
                );
              } else {
                if (myLat != null && myLong != null) {
                  for (int i = 0; i < snapshot.data!.result!.length; i++) {
                    double distanceInMeters = Geolocator.distanceBetween(
                      snapshot.data!.result![i].lat!.toDouble(),
                      snapshot.data!.result![i].lng!.toDouble(),
                      myLat!,
                      myLong!,
                    );
                    if (distanceInMeters <= 500000) {
                      finalList!.add(snapshot.data!.result![i]);
                    }
                  }
                }
                return myLat != null
                    ? ListView.builder(
                        itemCount: finalList!.length,
                        itemBuilder: (context, index) {
                          return finalList!.isNotEmpty
                              ? Card(
                                  color: AppColors.listViewItemsColor,
                                  child: ListTile(
                                    leading: Text(
                                      (index + 1).toString(),
                                      style: AppTextStyle.sizedText,
                                    ),
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          finalList![index].title.toString(),
                                          textAlign: TextAlign.center,
                                          style: AppTextStyle.boldAndSizedText,
                                        ),
                                        Text(
                                          finalList![index].date.toString(),
                                          style: AppTextStyle.boldAndSizedText,
                                        ),
                                      ],
                                    ),
                                    trailing: Text(
                                      '${finalList![index].mag}',
                                      style: AppTextStyle.boldAndSizedText,
                                    ),
                                  ),
                                )
                              : Center(
                                  child: Text(AppStrings.dataNotFoundText,style: AppTextStyle.boldText,),
                                );
                        },
                      )
                    : Center(
                        child: Text(AppStrings.checkPermissionText,style: AppTextStyle.boldText,),
                      );
              }
          }
        },
      )),
    );
  }
}
