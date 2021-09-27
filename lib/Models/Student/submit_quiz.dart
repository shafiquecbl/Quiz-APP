class SubmitQuiz {
  SubmitQuiz({
    this.quizId,
    this.questionId,
    this.correctAnswer,
  });

  String? quizId, questionId, correctAnswer;

  Map<String, dynamic> toJson() => {
        'quiz': quizId,
        'question': questionId,
        'answer': correctAnswer,
      };
}
