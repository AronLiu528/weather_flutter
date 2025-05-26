import '../model/weather_response.dart';
import '../services/location.dart';
import '../services/weather_api.dart';

const apiKey = 'fef4951f9240d0baed4ae882304690d0';
const openWeatherMapURL = 'https://api.openweathermap.org/data/2.5/weather';

class WeatherUtils {
  Future<WeatherResponse?> getCityWeatherData(String cityName) async {
    try {
      WeatherApi weatherApi = WeatherApi(
        '$openWeatherMapURL?q=$cityName&appid=$apiKey&units=metric',
      );

      WeatherResponse weatherData = await weatherApi.getWeatherData();

      return weatherData;
    } catch (e) {
      print('取得天氣資料失敗: $e');
      return null;
    }
  }

  Future<WeatherResponse> getLoactionWeatherData() async {
    try {
      Location location = Location();
      await location.getCurrentPosition();

      WeatherApi weatherApi = WeatherApi(
        '$openWeatherMapURL?lat=${location.latitude}&lon=${location.longitude}&appid=$apiKey&units=metric',
      );

      WeatherResponse weatherData = await weatherApi.getWeatherData();

      return weatherData;
    } catch (e) {
      throw Exception('Get loaction weather error:$e');
    }
  }

  String getWeatherIcon(int condition) {
    if (condition < 300) {
      return '🌩';
    } else if (condition < 400) {
      return '🌧';
    } else if (condition < 600) {
      return '☔️';
    } else if (condition < 700) {
      return '☃️';
    } else if (condition < 800) {
      return '🌫';
    } else if (condition == 800) {
      return '☀️';
    } else if (condition <= 804) {
      return '☁️';
    } else {
      return '🤷‍';
    }
  }

  String getMessage(int temp) {
    if (temp > 25) {
      return 'It\'s 🍦 time';
    } else if (temp > 20) {
      return 'Time for shorts and 👕';
    } else if (temp < 10) {
      return 'You\'ll need 🧣 and 🧤';
    } else {
      return 'Bring a 🧥 just in case';
    }
  }
}
