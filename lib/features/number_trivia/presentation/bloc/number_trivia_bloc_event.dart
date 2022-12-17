part of 'number_trivia_bloc.dart';

abstract class NumberTriviaEvent extends Equatable {
  const NumberTriviaEvent();

  @override
  List<Object> get props => [];
}

class GetNumberTriviaForConcreteNumber extends NumberTriviaEvent {
  final String numberString;

  const GetNumberTriviaForConcreteNumber(this.numberString);
  @override
  List<Object> get props => [numberString];
}

class GetNumberTriviaRandomNumber extends NumberTriviaEvent {}

class TriviaLoaded extends NumberTriviaEvent {
  final NumberTrivia trivia;

  const TriviaLoaded(this.trivia);
}
