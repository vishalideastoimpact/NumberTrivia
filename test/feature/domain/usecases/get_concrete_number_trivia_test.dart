import 'package:dartz/dartz.dart';
// import 'package:mockito/mockito.dart';
import 'package:number_trivia_clean_architecture/features/number_trivia/domain/number_trivia.dart';
import 'package:number_trivia_clean_architecture/features/number_trivia/domain/repository/number_trivia_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia_clean_architecture/features/number_trivia/domain/usecase/get_concrete_number_trivia.dart';
import 'package:mocktail/mocktail.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  late GetConcreteNumberTrivia usecase;
  late MockNumberTriviaRepository mockNumberTriviaRepository;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetConcreteNumberTrivia(mockNumberTriviaRepository);
  });

  const tNumber = 1;
  const tNumberTrivia = NumberTrivia(text: 'test', number: 1);

  test('should get trivia for the number from repositoy', () async {
    // When 'getConcreteNumberTrivia' is called, return 'tNumberTrivia'
    //arrange
    when(() => mockNumberTriviaRepository.getConcreteNumberTrivia(any()))
        .thenAnswer((_) async => const Right(tNumberTrivia));

    //act
    final result = await usecase.call(const Params(number: tNumber));

    // final result = await usecase.execute(tNumber);

    //assert
    expect(result, const Right(tNumberTrivia));

    // Verify that the method has been called on the Repository for particular argument
    verify(() => mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber));
    // Only the above method should be called and nothing more.
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}
