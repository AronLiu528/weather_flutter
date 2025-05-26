import 'package:dio/dio.dart';
import '../model/weather_response.dart';

class WeatherApi {
  WeatherApi(this.url);

  final String url;

  Future<WeatherResponse> getWeatherData() async {
    Dio dio = Dio();
    Response response = await dio.get(url);

    if (response.statusCode == 200) {
      Map<String, dynamic> data = response.data;
      WeatherResponse weatherData = WeatherResponse.fromJson(data);
      return weatherData;
    } else {
      throw Exception('API error statusCode = ${response.statusCode}');
    }
  }
}
