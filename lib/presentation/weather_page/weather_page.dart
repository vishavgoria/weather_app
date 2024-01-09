import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/presentation/weather_page/widgets/weather_empty.dart';
import 'package:weather_app/state/theme/theme_state.dart';
import '../../state/shared_notifier.dart';
import '../../state/weather/location_notifier.dart';
import '../../state/weather/weather_notifier.dart';
import '../../state/weather/weather_state.dart';
import '../search_page/search_page.dart';
import 'widgets/weather_error.dart';
import 'widgets/weather_loading.dart';
import 'widgets/weather_populated_new.dart';

class WeatherPage extends ConsumerWidget {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(weatherNotifier);
    final themeColor = ref.watch(themeState);
    final weatherFuture = ref.watch(futureWeatherNotifier);
    final sharedPref = ref.read(sharedPreferencesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather'),
        backgroundColor: themeColor.withOpacity(0.5),
        elevation: 0,
        actions: [
          IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () async {
                final city = sharedPref.getString('city');
                if (city != '') {
                  await ref.read(weatherNotifier.notifier).fetchWeather(city);
                } else {
                  ref.read(locationStateProvider.notifier).getLocData().then((data) {
                    if (data != null) {
                      ref.read(locationStateProvider.notifier).getLocAddress(data).then((city) {
                        if (city != null) {
                          final sharedPref = ref.read(sharedPreferencesProvider);
                          sharedPref.setString('city', city);
                          ref.read(weatherNotifier.notifier).fetchWeather(city);
                        }
                      });
                    }
                  });
                }
              }),
          IconButton(
              icon: const Icon(Icons.my_location),
              onPressed: () async {
                ref.read(locationStateProvider.notifier).getLocData().then((data) {
                  if (data != null) {
                    ref.read(locationStateProvider.notifier).getLocAddress(data).then((city) {
                      if (city != null) {
                        final sharedPref = ref.read(sharedPreferencesProvider);
                        sharedPref.setString('city', city);
                        ref.read(weatherNotifier.notifier).fetchWeather(city);
                      }
                    });
                  }
                });
              }),
        ],
      ),
      body: weatherFuture.when(
        data: (data) {
          if (state.status == WeatherStatus.initial) {
            final city = sharedPref.getString('city');
            if (city == '') {
              ref.read(locationStateProvider.notifier).getLocData().then((data) {
                if (data != null) {
                  ref.read(locationStateProvider.notifier).getLocAddress(data).then((city) {
                    if (city != null) {
                      final sharedPref = ref.read(sharedPreferencesProvider);
                      sharedPref.setString('city', city);
                      ref.read(weatherNotifier.notifier).fetchWeather(city);
                    }
                  });
                }
              });
            }
            return const WeatherEmpty();
          } else {
            return WeatherPopulatedNew(
              weatherModels: state.weatherModels,
              onRefresh: () async {
                // return await ref.read(weatherNotifier.notifier).refreshWeather();
              },
            );
          }
        },
        error: (e, st) {
          return const WeatherError();
        },
        loading: () {
          return const WeatherLoading();
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.search, semanticLabel: 'Search'),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SearchPage(),
            ),
          );
        },
      ),
    );
  }
}
