class OnboardingState {
  final int currentPage;
  final int totalPages;

  OnboardingState({
    this.currentPage = 0,
    this.totalPages = 3,
  });

  OnboardingState copyWith({
    int? currentPage,
    int? totalPages,
  }) {
    return OnboardingState(
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
    );
  }

  bool get isLastPage => currentPage == totalPages - 1;
  bool get isFirstPage => currentPage == 0;
}
