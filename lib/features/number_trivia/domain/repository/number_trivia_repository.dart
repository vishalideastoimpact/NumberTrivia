import 'package:dartz/dartz.dart';
import 'package:number_trivia_clean_architecture/core/error/failure.dart';
import 'package:number_trivia_clean_architecture/features/number_trivia/domain/entity/number_trivia.dart';

abstract class NumberTriviaRepository {
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int num);
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia();
}
