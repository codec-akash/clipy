import 'package:flutter/material.dart';

class DisableWidget extends StatelessWidget {
  final bool isDisable;
  final Widget child;
  const DisableWidget(
      {super.key, required this.isDisable, required this.child});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: isDisable,
      child: Opacity(
        opacity: isDisable ? 0.4 : 1.0,
        child: child,
      ),
    );
  }
}
