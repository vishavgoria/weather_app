import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../state/shared_notifier.dart';
import '../../state/theme/theme_state.dart';
import '../../state/weather/weather_notifier.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final TextEditingController _textController = TextEditingController();

  String get _text => _textController.text;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = ref.watch(themeState);
    return Scaffold(
      appBar: AppBar(
          backgroundColor: themeColor.withOpacity(0.5),
          title: const Text('City Search')),
      body: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: TextField(
                controller: _textController,
                decoration: const InputDecoration(
                  labelText: 'City',
                  hintText: 'Chicago',
                ),
              ),
            ),
          ),
          IconButton(
              key: const Key('searchPage_search_iconButton'),
              icon: const Icon(Icons.search, semanticLabel: 'Submit'),
              onPressed: () async {
                final weatherNotifier1 = ref.read(weatherNotifier.notifier);
                if (_text.isNotEmpty) {
                  final sharedPref = await ref.read(sharedPreferencesProvider);
                  await sharedPref.setString('city', _text);
                }
                await weatherNotifier1.fetchWeather(_text).then((value) {

                  Navigator.of(context).pop();
                });
              })
        ],
      ),
    );
  }
}
