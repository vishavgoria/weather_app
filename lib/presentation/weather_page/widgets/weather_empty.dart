import 'package:flutter/material.dart';

class WeatherEmpty extends StatelessWidget {
  const WeatherEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 48),
          const Text('⛅', style: TextStyle(fontSize: 64)),
          Text(
            'Loading Weather',
            style: theme.textTheme.headline5,
          ),
        ],
      ),
    );
  }
}
