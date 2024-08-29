import 'package:flutter/material.dart';

class SlideAndFadeTransition extends PageRouteBuilder {
  final Widget page;

  SlideAndFadeTransition({required this.page})
    : super(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          var slideAnimation = Tween(begin: begin, end: end).animate(animation);
          var fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(animation);
          return SlideTransition(
            position: slideAnimation,
            child: FadeTransition(opacity: fadeAnimation, child: child),
          );
        },
      );
}

