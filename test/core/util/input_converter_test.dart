import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:number_trivia_clean_architecture/core/util/input_converter.dart';

void main() {
  late InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group("String to unsined int", () {
    test('should return integer when the string represents an unsigned integer',
        () {
      //arrange
      const str = '123';
      //act
      final result = inputConverter.stringToUnsignedInteger(str);
      //assert
      expect(result, const Right(123));
    });

    test('should return failure when string is not an integer', () {
      //arrange
      const str = 'abc';

      //act

      final result = inputConverter.stringToUnsignedInteger(str);
      //assert

      expect(result, Left(InvaildInputFailure()));
    });

    test('should return failure when string is a negative integer', () {
      //arrange
      const str = '-123';

      //act

      final result = inputConverter.stringToUnsignedInteger(str);
      //assert

      expect(result, Left(InvaildInputFailure()));
    });
  });
}
