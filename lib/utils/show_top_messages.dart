import 'package:flutter/material.dart';

void showTopMessage(BuildContext context, String message) {
  final overlay = Overlay.of(context);
  late OverlayEntry overlayEntry;

  overlayEntry = OverlayEntry(
    builder: (context) => _AnimatedTopMessage(
      message: message,
      onFinished: () {
        overlayEntry.remove();
      },
    ),
  );

  overlay?.insert(overlayEntry);
}

class _AnimatedTopMessage extends StatefulWidget {
  final String message;
  final VoidCallback onFinished;

  const _AnimatedTopMessage({
    Key? key,
    required this.message,
    required this.onFinished,
  }) : super(key: key);

  @override
  _AnimatedTopMessageState createState() => _AnimatedTopMessageState();
}

class _AnimatedTopMessageState extends State<_AnimatedTopMessage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    );
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) {
            setState(() => _visible = false);
            _controller.reverse().then((_) => widget.onFinished());
          }
        });
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() => _visible = true);
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Positioned(
          top: MediaQuery.of(context).padding.top + 10 - (1 - _animation.value) * 50,
          left: 15,
          right: 15,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: _visible ? 1.0 : 0.0,
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Text(
                  widget.message,
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}