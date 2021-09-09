import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:widget_factory/game_state.dart';
import 'package:widget_factory/widget_factory.dart';

void main() => runApp(
      ChangeNotifierProvider(
        create: (_) => GameState(),
        child: App(),
      ),
    );

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WidgetFactory(),
    );
  }
}