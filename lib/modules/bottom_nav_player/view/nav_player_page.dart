import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:retos_flutter_fb/modules/bottom_nav_player/view/cards_list.dart';
import 'package:retos_flutter_fb/modules/bottom_nav_player/view/nav_player.dart';

class NavPlayerPage extends StatelessWidget {
  NavPlayerPage({Key key}) : super(key: key);

  final expandPlayer = ValueNotifier(false);
  final scrollValue = ValueNotifier(0.0);

  final curveOut = ElasticOutCurve(0.9);
  final curveIn = ElasticOutCurve(2);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: ValueListenableBuilder<bool>(
        valueListenable: expandPlayer,
        builder: (context, open, _) {
          return ValueListenableBuilder<double>(
            valueListenable: scrollValue,
            builder: (context, scroll, child) {
              return Stack(
                children: [
                  const CardsList(),
                  AnimatedPositioned(
                    child: child,
                    top: open
                        ? size.height * .40 + (scroll * .5)
                        : size.height * .87,
                    bottom: open ? 0.0 + (scroll * .08) : size.height * .05,
                    left: open ? 0.0 + (scroll * .2) : size.width * .25,
                    right: open ? 0.0 + (scroll * .2) : size.width * .25,
                    curve: open ? curveOut : curveIn,
                    duration: const Duration(milliseconds: 700),
                    onEnd: () {
                      if (scrollValue.value > 0) {
                        scrollValue.value = 0.0;
                      }
                    },
                  ),
                ],
              );
            },
            child: NavPlayer(
              expandPlayer: expandPlayer,
              scrollValue: scrollValue,
            ),
          );
        },
      ),
    );
  }
}
