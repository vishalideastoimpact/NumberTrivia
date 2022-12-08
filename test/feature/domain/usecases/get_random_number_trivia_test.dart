import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:number_trivia_clean_architecture/core/usecases/usecases.dart';
import 'package:number_trivia_clean_architecture/features/number_trivia/domain/entity/number_trivia.dart';
import 'package:number_trivia_clean_architecture/features/number_trivia/domain/usecase/get_random_number_trivia.dart';
import 'package:number_trivia_clean_architecture/features/number_trivia/domain/repository/number_trivia_repository.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  late GetRandomNumberTrivia usecase;
  late MockNumberTriviaRepository mockNumberTriviaRepository;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetRandomNumberTrivia(mockNumberTriviaRepository);
  });

  const tNumberTrivia = NumberTrivia(text: 'test', number: 1);
  test('should get trivia from repositoy', () async {
    //arrange
    when(() => mockNumberTriviaRepository.getRandomNumberTrivia())
        .thenAnswer((_) async => const Right(tNumberTrivia));

    //act

    final result = await usecase.call(NoParams());

    // final result = await usecase.execute(tNumber);

    //assert
    expect(result, const Right(tNumberTrivia));

    // Verify that the method has been called on the Repository for particular argument
    verify(() => mockNumberTriviaRepository.getRandomNumberTrivia());
    // Only the above method should be called and nothing more.
    verifyNoMoreInteractions(mockNumberTriviaRepository);
    //assert
  });
}
