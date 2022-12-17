import 'package:number_trivia_clean_architecture/core/error/exceptions.dart';
import 'package:number_trivia_clean_architecture/core/network/network_info.dart';
import 'package:number_trivia_clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia_clean_architecture/features/number_trivia/domain/entity/number_trivia.dart';
import 'package:number_trivia_clean_architecture/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:number_trivia_clean_architecture/features/number_trivia/domain/repository/number_trivia_repository.dart';

import '../datasource/number_trivia_local_datasource.dart';
import '../datasource/number_trivia_remote_datasource.dart';

typedef Future<NumberTriviaModel> _ConcreteOrRandomChooser();

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });
  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
      int number) async {
    return await _getTrivia(
        () => remoteDataSource.getConcreteNumberTrivia(number));
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    return await _getTrivia(() => remoteDataSource.getRandomNumberTrivia());
  }

/*
by using  

typedef Future<NumberTriviaModel> _ConcreteOrRandomChooser();

instead of passing function return type  
_getTrivia( Future<NumberTrivia> Function() concreteOrRandomChooser)

we can write 
_getTrivia( _ConcreteOrRandomChooser concreteOrRandomChooser)

*/
  Future<Either<Failure, NumberTrivia>> _getTrivia(
      Future<NumberTrivia> Function() concreteOrRandomChooser) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteTrivia = await concreteOrRandomChooser();

        await localDataSource
            .cacheNumberTrivia(remoteTrivia as NumberTriviaModel);
        return Right(remoteTrivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localTrivia = await localDataSource.getLastNumberTrivia();
        return Right(localTrivia);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
