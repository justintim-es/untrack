import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
class HighWay extends StatelessWidget {
  const HighWay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
        decoration: BoxDecoration(),
        position: DecorationPosition.background,
        child: RiveAnimation.asset('assets/rischiv/noscho.riv')
    );
  }
}
