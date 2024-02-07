import 'package:weather_app/secrets.dart';
import 'package:http/http.dart' as http;

class WeatherDataProvider{
  Future<String> getCurrentWeather() async {
    try {
      String url =
          'https://api.openweathermap.org/data/2.5/forecast?q=Kathmandu&APPID=$appId';
      var response = await http.get(
        Uri.parse(url),
      );

      return response.body;
    } catch (e) {
      throw e.toString();
    }
  }
}