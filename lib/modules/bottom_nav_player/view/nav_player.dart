import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NavPlayer extends StatelessWidget {
  final ValueNotifier expandPlayer;
  final ValueNotifier scrollValue;
  NavPlayer({Key key, this.expandPlayer, this.scrollValue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      transformAlignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Color(0xFF4C65F6),
        borderRadius: expandPlayer.value
            ? BorderRadius.circular(40)
            : BorderRadius.circular(20),
      ),
      child: Container(
        child: Stack(
          fit: StackFit.expand,
          children: [
            //se muestra cuando esta abierto
            AnimatedOpacity(
              duration: const Duration(milliseconds: 100),
              opacity: expandPlayer.value ? 1.0 : 0.0,
              child: _OpenContent(
                scrollValue: scrollValue,
              ),
            ),
            //se muestra cuando esta cerrado
            AnimatedPositionedDirectional(
              duration: const Duration(milliseconds: 100),
              bottom: expandPlayer.value ? -10 : 4,
              start: expandPlayer.value ? 0.0 : 1.0,
              end: expandPlayer.value ? 1.0 : 0.0,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 100),
                opacity: expandPlayer.value ? 0.0 : 1.0,
                child: Center(
                  child: _ClosedContent(
                    onTap: _openNav,
                  ),
                ),
              ),
            ),
            //scroll handler
            (expandPlayer.value)
                ? Positioned(
                    top: 0,
                    height: size.height * .045,
                    left: 0,
                    right: 0,
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                        child: Container(
                          color: Colors.transparent,
                        ),
                      ),
                      onVerticalDragUpdate: _verticalDragUpdate,
                      onVerticalDragEnd: _verticalDragEnd,
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  void _openNav() {
    if (!expandPlayer.value && scrollValue.value == 0.0) {
      HapticFeedback.mediumImpact();
      expandPlayer.value = true;
    }
  }

  void _verticalDragUpdate(DragUpdateDetails details) {
    if (expandPlayer.value) {
      if (details.localPosition.dy > 0.0 && details.localPosition.dy < 255.0) {
        scrollValue.value = details.localPosition.dy;
      } else if (details.localPosition.dy > 0.0) {
        expandPlayer.value = false;
      }
    }
  }

  void _verticalDragEnd(DragEndDetails details) {
    if (expandPlayer.value && scrollValue.value >= 100.0) {
      expandPlayer.value = false;
    } else {
      scrollValue.value = 0.0;
    }
  }
}

//se muestra cuando esta cerrado
class _ClosedContent extends StatelessWidget {
  final VoidCallback onTap;
  const _ClosedContent({Key key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      width: size.width * .5,
      // color: Colors.red,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        // mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Container(
              child: Center(
                child: Icon(
                  Icons.crop_square_rounded,
                  size: 34,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: onTap,
              child: Container(
                child: Center(
                  child: CircleAvatar(
                    backgroundImage:
                        AssetImage('assets/img/bottom_nav_player/img1.png'),
                    radius: 28,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: Center(
                child: CircleAvatar(
                  backgroundImage:
                      AssetImage('assets/img/bottom_nav_player/avatar.png'),
                  radius: 18,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

//widget que se muestra cuando esta abierto
class _OpenContent extends StatelessWidget {
  final ValueNotifier<double> scrollValue;

  const _OpenContent({Key key, this.scrollValue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return ValueListenableBuilder<double>(
      valueListenable: scrollValue,
      builder: (_, scroll, child) {
        return Container(
          height: double.infinity,
          width: double.infinity,
          child: Stack(
            children: [
              //handler
              Positioned(
                top: 10,
                left: 0.0,
                right: 0.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Opacity(
                      opacity: (1 - (scrollValue.value / 500)).clamp(0.0, 1.0),
                      child: Container(
                        height: size.height * 0.01,
                        constraints: BoxConstraints(
                            minWidth: size.width * 0.1,
                            maxWidth: size.width * 0.12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              //album img
              Positioned(
                top: 35 + (scroll / 20),
                left: 0,
                right: 0,
                child: const _AlbumImg(),
              ),
              //blur slider
              Positioned(
                top: 290 + (scroll / 20),
                left: 0,
                right: 0,
                child: Opacity(
                  opacity: (1 - (scrollValue.value / 200)).clamp(0.0, 1.0),
                  child: const _BlurSlider(),
                ),
              ),
              //names
              Positioned(
                top: 210,
                left: 0,
                right: 0,
                child: Container(
                  child: Center(
                    child: Column(
                      children: [
                        Opacity(
                          opacity:
                              (1 - (scrollValue.value / 210)).clamp(0.0, 1.0),
                          child: Text(
                            'EDX',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.3),
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Opacity(
                          opacity:
                              (1 - (scrollValue.value / 450)).clamp(0.0, 1.0),
                          child: Text(
                            'Indian Summer',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              //controlls
              Positioned(
                bottom: 40 - (scroll / 6),
                left: 0,
                right: 0,
                height: size.height * .078,
                child: Opacity(
                  opacity: (1 - (scrollValue.value / 200)).clamp(0.0, 1.0),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shuffle,
                          size: 36,
                          color: Colors.white,
                        ),
                        Icon(
                          Icons.pause,
                          size: 36,
                          color: Colors.white,
                        ),
                        Icon(
                          Icons.repeat,
                          size: 36,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

//imagen del album
class _AlbumImg extends StatelessWidget {
  const _AlbumImg({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: 6,
              right: 6,
              bottom: -10,
              child: Container(
                height: size.height * .12,
                width: size.height * .12,
                decoration: BoxDecoration(
                  color: Colors.indigo[900],
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(20),
                  ),
                ),
              ),
            ),
            Container(
              height: size.height * .15,
              width: size.height * .15,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  'assets/img/bottom_nav_player/img1.png',
                  fit: BoxFit.cover,
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}

//slider
class _BlurSlider extends StatelessWidget {
  const _BlurSlider({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ClipRect(
      child: Container(
        height: size.height * .078,
        decoration: BoxDecoration(
          color: Colors.transparent,
          boxShadow: [
            BoxShadow(
              color: Colors.transparent,
            )
          ],
        ),
        // alignment: Alignment.center,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              color: Color(0xFF4C65F6),
              child: Row(
                // physics: NeverScrollableScrollPhysics(),
                // scrollDirection: Axis.horizontal,
                children: [
                  Flexible(
                    child: Align(
                      widthFactor: 1.0,
                      child: ClipOval(
                        child: Container(
                          height: size.height * .067,
                          // width: size.height * .068,
                          color: Color(0xFF4C65F6),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Align(
                      widthFactor: 1.8,
                      child: ClipOval(
                        child: Container(
                          height: size.height * .067,
                          // width: size.height * .068,
                          color: Color(0xFF4C65F6),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Align(
                      widthFactor: 1.1,
                      child: ClipOval(
                        child: Container(
                          height: size.height * .067,
                          // width: size.height * .068,
                          color: Colors.blue[100].withOpacity(0.1),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Align(
                      widthFactor: 0.8,
                      child: ClipOval(
                        child: Container(
                          height: size.height * .067,
                          // width: size.height * .068,
                          color: Color(0xFF3981E9),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Align(
                      widthFactor: 0.9,
                      child: ClipOval(
                        child: Container(
                          height: size.height * .067,
                          // width: size.height * .068,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Align(
                      widthFactor: 0.7,
                      child: ClipOval(
                        child: Container(
                          height: size.height * .067,
                          // width: size.height * .068,
                          color: Colors.greenAccent[400],
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Align(
                      widthFactor: 0.8,
                      child: ClipOval(
                        child: Container(
                          height: size.height * .067,
                          // width: size.height * .067
                          color: Colors.greenAccent[400],
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Align(
                      widthFactor: 0.8,
                      child: ClipOval(
                        child: Container(
                          height: size.height * .067,
                          // width: size.height * .068,
                          color: Color(0xFF3981E9).withOpacity(0.6),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Align(
                      widthFactor: 0.8,
                      child: ClipOval(
                        child: Container(
                          height: size.height * .067,
                          // width: size.height * .068,
                          color: Color(0xFF3981E9),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Align(
                      widthFactor: 0.7,
                      child: ClipOval(
                        child: Container(
                          height: size.height * .067,
                          // width: size.height * .068,
                          color: Color(0xFFAE52FF),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Align(
                      widthFactor: 0.7,
                      child: ClipOval(
                        child: Container(
                          height: size.height * .067,
                          // width: size.height * .068,
                          color: Color(0xFFAE52FF),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              height: size.height * .067,
              width: double.infinity,
            ),
            //al momento que se expande el reproductor, el blur tiene unos parpadeos
            //a los costados, creo que es el backdropfilter pero no supe arreglarlo
            BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 6.0,
                sigmaY: 9.0,
              ),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  // boxShadow: [
                  //   BoxShadow(
                  //       color: Colors.transparent,
                  //       blurRadius: 2,
                  //       spreadRadius: 3)
                  // ],
                ),
                height: size.height * .78,
              ),
            ),
            Container(
              height: size.height * .045,
              width: size.width * 0.01,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
            )
          ],
        ),
      ),
    );
  }
}
