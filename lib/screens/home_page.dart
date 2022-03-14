// ignore_for_file: prefer_const_constructors, prefer_typing_uninitialized_variables, unused_local_variable, prefer_const_literals_to_create_immutables

import 'package:example_app/constants/colors.dart';
import 'package:example_app/constants/text_style.dart';
import 'package:example_app/models/earthquake_model.dart';
import 'package:example_app/services/http_service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

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
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    myLat = position.latitude;
    myLong = position.longitude;
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
                      'Loading...',
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
                  child: Text('Hata: ${snapshot.error}'),
                );
              } else {
                for (int i = 0; i < snapshot.data!.result!.length; i++) {
                  double distanceInMeters = Geolocator.distanceBetween(
                    myLat!,
                    myLong!,
                    snapshot.data!.result![i].lat!.toDouble(),
                    snapshot.data!.result![i].lng!.toDouble(),
                  );
                  print(distanceInMeters);
                  if (distanceInMeters <= 500000) {
                    finalList!.add(snapshot.data!.result![i]);
                  }
                }
                return ListView.builder(
                  itemCount: finalList!.length,
                  itemBuilder: (context, index) {
                    return finalList!.isNotEmpty
                        ? Card(
                            color: Colors.red[400],
                            child: ListTile(
                              leading: Text(
                                (index + 1).toString(),
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    finalList![index].title.toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  Text(
                                    finalList![index].date.toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                ],
                              ),
                              trailing: Text(
                                '${finalList![index].mag}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ),
                          )
                        : Center(
                            child: Text(
                                "Bölgenize yakın deprem verisi bulunamamıştır"),
                          );
                  },
                );
              }
          }
        },
      )),
      // body: ListView.builder(
      //   itemBuilder: (context, index) {
      //     var myEarthQuakeList = earthQuakeList![index].result![index];
      //     return ListTile(
      //       title: Text(myEarthQuakeList.title.toString()),
      //       leading: Text("${index + 1}"),
      //       trailing: Text(
      //         "${myEarthQuakeList.mag}",
      //       ),
      //       subtitle: Text("${myEarthQuakeList.date}"),
      //     );
      //   },
      // ),
    );
  }
}
