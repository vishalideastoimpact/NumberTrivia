import 'package:dartz/dartz.dart';
import 'package:number_trivia_clean_architecture/core/error/failure.dart';

class InputConverter {
  Either<Failure, int> stringToUnsignedInteger(String strNumber) {
    try {
      print("stringToUnsignedInteger method call");
      final integer = int.parse(strNumber);
      if (integer < 0) throw const FormatException();
      return Right(integer);
    } on FormatException {
      return Left(InvaildInputFailure());
    }
  }
}

class InvaildInputFailure extends Failure {
  @override
  List<Object?> get props => [];
}
