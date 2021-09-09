import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:widget_factory/constants.dart';
import 'package:widget_factory/game_state.dart';

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
