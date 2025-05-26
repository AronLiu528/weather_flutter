import 'package:flutter/material.dart';
import '../model/weather_response.dart';
import '../services/pexels_photo.dart';
import '../utilities/constants.dart';
import '../utilities/weather.dart';
import 'city_screen.dart';
import 'dart:math';

class LocationScreen extends StatefulWidget {
  const LocationScreen({
    super.key,
    this.weatherData,
    this.photoList,
  });

  final WeatherResponse? weatherData;
  final List<String>? photoList;

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  WeatherUtils utils = WeatherUtils();
  PexelsPhotoService pexelsPhoto = PexelsPhotoService();
  late int temperature;
  late int condition;
  late String weatherIcon;
  late String weatherMessage;
  late String cityName;
  late List<String> imagesList = [];

  @override
  void initState() {
    super.initState();
    updateUI(widget.weatherData!, widget.photoList!);
  }

  void updateUI(WeatherResponse weatherData, List<String> photoList) {
    setState(() {
      temperature = weatherData.main.temp.toInt();
      condition = weatherData.weather[0].id;
      weatherIcon = utils.getWeatherIcon(condition);
      weatherMessage = utils.getMessage(temperature);
      cityName = weatherData.name;
      imagesList = photoList;
    });
  }

  @override
  Widget build(BuildContext context) {
    int randomIndex = Random().nextInt(imagesList.length);
    String imageUrl = imagesList[randomIndex];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.white,
              BlendMode.dstATop,
            ),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.near_me,
                        size: 40.0,
                        color: Colors.purpleAccent.shade100,
                      ),
                      onPressed: () async {
                        WeatherResponse weatherData =
                            await utils.getLoactionWeatherData();
                        List<String> photoList = await pexelsPhoto
                            .getLoactionPhotos(weatherData.name);
                        updateUI(weatherData, photoList);
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.location_city,
                        size: 40.0,
                        color: Colors.purpleAccent.shade100,
                      ),
                      onPressed: () async {
                        var typedName = await Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return CityScreen();
                        }));
                        if (typedName != null) {
                          WeatherResponse? weatherData =
                              await utils.getCityWeatherData(typedName);

                          if (weatherData == null) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                backgroundColor: Colors.white,
                                title: Center(child: Text('找不到城市')),
                                titleTextStyle: kDialogTitleTextStyle,
                                actionsAlignment: MainAxisAlignment.center,
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text(
                                      'OK',
                                      style: kDialogButtonTextStyle,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            List<String> photoList = await pexelsPhoto
                                .getLoactionPhotos(weatherData.name);
                            updateUI(weatherData, photoList);
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$temperature°',
                    style: kTempTextStyle,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    weatherIcon,
                    style: kConditionTextStyle,
                  ),
                ],
              ),
              Text(
                cityName,
                textAlign: TextAlign.center,
                style: kMessageTextStyle,
              ),
              // StrokeText(
              //   text: cityName,
              //   textStyle: kMessageTextStyle,
              //   strokeColor: Colors.amber,
              //   strokeWidth: 5,
              //   textAlign: TextAlign.center,
              // ),
              const Spacer(),
              Container(
                padding: EdgeInsets.only(right: 15.0, bottom: 15),
                child: Text(
                  weatherMessage,
                  textAlign: TextAlign.right,
                  style: kMessageTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
