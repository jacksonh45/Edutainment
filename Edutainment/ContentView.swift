//
//  ContentView.swift
//  Edutainment
//
//  Created by Jackson Harrison on 3/1/24.
//

import SwiftUI

struct ContentView: View {

    struct QuestionAndAnswer {
        var operand1: Int
        var operand2: Int

        var answer: Int {
            operand1 * operand2
        }

        var questionText: String {
            "\(operand1) * \(operand2)"
        }
    }

    
    @State private var multiplicationTable = 2
    @State private var numberOfQuestions = [5, 10, 15, 20]
    @State private var numberOfQuestion = 0
    @State private var questionArray = [String]()
    @State private var answerArray = [Int]()
    @State private var userAnswer: Int = 0
    @State private var answer = 0
    @State private var currentQuestion = 0
    @State private var displayQuestion = " "

    
    @State private var score = 0

    
    @State private var playingGame = false
    @State private var configuringGame = true

    
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var gameOver = false

    var body: some View {
        NavigationStack {
            Form {
                
                if configuringGame {
                    Section {
                        Picker("Multiplcation Selector", selection: $multiplicationTable) {
                            ForEach(2..<13, id: \.self) {
                                Text("\($0)")
                            }
                        }
                    } header: {
                        Text("Select the times table you would like to test")
                    }
                    Section {
                        Picker("Selection number of questions", selection: $numberOfQuestion) {
                            ForEach(numberOfQuestions, id: \.self) {
                                Text("\($0)")
                            }
                        }
                        .pickerStyle(.segmented)
                    } header: {
                        Text("Select how many questions you would like to answer")
                    }
                    Button("Play Game!") {
                        configureGame()
                    }
                }
                
                if playingGame {
                    Section {
                        Text(displayQuestion)
                        Section{
                            TextField("User answer", value: $userAnswer, format: .number)
                            Button("Check Answer") {
                                checkAnswer()
                            }
                        }
                        Section {
                            Text("Here is the score \(score)")
                        }
                    }
                    .onAppear(perform: setQuestion)
                    .alert(alertMessage, isPresented: $showAlert) {
                        Button("Ok") {
                            if gameOver {
                                startNewGames()
                            } else {

                            }
                        }
                    }
                }
            }
            .navigationTitle("CanUMultiply")
        }
    }
    
    func configureGame() {

        playingGame = true
        configuringGame = false
        gameOver = false

        var count = 0
        while count < numberOfQuestion {
            let randomNum = Int.random(in: 0...12)
            let problem = QuestionAndAnswer(operand1: multiplicationTable, operand2: randomNum)

            let questionTexts = problem.questionText
            let questionAnswer = problem.answer

            questionArray.append(questionTexts)
            answerArray.append(questionAnswer)

            count += 1
        }
        print(questionArray)
        print(answerArray)
    }

    
    func setQuestion() {
        if currentQuestion != numberOfQuestion {
            let displaysQuestion = questionArray[currentQuestion]
            displayQuestion = displaysQuestion

            let setAnswer = answerArray[currentQuestion]
            answer = setAnswer

            userAnswer = 0
        } else {
            showAlert = true
            alertMessage = "Game Over! Start New Game? "
            gameOver = true
        }
    }

    
    func checkAnswer() {
            if answer == userAnswer {
                score += 1
                alertMessage = "Correct!"
            } else {
                score -= 1
                alertMessage = "Sorry the answer is \(answer)"
            }
            currentQuestion += 1
            showAlert = true
            setQuestion()
        }

    
    func startNewGames() {
        currentQuestion = 0
        numberOfQuestion = 0
        score = 0
        playingGame = false
        configuringGame = true
    }
}
