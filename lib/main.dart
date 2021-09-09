import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widget_factory/constants.dart';

import 'package:widget_factory/game_state.dart';

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

class WidgetFactory extends StatefulWidget {
  const WidgetFactory({Key? key}) : super(key: key);

  @override
  _WidgetFactoryState createState() => _WidgetFactoryState();
}

class _WidgetFactoryState extends State<WidgetFactory> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Visibility(
              visible: Provider.of<GameState>(context).isLowMemory,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Flexible(
                  child: Text(
                    "!WARNING!\nDangerously low memory. Build more RAM modules to avoid catastrophic meltdown.\n!WARNING!",
                    style: TextStyle(
                      color: Colors.red,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ElevatedButton(
                      onPressed: () => createAndStart(context),
                      child: Text("Build Widget"),
                    ),
                    ...buildAdvancedButtons(context),
                  ],
                ),
                Provider.of<GameState>(context, listen: false).getStats(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void createAndStart(BuildContext context) {
    Provider.of<GameState>(context, listen: false).createWidget();
    if (_timer == null) {
      _timer = Timer.periodic(Duration(milliseconds: TICK_RATE_MS), (timer) {
        setState(() {
          Provider.of<GameState>(context, listen: false).tick();
        });
      });
    }
  }

  List<Widget> buildAdvancedButtons(BuildContext context) {
    List<Widget> newButtons = [];
    double widgetsBuilt = Provider.of<GameState>(context).widgets;
    bool firstFactory = Provider.of<GameState>(context).factoriesTriggered;

    if (Provider.of<GameState>(context).factoriesTriggered) {
      newButtons.add(Factories());
    }

    if (Provider.of<GameState>(context).ramTriggered) {
      newButtons.add(LowMemory());
    }

    return newButtons;
  }
}

class LowMemory extends StatelessWidget {
  const LowMemory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ElevatedButton(
              onPressed:
                  Provider.of<GameState>(context).widgets < RAM_FACTORY_COST
                      ? null
                      : () => Provider.of<GameState>(context, listen: false)
                          .convertFactoryToRam(),
              child: Text("Convert Factory to RAM"),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0),
              child: Text(Provider.of<GameState>(context).ram.toString()),
            ),
          ],
        ),
      ],
    );
  }
}

class Factories extends StatelessWidget {
  const Factories({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ElevatedButton(
                onPressed:
                    Provider.of<GameState>(context).widgets < FACTORY_COST
                        ? null
                        : () => Provider.of<GameState>(context, listen: false)
                            .createFactory(),
                child: Text("Build Factory"),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child:
                    Text(Provider.of<GameState>(context).factories.toString()),
              )
            ],
          ),
          Text("Cost: $FACTORY_COST"),
        ],
      ),
    );
  }
}
