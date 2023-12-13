import 'dart:async';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum TimerEvent { start, pause, reset, toggleSound }
enum TimerState { running, paused, finished }

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  TimerBloc() : super(TimerState.paused);

  int _seconds = 30;
  int get seconds => _seconds;
  late Timer _timer;
  bool _soundEnabled = true;

  @override
Stream<TimerState> mapEventToState(TimerEvent event) async* {
  if (event == TimerEvent.start) {
    if (state == TimerState.paused || state == TimerState.finished) {
      _startTimer();
      yield TimerState.running;
    }
  } else if (event == TimerEvent.pause) {
    if (state == TimerState.running) {
      _timer.cancel();
      yield TimerState.paused;
    }
  } else if (event == TimerEvent.reset) {
    _timer.cancel();
    _seconds = 30;
    yield TimerState.paused;
  } else if (event == TimerEvent.toggleSound) {
    _soundEnabled = !_soundEnabled;
    if (_seconds == 0) {
      _timer.cancel();
      yield TimerState.finished;
      if (_soundEnabled) {
        _playBeepSound();
      }
    }
  }
}

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_seconds > 0) {
        _seconds--;
        add(TimerEvent.toggleSound);
      } else {
        _timer.cancel();
        add(TimerEvent.reset);
      }
    });
  }

  void _playBeepSound() async {
    AssetsAudioPlayer.newPlayer().open(
    Audio("assets/audio/countdown_tick.mp3"),
    autoStart: true,
    showNotification: true,
);
  }
}