import 'package:clima/screens/city_screen.dart';
import 'package:clima/utilities/weather.dart';
import 'package:flutter/material.dart';
import 'package:clima/utilities/constants.dart';
import '../Model/weather_response.dart';
import '../services/pexels_photo.dart';

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
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(imagesList[1]) as ImageProvider,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.near_me,
                      size: 40.0,
                      color: Colors.purple.shade300,
                    ),
                    onPressed: () async {
                      WeatherResponse weatherData =
                          await utils.getLoactionWeatherData();
                      List<String> photoList =
                          await pexelsPhoto.getLoactionPhotos(weatherData.name);
                      updateUI(weatherData, photoList);
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.location_city,
                      size: 40.0,
                      color: Colors.purple.shade300,
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
                              title: Text('找不到城市'),
                              content: Text('請確認城市名稱是否正確'),
                              actionsAlignment: MainAxisAlignment.center,
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('確定'),
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
              const SizedBox(height: 30),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Row(
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
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.only(right: 15.0),
                child: Text(
                  weatherMessage,
                  textAlign: TextAlign.right,
                  style: kMessageTextStyle,
                ),
              ),
              Container(
                padding: EdgeInsets.only(right: 15.0),
                child: Text(
                  'in',
                  textAlign: TextAlign.right,
                  style: kMessageTextStyle.copyWith(
                      fontSize: kMessageTextStyle.fontSize! * 0.65),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 15.0),
                child: Text(
                  cityName,
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
