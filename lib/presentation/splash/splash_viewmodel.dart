import 'package:flutter/material.dart';
import 'splash_state.dart';

class SplashViewModel extends ChangeNotifier {
  SplashState _state = SplashState();

  SplashState get state => _state;

  Future<void> init() async {
    await Future.delayed(const Duration(seconds: 6));
    _state = _state.copyWith(isDone: true);
    notifyListeners();
  }
}
