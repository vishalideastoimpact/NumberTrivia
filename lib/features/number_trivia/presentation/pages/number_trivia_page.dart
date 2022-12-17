import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_trivia_clean_architecture/features/number_trivia/presentation/widgets/widgets.dart';
import 'package:number_trivia_clean_architecture/injection_container.dart';

import '../bloc/number_trivia_bloc.dart';

class NumberTriviaWidget extends StatelessWidget {
  const NumberTriviaWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Number Trivia')),
      body:const SingleChildScrollView(child: Body()),
    );
  }
}

class Body extends StatelessWidget {
  const Body({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<NumberTriviaBloc>(),
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
            builder: (context, state) {
              if (state is Empty) {
                return const MessageDisplay(
                  message: "Start searching!",
                );
              } else if (state is Error) {
                return MessageDisplay(message: state.message);
              } else if (state is Loading) {
                return const LoadingWidget();
              } else if (state is Loaded) {
                return TriviaDisplay(
                  numberTrivia: state.trivia,
                );
              }
              return SizedBox(
                height: MediaQuery.of(context).size.height / 3,
                child: const Placeholder(),
              );
            },
          ),
          const SizedBox(
            height: 20,
          ),
          const TriviaControls()
        ],
      ),
    );
  }
}
