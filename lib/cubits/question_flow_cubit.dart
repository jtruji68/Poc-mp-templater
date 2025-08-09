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
    final visibleQuestions = questions.where((q) {
      if (q.dependsOn == null) return true;
      return state.answers[q.dependsOn] == q.visibleWhen;
    }).toList();

    final currentQuestion = visibleQuestions[state.currentIndex];

    final updatedAnswers = Map<String, dynamic>.from(state.answers);

    if (answer is Map<String, dynamic>) {
      updatedAnswers.addAll(answer);
    } else {
      updatedAnswers[currentQuestion.fieldName] = answer;
    }

    if (state.currentIndex + 1 < visibleQuestions.length) {
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
  void submitMultipleAnswers(Map<String, dynamic> newAnswers) {
    final visibleQuestions = questions.where((q) {
      if (q.dependsOn == null) return true;
      return state.answers[q.dependsOn] == q.visibleWhen;
    }).toList();

    final currentQuestion = visibleQuestions[state.currentIndex];

    final updatedAnswers = Map<String, dynamic>.from(state.answers)
      ..addAll(newAnswers);

    if (state.currentIndex + 1 < visibleQuestions.length) {
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
}