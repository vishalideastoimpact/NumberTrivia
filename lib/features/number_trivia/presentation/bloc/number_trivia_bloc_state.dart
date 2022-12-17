part of 'number_trivia_bloc.dart';

abstract class NumberTriviaState extends Equatable {
  const NumberTriviaState();

  @override
  List<Object> get props => [];
}

//i.e empty state
class Empty extends NumberTriviaState {}

class Loaded extends NumberTriviaState {
  final NumberTrivia trivia;

  const Loaded(this.trivia);
}

class Loading extends NumberTriviaState {}

class Error extends NumberTriviaState {
  final String message;
  const Error({required this.message});
}
