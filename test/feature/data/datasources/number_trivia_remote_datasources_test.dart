import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:number_trivia_clean_architecture/core/error/exceptions.dart';
import 'package:number_trivia_clean_architecture/features/number_trivia/data/datasource/number_trivia_remote_datasource.dart';
import 'package:number_trivia_clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';

import '../../../fixtures/fixture_reader.dart';
import 'package:http/http.dart' as http;

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late MockHttpClient mockHttpClient;
  late NumberTriviaRemoteDataSourceImpl dataSource;
  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });
  const tNumber = 1;
  setupMockHttpClientSuccess200() {
    when(() => mockHttpClient.get(Uri.parse('http://numbersapi.com/$tNumber'),
            headers: any(named: 'headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  setupMockHttpClientFailure404() {
    when(() => mockHttpClient.get(Uri.parse('http://numbersapi.com/$tNumber'),
            headers: any(named: 'headers')))
        .thenAnswer((_) async => http.Response("Something went wrong", 404));
  }

  setupMockHttpClientSuccessRandom200() {
    when(() => mockHttpClient.get(Uri.parse('http://numbersapi.com/random'),
            headers: any(named: 'headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  setupMockHttpClientFailureRandom404() {
    when(() => mockHttpClient.get(Uri.parse('http://numbersapi.com/random'),
            headers: any(named: 'headers')))
        .thenAnswer((_) async => http.Response("Something went wrong", 404));
  }

  group("getConcreteNumberTrivia", () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    test(
        'should preform a GET request on a URL with number being the endpoint and with application/json header',
        () {
      //arrange
      setupMockHttpClientSuccess200();
      //act
      dataSource.getConcreteNumberTrivia(tNumber);
      //assert
      //verify that [mockHttpClient.get()] has been hit
      verify(() => mockHttpClient.get(
            Uri.parse('http://numbersapi.com/$tNumber'),
            headers: {
              'Content-Type': 'application/json',
            },
          ));
    });

    test("should return NumberTrivia when the response code is 200", () async {
      setupMockHttpClientSuccess200();

      final result = await dataSource.getConcreteNumberTrivia(tNumber);
      expect(result, equals(tNumberTriviaModel));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      //arrange
      setupMockHttpClientFailure404();

      // act
      final call = dataSource.getConcreteNumberTrivia;

      expect(
          () => call(tNumber), throwsA(const TypeMatcher<ServerException>()));
    });
  });

  group("getRandomNumberTrivia", () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    test(
        'should preform a GET request on a URL with *random* endpoint and with application/json header',
        () {
      //arrange
      setupMockHttpClientSuccessRandom200();
      //act
      dataSource.getRandomNumberTrivia();
      //assert
      //verify that [mockHttpClient.get()] has been hit
      verify(() => mockHttpClient.get(
            Uri.parse('http://numbersapi.com/random'),
            headers: {
              'Content-Type': 'application/json',
            },
          ));
    });

    test("should return NumberTrivia when the response code is 200", () async {
      setupMockHttpClientSuccessRandom200();

      final result = await dataSource.getRandomNumberTrivia();
      expect(result, equals(tNumberTriviaModel));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      //arrange
      setupMockHttpClientFailureRandom404();

      // act
      final call = dataSource.getRandomNumberTrivia;

      expect(() => call(), throwsA(const TypeMatcher<ServerException>()));
    });
  });
}
