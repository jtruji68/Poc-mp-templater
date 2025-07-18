import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/question.dart';

class QuestionFlowState {
  final int currentIndex;
  final Map<String, dynamic> answers;
  final bool isCompleted;

  QuestionFlowState({
    required this.currentIndex,
    required this.answers,
    required this.isCompleted,
  });

  factory QuestionFlowState.initial() => QuestionFlowState(
    currentIndex: 0,
    answers: {},
    isCompleted: false,
  );

  QuestionFlowState copyWith({
    int? currentIndex,
    Map<String, dynamic>? answers,
    bool? isCompleted,
  }) {
    return QuestionFlowState(
      currentIndex: currentIndex ?? this.currentIndex,
      answers: answers ?? this.answers,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class QuestionFlowCubit extends Cubit<QuestionFlowState> {
  final List<Question> questions;

  QuestionFlowCubit(this.questions) : super(QuestionFlowState.initial());

  void submitAnswer(dynamic answer) {
    final currentQuestion = questions[state.currentIndex];

    final updatedAnswers = Map<String, dynamic>.from(state.answers);
    updatedAnswers[currentQuestion.fieldName] = answer;

    if (state.currentIndex + 1 < questions.length) {
      emit(state.copyWith(
        currentIndex: state.currentIndex + 1,
        answers: updatedAnswers,
      ));
    } else {
      emit(state.copyWith(
        answers: updatedAnswers,
        isCompleted: true,
      ));
    }
  }

  void goBack() {
    if (state.currentIndex > 0) {
      emit(state.copyWith(currentIndex: state.currentIndex - 1));
    }
  }

  void resetFlow() {
    emit(QuestionFlowState.initial());
  }
}