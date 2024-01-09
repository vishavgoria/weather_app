import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/shared_notifier.dart';
import '../state/theme/theme_state.dart';
import '../state/weather/weather_notifier.dart';
import 'weather_page/weather_page.dart';

class WeatherApp extends ConsumerStatefulWidget {
  const WeatherApp({super.key});

  @override
  ConsumerState<WeatherApp> createState() => _WeatherAppState();
}

class _WeatherAppState extends ConsumerState<WeatherApp> {
  @override
  void didChangeDependencies() async {
    final sharedPref = await ref.read(sharedPreferencesProvider);
    final cityShared = sharedPref.getString('city');
    if (cityShared != '') {
      final state = ref.read(weatherNotifier.notifier);
      state.fetchWeather('$cityShared');
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final color = ref.watch(themeState);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: color,
      ),
      home: const WeatherPage(),
    );
  }
}
