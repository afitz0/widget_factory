import 'package:flutter/material.dart';
import 'package:widget_factory/constants.dart';

class GameState with ChangeNotifier {
  double _widgets = 0;
  int _factories = 0;
  int _ram = 1;

  /* Events */
  bool _factoriesTriggered = false;
  bool _ramTriggered = false;

  double get widgets => _widgets;
  int get factories => _factories;
  bool get factoriesTriggered => _factoriesTriggered;
  bool get ramTriggered => _ramTriggered;
  bool get isLowMemory => _widgets > _ram * RAM_CAPACITY * RAM_LOW_THRESHOLD;
  int get ram => _ram;

  void update() {
    _widgets += _factories;
  }

  void createWidget([int count = 1]) {
    _widgets += count;
  }

  void createFactory([int count = 1]) {
    int cost = FACTORY_COST * count;
    if (_widgets >= cost) {
      _factories += count;
      _widgets -= cost;
    } else {}
  }

  void convertFactoryToRam() {
    _ram++;
    _factories -= RAM_FACTORY_COST;
  }

  void tick() {
    _widgets += (_factories * FACTORY_BUILD_RATE) / (1000 / TICK_RATE_MS);

    if (_widgets > FACTORY_COST) _factoriesTriggered = true;
    if (isLowMemory) _ramTriggered = true;
    notifyListeners();
  }

  Widget getStats() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text("Widgets built: ",
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text("${_widgets.toInt()}"),
          ],
        ),
        Visibility(
          visible: factoriesTriggered,
          child: Row(
            children: [
              Text("Widget build rate: ",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(
                  "${(_factories * FACTORY_BUILD_RATE).toStringAsFixed(2)} w/s"),
            ],
          ),
        ),
        Visibility(
          child: Row(
            children: [
              Text("RAM remaining: ",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text("${(_ram * RAM_CAPACITY - _widgets).toInt()}"),
            ],
          ),
          visible: ramTriggered,
        ),
      ],
    );
  }
}
