import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
class Typer extends StatelessWidget {
  const Typer({Key? key}) : super(key: key);

    Widget build(BuildContext context) {
      return Column(children: <Widget>[
        const SizedBox(height: 80),
        Center(child: SizedBox(
          width: 500,
          child: DefaultTextStyle(
            style: const TextStyle(
              fontSize: 35,
              fontFamily: 'bobbers',
              color: Colors.yellow
            ),
            child: AnimatedTextKit(
              animatedTexts: [
                TyperAnimatedText("(UN)TRACKABL.ES", textAlign: TextAlign.center)
              ],
              repeatForever: true,
            )
          )
        ))
      ]);
    }
}
