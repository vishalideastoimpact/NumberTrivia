import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:number_trivia_clean_architecture/core/error/exceptions.dart';
import 'package:number_trivia_clean_architecture/features/number_trivia/data/datasource/number_trivia_local_datasource.dart';
import 'package:number_trivia_clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../fixtures/fixture_reader.dart';

class MockSharedPreference extends Mock implements SharedPreferences {}

void main() {
  const CACHED_NUMBER_TRIVIA = 'CACHED_NUMBER_TRIVIA';
  late MockSharedPreference mockSharedPreference;
  late NumberTriviaLocalDataSourceImpl numberTriviaLocalDataSourceImpl;
  setUp(() {
    mockSharedPreference = MockSharedPreference();
    numberTriviaLocalDataSourceImpl = NumberTriviaLocalDataSourceImpl(
        sharedPreferences: mockSharedPreference);
  });

  group('Get last Number trivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia_cache.json')));

    test('should return number trivia from json when there is one in cache',
        () async {
      //arrange
      when(() => mockSharedPreference.getString(any()))
          .thenReturn(fixture('trivia_cache.json'));
      //act
      final result =
          await numberTriviaLocalDataSourceImpl.getLastNumberTrivia();

      verify(() => mockSharedPreference.getString(CACHED_NUMBER_TRIVIA));

      //assert
      expect(result, tNumberTriviaModel);
    });

    test('should throw cacheException when there is no data in cache',
        () async {
      //arrange
      when(() => mockSharedPreference.getString(any())).thenReturn(null);
      //act
      // Not calling the method here, just storing it inside a call variable

      final call = numberTriviaLocalDataSourceImpl.getLastNumberTrivia;

      //assert
      expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
    });
  });

  group('cacheNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel(text: 'text', number: 1);
    test('Should call shared preference to cache the data', () {
      when(() => mockSharedPreference.setString(any(), any()))
          .thenAnswer((_) => Future.value(true));

      //act
      numberTriviaLocalDataSourceImpl.cacheNumberTrivia(tNumberTriviaModel);
      //assert
      final expectedJsonString = json.encode(tNumberTriviaModel.toJson());
      verify(() => mockSharedPreference.setString(
          CACHED_NUMBER_TRIVIA, expectedJsonString));
    });
  });
}
