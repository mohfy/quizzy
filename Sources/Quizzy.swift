import Adwaita
import Foundation

@main
struct Quizzy: App {

  let app = AdwaitaApp(id: "com.mohfy.quizzy")

  var scene: Scene {
    Window(id: "main") { window in
      NavigationViewDemo(app: app)
        .topToolbar {
          ToolbarView(app: app, window: window)
        }
    }
    .defaultSize(width: 600, height: 450)
  }
}

struct NavigationViewDemo: View {
  @State private var fileDialog = Signal()
  @State private var url: URL?
  @State private var stack = NavigationStack<Int>()
  var app: AdwaitaApp
  var view: Body {
    NavigationView($stack, "initial view") { component in
      if component == 2 {
        ResultView(score: QuizView.score, totalQuestions: QuizView.totalQuestions, stack: $stack)
      } else {
        QuizView(url: url, stack: $stack)
      }
    } initialView: {
      VStack(spacing: 10) {
        Text("quiz file?")
        Button("Upload") {
          fileDialog.signal()
          stack.push(1)
        }
        .suggested()
        .pill()
        .frame(maxWidth: 100)
        .padding()
        .fileImporter(open: fileDialog, extensions: ["quizzy"]) {
          url = $0
        } onClose: {

        }
      }
    }
  }
}

struct Quiz: Codable {
  let title: String
  let content: [content]
}

struct content: Codable {
  let question: String
  let option1: String
  let option2: String
  let option3: String
  let option4: String
  let answer: Int
}

struct QuestionItem: Identifiable {
  let id: Int
  let question: content
}

struct QuizView: View {
  let url: URL?
  @Binding var stack: NavigationStack<Int>
  @State private var quiz: Quiz?
  @State private var errorMessage: String?
  @State private var selectedAnswers: [Int: Int] = [:] // [questionId: selectedOption]
  @State private var currentQuestionIndex: Int = 0
  static var score: Int = 0
  static var totalQuestions: Int = 0

  var view: Body {
    if let quiz = quiz {
      let questions = quiz.content.enumerated().map { QuestionItem(id: $0.0, question: $0.1) }
      VStack(spacing: 10) {
        Text(quiz.title).title2()
          .padding()

        if currentQuestionIndex < questions.count {
          let item = questions[currentQuestionIndex]
          Box(spacing: 0) {
            VStack(spacing: 8) {
              Text("Question \(item.id + 1) of \(questions.count)")
              Text(item.question.question)
                .padding()

              if selectedAnswers[item.id] == 1 {
                Button("A. \(item.question.option1)") {
                  selectedAnswers[item.id] = 1
                }
                .suggested()
                .padding()
              } else {
                Button("A. \(item.question.option1)") {
                  selectedAnswers[item.id] = 1
                }
                .padding()
              }

              if selectedAnswers[item.id] == 2 {
                Button("B. \(item.question.option2)") {
                  selectedAnswers[item.id] = 2
                }
                .suggested()
                .padding()
              } else {
                Button("B. \(item.question.option2)") {
                  selectedAnswers[item.id] = 2
                }
                .padding()
              }

              if selectedAnswers[item.id] == 3 {
                Button("C. \(item.question.option3)") {
                  selectedAnswers[item.id] = 3
                }
                .suggested()
                .padding()
              } else {
                Button("C. \(item.question.option3)") {
                  selectedAnswers[item.id] = 3
                }
                .padding()
              }

              if selectedAnswers[item.id] == 4 {
                Button("D. \(item.question.option4)") {
                  selectedAnswers[item.id] = 4
                }
                .suggested()
                .padding()
              } else {
                Button("D. \(item.question.option4)") {
                  selectedAnswers[item.id] = 4
                }
                .padding()
              }

              HStack(spacing: 10) {
                if currentQuestionIndex > 0 {
                  Button(icon: .default(icon: .goPrevious)) {
                    currentQuestionIndex -= 1
                  }
                  .padding()
                } else {
                  Button(icon: .default(icon: .goPrevious)) { }
                  .padding()
                }

                Box(spacing: 0)
                  .hexpand()

                if currentQuestionIndex == questions.count - 1 {
                  Button("Submit Quiz") {
                    calculateScore(questions: questions)
                    stack.push(2)
                  }
                  .suggested()
                  .padding()
                } else {
                  Button(icon: .default(icon: .goNext)) {
                    currentQuestionIndex += 1
                  }
                  .padding()
                }
              }
              .padding()
            }
            .padding()
          }
          .padding()
        }
      }
    } else if let error = errorMessage {
      VStack(spacing: 10) {
        Text("Error loading quiz")
        Text(error)
      }
      .padding()
    } else {
      VStack(spacing: 10) {
        Text("Loading quiz...")
          .padding()
        Button("Load Quiz") {
          loadQuiz()
        }
        .suggested()
      }
      .padding()
    }
  }

  private func calculateScore(questions: [QuestionItem]) {
    var correctAnswers = 0
    QuizView.totalQuestions = questions.count

    for question in questions {
      if selectedAnswers[question.id] == question.question.answer {
        correctAnswers += 1
      }
    }

    QuizView.score = correctAnswers
  }

  private func loadQuiz() {
    guard let url = url else {
      errorMessage = "No quiz file selected"
      return
    }

    do {
      let data = try Data(contentsOf: url)
      let decoder = JSONDecoder()
      quiz = try decoder.decode(Quiz.self, from: data)
    } catch {
      errorMessage = "Failed to load quiz: \(error.localizedDescription)"
      print("Error loading quiz: \(error)")
    }
  }
}

struct ResultView: View {
  let score: Int
  let totalQuestions: Int
  @Binding var stack: NavigationStack<Int>

  var percentage: Double {
    Double(score) * 100.0 / Double(totalQuestions)
  }

  var view: Body {
    VStack(spacing: 10) {
      Text("Quiz Results")
        .padding()

      Text("Your Score: \(score)/\(totalQuestions)")
        .padding()

      Text("Percentage: \(String(format: "%.1f", percentage))%")
        .padding()

      if percentage >= 70 {
        Text("Great job! 🎉")
      } else if percentage >= 50 {
        Text("Good effort! Keep practicing! 💪")
      } else {
        Text("Keep studying! You can do better! 📚")
      }

      Button("Go Home") {
        stack.pop()
        stack.pop()
      }
      .suggested()
      .padding()
    }
    .padding()
  }
}

