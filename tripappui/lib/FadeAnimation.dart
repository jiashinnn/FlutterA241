import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class FadeAnimation extends StatelessWidget {
  final double delay;
  final Widget child;
  // ignore: use_super_parameters
  const FadeAnimation({required Key key, required this.delay, required this.child}) : super(key: key);

 @override
  Widget build(BuildContext context) {
    final tween = MultiTrackTween([
      Track('opacity').add(const Duration(milliseconds: 500),
      Tween(begin: 0.0, end: 1.0)
      ),
      Track('translateY').add(const Duration(milliseconds: 500),
        Tween(begin: 120.0, end: 0.0),
        curve: Curves.easeOut)
      )
    ]);

    return AnimationController (
      delay: Duration(microseconds: (500 * delay).round()),
      duration: tween.duration,
      tween: tween,
      child: child,
      builderWithChild: (context, child, animation) => Opacity(
        opacity: animation['opacity'],
        child: Transform.translate(
          offset: Offset(0, animation['']),
        ),
      ), vsync: null
    );
  }
  
  

  
}