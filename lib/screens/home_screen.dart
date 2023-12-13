import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:meal_timer/design_comp/circular_cont.dart';
import 'package:meal_timer/design_comp/dot.dart';
import 'package:meal_timer/design_comp/toggle.dart';

class TimerScreen extends StatefulWidget {
  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen>
    with SingleTickerProviderStateMixin {
  late Timer _timer;
  int _secondsRemaining = 30;
  bool _isRunning = false;
  late AnimationController _controller;
  bool _isSoundEnabled = true;
  late FocusNode _firstDotFocusNode;
  late FocusNode _secondDotFocusNode;
  late FocusNode _thirdDotFocusNode;
  String title = "Nom nom:)";
  String subtitle =
      "You have 10 minutes to eat before the pause.\nFocus on eating slowly.";
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reset();
        if (_isRunning && _secondsRemaining > 0) {
          setState(() {
            _secondsRemaining--;
            if (_secondsRemaining >= 0 && _secondsRemaining < 5) {
              _playSound();
            }
          });
        }
      }
    });
    _timer = Timer.periodic(Duration(seconds: 1), _updateTimer);
    _firstDotFocusNode = FocusNode();
    _secondDotFocusNode = FocusNode();
    _thirdDotFocusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _firstDotFocusNode.requestFocus();
    });
  }

  void _updateTimer(Timer timer) {
    if (_isRunning && _secondsRemaining > 0) {
      setState(() {
        _secondsRemaining--;
        if (_secondsRemaining >= 0 && _secondsRemaining < 5) {
          _playSound();
        }
        if (_secondsRemaining == 0) {
          _focusNextDot();
        }
      });
    }
  }

  void _playSound() {
    // print("hello1");
    if (_isSoundEnabled) {
      AssetsAudioPlayer.newPlayer().open(
        Audio("assets/audio/countdown_tick.mp3"),
        autoStart: true,
        showNotification: true,
      );
    }
    // print("hello");
  }

  void _toggleTimer() {
    setState(() {
      _isRunning = !_isRunning;
    });
  }

  void _resetTimer() {
    setState(() {
      _secondsRemaining = 30;
      _isRunning = false;
      // _resetFocus();
    });
  }

  void _toggleSound(bool value) {
    setState(() {
      print("val:${value}");
      _isSoundEnabled = value;
      print("isSOundEnabled:${_isSoundEnabled}");
    });
  }

  void _resetFocus() {
    FocusScope.of(context).requestFocus(_firstDotFocusNode);
  }

  void _focusNextDot() {
    if (_secondsRemaining == 0) {
      if (_firstDotFocusNode.hasFocus) {
        FocusScope.of(context).requestFocus(_secondDotFocusNode);
        title = "Break Time";
        subtitle =
            "Take a five-minute break to check in on your level of fullnes";
      } else if (_secondDotFocusNode.hasFocus) {
        FocusScope.of(context).requestFocus(_thirdDotFocusNode);
        title = "Finish your meal";
        subtitle = "You can eat until you feel full";
      }
    }
    _resetTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    _firstDotFocusNode.dispose();
    _secondDotFocusNode.dispose();
    _thirdDotFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double progress = _secondsRemaining / 30.0;
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.7),
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.7),
        leading: Icon(
          Icons.arrow_back,
          color: Colors.white.withOpacity(0.9),
        ),
        title: Text(
          'Mindful Meal Timer',
          style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.w500,
              fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Focus(
                    focusNode: _firstDotFocusNode,
                    child: DotWidget(
                      isFocused: _firstDotFocusNode.hasFocus,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Focus(
                    focusNode: _secondDotFocusNode,
                    child: DotWidget(
                      isFocused: _secondDotFocusNode.hasFocus,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Focus(
                    focusNode: _thirdDotFocusNode,
                    child: DotWidget(
                      isFocused: _thirdDotFocusNode.hasFocus,
                    ),
                  )
                ],
              ),
              SizedBox(height: 20),
              Text(
                title,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 40,
              ),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: progress, end: progress),
                duration: Duration(seconds: 1),
                builder: (context, value, child) {
                  return Stack(alignment: Alignment.center, children: [
                    Stack(alignment: Alignment.center,
                      children: [
                        Container(
                          height: 280,
                          width: 280,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all(color: Colors.grey, width: 28),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(
                              value: value,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.green),
                              strokeWidth: 10,
                            ),
                          ),
                        ),
                        Container(
                          height: 215,
                          width: 215,
                          // alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: CustomPaint(
                              painter: ClockDialPainter(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Container(
                    //   height: 280,
                    //   width: 280,
                    //   decoration: BoxDecoration(
                    //       shape: BoxShape.circle,
                    //       color: Colors.white,
                    //       border: Border.all(color: Colors.grey, width: 28)),
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(16.0),
                    //     child: CircularProgressIndicator(
                    //       value: value,
                    //       valueColor:
                    //           AlwaysStoppedAnimation<Color>(Colors.green),
                    //       strokeWidth: 10,
                    //     ),
                    //   ),
                    // ),
                    Column(
                      children: [
                        Text(
                          '00 : $_secondsRemaining',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "minutes remaining",
                          style:
                              TextStyle(color: Colors.black.withOpacity(0.6)),
                        )
                      ],
                    ),
                  ]);
                },
              ),
              SizedBox(
                height: 20,
              ),
              _isSoundEnabled ? Text('Sound On') : Text('Sound Off'),
              Toggle(
                value: _isSoundEnabled,
                onChanged: (bool value) {
                  _toggleSound(value);
                },
              ),
              _isSoundEnabled
                  ? Text(
                      'Sound On',
                      style: TextStyle(color: Colors.white),
                    )
                  : Text(
                      'Sound Off',
                      style: TextStyle(color: Colors.white),
                    ),
              SizedBox(height: 5),
              GestureDetector(
                onTap: _toggleTimer,
                child: Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width * .9,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.green.withOpacity(0.9),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green,
                        offset: Offset(0, 4),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    _isRunning ? 'PAUSE' : 'START',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                // onTap: _resetTimer,
                child: Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width * .9,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withOpacity(0.3))
                      // color: Colors.green
                      ),
                  alignment: Alignment.center,
                  child: Text(
                    "LET'S STOP. I'M FULL NOW.",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
