import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:widget_factory/constants.dart';
import 'package:widget_factory/game_state.dart';

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