import 'dart:async';

import 'package:flutter/material.dart';
import 'package:widget_factory/constants.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class GameState extends ChangeNotifier {
  int _widgets;
  int _factories;
  int _factoryFactories;
  String _statusMessage;

  GameState() {
    reset();
  }

  int get widgets => _widgets;
  int get factories => _factories;
  int get factoryFactories => _factoryFactories;
  String get statusMessage => _statusMessage;

  void update() {
    _widgets += _factories;
    _factories += _factoryFactories;
    notifyListeners();
  }

  void createWidgets(int count) {
    _widgets += count;
    notifyListeners();
  }

  void buildFactoryFactories(int count) {
    int cost = FACTORY_FACTORY_COST * count;
    if (_widgets >= cost) {
      _factoryFactories += count;
      _widgets -= cost;
    } else {
      _statusMessage = "Not enough widgets (need: $FACTORY_FACTORY_COST).";
    }
    notifyListeners();
  }

  void buildFactories(int count) {
    int cost = FACTORY_COST * count;
    if (_widgets >= cost) {
      _factories += count;
      _widgets -= cost;
    } else {
      _statusMessage = "Not enough widgets (need: $FACTORY_COST).";
    }
    notifyListeners();
  }

  void reset() {
    _factories = 0;
    _factoryFactories = 0;
    _widgets = 0;
    _statusMessage = "";
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChangeNotifierProvider(
        create: (context) => GameState(),
        child: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Timer _timer;

  @override
  void initState() {
    _timer = Timer.periodic(Duration(seconds: 1), updateValue);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Consumer<GameState>(builder: (context, game, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Widget count: ${game.widgets}'),
                RaisedButton(
                  child: Text("Create Widget"),
                  onPressed: () => game.createWidgets(1),
                ),
                Spacer(),
                Buttons(),
                Spacer(),
                RaisedButton(
                  child: Text("Reset"),
                  onPressed: () => game.reset(),
                ),
                Text(
                  game.statusMessage,
                  style: TextStyle(color: Theme.of(context).errorColor),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  void updateValue(Timer timer) {
    print("Tick: ${timer.tick}");
    Provider.of<GameState>(context).update();
  }
}

class Buttons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final game = Provider.of<GameState>(context);

    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            RaisedButton(
              child: Text("Build Widget Factory"),
              onPressed: () => game.buildFactories(1),
            ),
            Text("Count: ${game.factories}")
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            RaisedButton(
              child: Text("Build Factory Factory"),
              onPressed: () => game.buildFactoryFactories(1),
            ),
            Text("Count: ${game.factoryFactories}")
          ],
        ),
      ],
    );
  }
}
