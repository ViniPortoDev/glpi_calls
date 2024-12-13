class Failure implements Exception {
  final String message;
  Failure({required this.message});

  List<Object?> get props => [message];
}
