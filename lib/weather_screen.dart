import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:weather_app/additional_information_item.dart';
import 'package:weather_app/app_id.dart';
import 'package:weather_app/hourly_forecast_item.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  @override
  void initState() {
    super.initState();
    getCurrentWeather();
  }

  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      String url =
          'https://api.openweathermap.org/data/2.5/forecast?q=Kathmandu&APPID=$appId';
      var response = await http.get(
        Uri.parse(url),
      );
      final value = jsonDecode(response.body);
      if (value['cod'] != '200') {
        throw 'Exception occured';
      }
      return value;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {});
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder(
        future: getCurrentWeather(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }

          if (snapshot.hasError) {
            return Text(
              snapshot.error.toString(),
            );
          }

          final data = snapshot.data!;
          final weatherData = data['list'][0];
          final currentTemperature = weatherData['main']['temp'];
          final currentSky = weatherData['weather'][0]['main'];
          final currentHumidity = weatherData['main']['humidity'];
          final currentPressure = weatherData['main']['pressure'];
          final currentWind = weatherData['wind']['speed'];
          return Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 250,
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                '$currentTemperature K',
                                style: const TextStyle(
                                    fontSize: 32, fontWeight: FontWeight.bold),
                              ),
                              Icon(
                                currentSky == 'Clouds'
                                    ? Icons.cloud
                                    : currentSky == 'Rainy'
                                        ? Icons.cloudy_snowing
                                        : Icons.sunny,
                                size: 60,
                              ),
                              Text(
                                '$currentSky',
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Hourly Forecast',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                // SingleChildScrollView(
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //     children: [
                //       for (int i = 0; i < 5; i++)
                //         HourlyForecastItem(
                //           icon: data['list'][i + 1]['weather'][0]['main'] ==
                //                   'Clouds'
                //               ? Icons.cloud
                //               : data['list'][i + 1]['weather'][0]['main'] ==
                //                       'Rainy'
                //                   ? Icons.cloudy_snowing
                //                   : Icons.sunny,
                //           temp: data['list'][i + 1]['main']['temp'],
                //           time: data['list'][i + 1]['dt'].toString(),
                //         ),
                //     ],
                //   ),
                // ),

                SizedBox(
                  height: 125,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        final hourlyData = data['list'][index + 1];
                        return HourlyForecastItem(
                            icon: Icons.cloud_sharp,
                            temp: hourlyData['main']['temp'].toString(),
                            time: hourlyData['dt'].toString());
                      }),
                ),
                const SizedBox(
                  height: 16,
                ),
                const Text(
                  'Additional Information',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AdditionalInformationItem(
                      icon: const Icon(Icons.water_drop),
                      label: 'Humidity',
                      value: currentHumidity.toString(),
                    ),
                    AdditionalInformationItem(
                      icon: const Icon(Icons.air),
                      label: 'Wind Speed',
                      value: currentWind.toString(),
                    ),
                    AdditionalInformationItem(
                      icon: const Icon(Icons.beach_access),
                      label: 'Pressure',
                      value: currentPressure.toString(),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
