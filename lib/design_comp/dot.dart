import 'package:flutter/material.dart';

class DotWidget extends StatelessWidget {
  final bool isFocused;
  const DotWidget(
      {required this.isFocused});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: isFocused ? 20 : 15,
          height: isFocused ? 20 : 15,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isFocused ? Colors.white : Colors.white.withOpacity(0.5),
          ),
        ),
      ],
    );
  }
}
