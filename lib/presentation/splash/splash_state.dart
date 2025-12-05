class SplashState {
  final bool isDone;

  SplashState({this.isDone = false});

  SplashState copyWith({bool? isDone}) {
    return SplashState(isDone: isDone ?? this.isDone);
  }
}
