import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:number_trivia_clean_architecture/core/error/failure.dart';
import 'package:number_trivia_clean_architecture/core/usecases/usecases.dart';
import 'package:number_trivia_clean_architecture/features/number_trivia/domain/entity/number_trivia.dart';
import 'package:number_trivia_clean_architecture/features/number_trivia/domain/repository/number_trivia_repository.dart';

class GetConcreteNumberTrivia implements UseCase<NumberTrivia, Params>{
  final NumberTriviaRepository repository;

  GetConcreteNumberTrivia(this.repository);
  @override
  Future<Either<Failure, NumberTrivia>> call( Params params) async {
    return await repository.getConcreteNumberTrivia(params.number);
  }
  
}

class Params extends Equatable {
  final int number;

  const Params({required this.number});

  @override
  List<Object?> get props => [number];
}
