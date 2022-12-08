import 'dart:convert';
import 'dart:ffi';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia_clean_architecture/features/number_trivia/domain/entity/number_trivia.dart';
import 'package:number_trivia_clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';

import '../../../fixtures/fixture_reader.dart';

void main() {
  const tNumberTriviaModel = NumberTriviaModel(number: 1, text: "test");

  test('should be a number trivia entity', () async {
    expect(tNumberTriviaModel, isA<NumberTrivia>());
  });

  group('from json', () {
    test('should return a valid model when the JSON number is an integer',
        () async {
      //arrange
      final Map<String, dynamic> jsonMap = json.decode(fixture('trivia.json'));
      //act
      final result = NumberTriviaModel.fromJson(jsonMap);

      //assert
      expect(result, tNumberTriviaModel);
    });

    test('should return a valid model when the JSON number is an double',
        () async {
      //arrange
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('trivia_double.json'));
      //act
      final result = NumberTriviaModel.fromJson(jsonMap);

      //assert
      expect(result, tNumberTriviaModel);
    });
  });

  group('to json', () {
    test('should return a JSON map containing the proper data', () async {
      //act
      final result = tNumberTriviaModel.toJson();
      final expectedJsonMap = {'text': "test", 'number': 1};
      //assert
      expect(result, expectedJsonMap);
    });
  });
}
