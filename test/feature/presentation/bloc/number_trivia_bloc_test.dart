import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:number_trivia_clean_architecture/core/error/failure.dart';
import 'package:number_trivia_clean_architecture/core/usecases/usecases.dart';
import 'package:number_trivia_clean_architecture/core/util/input_converter.dart';
import 'package:number_trivia_clean_architecture/features/number_trivia/domain/entity/number_trivia.dart';
import 'package:number_trivia_clean_architecture/features/number_trivia/domain/usecase/get_concrete_number_trivia.dart';
import 'package:number_trivia_clean_architecture/features/number_trivia/domain/usecase/get_random_number_trivia.dart';
import 'package:number_trivia_clean_architecture/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  late NumberTriviaBloc bloc;
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    bloc = NumberTriviaBloc(
      getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
      getRandomNumberTrivia: mockGetRandomNumberTrivia,
      inputConverter: mockInputConverter,
    );
  });

  test("initial state should be empty", () {
    expect(bloc.state, Empty());
  });

  group("GetTriviaForConcreteNumber", () {
    const tNumberString = '1';
    const tNumberParsed = 1;
    const tNumberTrivia = NumberTrivia(text: 'test', number: 1);

    void setUpMockInputConverterSuccess() =>
        when(() => mockInputConverter.stringToUnsignedInteger(any()))
            .thenReturn(const Right(tNumberParsed));

    void setUpmockGetConcreteNumberTriviaSuccess() => when(() =>
            mockGetConcreteNumberTrivia(const Params(number: tNumberParsed)))
        .thenAnswer((_) async => const Right(tNumberTrivia));

    test(
        'should called the inputConverter to validate  and convert the string to an unsigned integer',
        () async {
      //arrange
      setUpMockInputConverterSuccess();
      setUpmockGetConcreteNumberTriviaSuccess();

      //act
      bloc.add(const GetNumberTriviaForConcreteNumber(tNumberString));
      await untilCalled(
          () => mockInputConverter.stringToUnsignedInteger(any()));
      //assert

      verify(() => mockInputConverter.stringToUnsignedInteger(tNumberString));
    });

    test('should emit [Error] when the input is invalid', () async {
      // arrange
      when(() => mockInputConverter.stringToUnsignedInteger(any()))
          .thenReturn(Left(InvaildInputFailure()));
      // assert later
      final expected = emitsInOrder([
        const Error(message: INVALID_INPUT_FAILURE_MESSAGE),
      ]);

      expectLater(bloc.stream.asBroadcastStream(), expected);

      // act
      bloc.add(const GetNumberTriviaForConcreteNumber(tNumberString));
    });

    test('Should get data from concrete use case', () async {
      // arrange
      setUpMockInputConverterSuccess();
      setUpmockGetConcreteNumberTriviaSuccess();
      // act
      bloc.add(const GetNumberTriviaForConcreteNumber(tNumberString));
      //wait until [ mockGetConcreteNumberTrivia(const Params(number: tNumberParsed))] this method hit
      await untilCalled(() =>
          mockGetConcreteNumberTrivia(const Params(number: tNumberParsed)));
      //assert
      verify(() =>
          mockGetConcreteNumberTrivia(const Params(number: tNumberParsed)));
    });

    test('should emit [Loading,Loaded] when data is gottenn successfully',
        () async {
      //arrange
      setUpMockInputConverterSuccess();
      setUpmockGetConcreteNumberTriviaSuccess();

      //act
      bloc.add(const GetNumberTriviaForConcreteNumber(tNumberString));
      //assert later
      final expected = emitsInOrder([
        Loading(),
        const Loaded(tNumberTrivia),
      ]);

      expectLater(bloc.stream.asBroadcastStream(), expected);
    });

    test(
        'should emit [Loading,Error] SERVER FAILURE MESSAGE  when getting data failed',
        () async {
      //arrange
      setUpMockInputConverterSuccess();
      when(() =>
              mockGetConcreteNumberTrivia(const Params(number: tNumberParsed)))
          .thenAnswer((_) async => Left(ServerFailure()));
      //act
      bloc.add(const GetNumberTriviaForConcreteNumber(tNumberString));
      //assert later
      final expected = emitsInOrder(
          [Loading(), const Error(message: SERVER_FAILURE_MESSAGE)]);

      expectLater(bloc.stream.asBroadcastStream(), expected);
    });

    test(
        'should emit [Loading,Error] with Cache failure  message when getting data failed',
        () async {
      //arrange
      setUpMockInputConverterSuccess();
      when(() =>
              mockGetConcreteNumberTrivia(const Params(number: tNumberParsed)))
          .thenAnswer((_) async => Left(CacheFailure()));
      //act
      bloc.add(const GetNumberTriviaForConcreteNumber(tNumberString));
      //assert later
      final expected = emitsInOrder(
          [Loading(), const Error(message: CACHE_FAILURE_MESSAGE)]);

      expectLater(bloc.stream.asBroadcastStream(), expected);
    });
  });

  group("GetTriviaForRandomNumber", () {
    const tNumberTrivia = NumberTrivia(text: 'test', number: 1);

    void setUpmockGetRandomNumberTriviaSuccess() =>
        when(() => mockGetRandomNumberTrivia(NoParams()))
            .thenAnswer((_) async => const Right(tNumberTrivia));

    test('Should get data from random use case', () async {
      //arrange
      setUpmockGetRandomNumberTriviaSuccess();
      //act
      bloc.add(GetNumberTriviaRandomNumber());
      await untilCalled(() => mockGetRandomNumberTrivia(NoParams()));
      //assert
      verify(() => mockGetRandomNumberTrivia(NoParams()));
    });

    test('should emit [Loading,Loaded] when data is gottenn successfully',
        () async {
      //arrange
      setUpmockGetRandomNumberTriviaSuccess();

      //act
      bloc.add(GetNumberTriviaRandomNumber());
      //assert later
      final expected = emitsInOrder([
        Loading(),
        const Loaded(tNumberTrivia),
      ]);

      expectLater(bloc.stream.asBroadcastStream(), expected);
    });

    test(
        'should emit [Loading,Error] SERVER FAILURE MESSAGE  when getting data failed',
        () async {
      //arrange
      when(() => mockGetRandomNumberTrivia(NoParams()))
          .thenAnswer((_) async => Left(ServerFailure()));
      //act
      bloc.add(GetNumberTriviaRandomNumber());
      //assert later
      final expected = emitsInOrder(
          [Loading(), const Error(message: SERVER_FAILURE_MESSAGE)]);

      expectLater(bloc.stream.asBroadcastStream(), expected);
    });

    test(
        'should emit [Loading,Error] with Cache failure  message when getting data failed',
        () async {
      //arrange
      when(() => mockGetRandomNumberTrivia(NoParams()))
          .thenAnswer((_) async => Left(CacheFailure()));
      //act
      bloc.add(GetNumberTriviaRandomNumber());
      //assert later
      final expected = emitsInOrder(
          [Loading(), const Error(message: CACHE_FAILURE_MESSAGE)]);

      expectLater(bloc.stream.asBroadcastStream(), expected);
    });
  });
}
