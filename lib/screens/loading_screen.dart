import 'package:clima/screens/location_screen.dart';
import 'package:clima/utilities/weather.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../Model/weather_response.dart';
import '../services/pexels_photo.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    _getLoactionData();
  }

  void _getLoactionData() async {
    try {
      WeatherUtils utils = WeatherUtils();
      WeatherResponse weatherData = await utils.getLoactionWeatherData();

      PexelsPhotoService pexelsPhoto = PexelsPhotoService();
      List<String> photoList =
          await pexelsPhoto.getLoactionPhotos(weatherData.name);

      if (!mounted) return;
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return LocationScreen(
          weatherData: weatherData,
          photoList: photoList,
        );
      }));
    } catch (e) {
      print('Get location data error:$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SpinKitRing(
          color: Colors.white,
          size: 50.0,
        ),
      ),
    );
  }
}
