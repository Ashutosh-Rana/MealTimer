
import 'package:flutter/material.dart';

class Toggle extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const Toggle({super.key, required this.value,required this.onChanged});

  @override
  State<Toggle> createState() => _ToggleState();
}

class _ToggleState extends State<Toggle> {
  //_ToggleState(bool value, VoidCallback onPressed);
  late bool light;

  @override
  void initState() {
    super.initState();
    light = widget.value;
  }

  @override
  void didUpdateWidget(covariant Toggle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      light = widget.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Switch(
      // This bool value toggles the switch.
      value: light,
      activeColor: Colors.white,
      activeTrackColor: Colors.green,
      inactiveTrackColor: Colors.grey,
      inactiveThumbColor: Colors.white,
      //splashRadius: 5.0,
      trackOutlineColor:
          MaterialStateProperty.all(Colors.grey),
      onChanged: (bool value) {
        setState(() {
          light = value;
        });
        widget.onChanged(value);  
      },
    );
  }
}