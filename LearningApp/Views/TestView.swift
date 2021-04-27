//
//  TestView.swift
//  LearningApp
//
//  Created by James Lebeau on 4/26/21.
//

import SwiftUI

struct TestView: View {
    
    @EnvironmentObject var model:ContentModel
    @State var selectedAnswerIndex:Int?
    @State var numCorrect = 0
    @State var submitted = false
    
    var body: some View {
        
        if model.currentQuestion != nil {
            
            VStack (alignment: .leading) {
            
                    Text("Question \(model.currentQuestionIndex + 1) of \(model.currentModule?.test.questions.count ?? 0)" )
                        .padding(.leading, 20)
                
                    CodeTextView()
                        .padding(.horizontal, 20)
                
                ScrollView {
                    VStack {
                        ForEach (0..<model.currentQuestion!.answers.count, id: \.self) {index in
                            
                            Button{
                                selectedAnswerIndex = index
                                
                            } label: {
                                
                                ZStack {
                                    
                                    if submitted == false {
                                        
                                        RectangleCard(color: index == selectedAnswerIndex ? .gray : .white)
                                            .frame(height: 40)
                                    } else {
                                        
                                        if index == selectedAnswerIndex && index == model.currentQuestion?.correctIndex {
                                            RectangleCard(color: .green)
                                                .frame(height: 40)

                                        } else if  index == selectedAnswerIndex && index != model.currentQuestion?.correctIndex {
                                            RectangleCard(color: .red)
                                                .frame(height: 40)

                                        } else if index == model.currentQuestion!.correctIndex {
                                            RectangleCard(color: .green)
                                                .frame(height: 40)

                                        }
                                        else {
                                            RectangleCard(color: Color.white)
                                                .frame(height: 40)

                                        }
                                    }
                                    
                                    
                                    Text(model.currentQuestion!.answers[index])
                                }

                            }
                            .disabled(submitted)
                        }
                    }
                    .padding()
                    .accentColor(.black)
                }
                Button{
                    
                    submitted = true
                    
                    if selectedAnswerIndex == model.currentQuestion!.correctIndex {
                        numCorrect += 1
                    }
                    
                } label: {
                    
                    ZStack {
                        
                        RectangleCard(color: .green)
                            .frame(height: 48)
                        Text("Submit")
                            .bold()
                            .foregroundColor(.white)
                    }
                    .padding()

                }
                .disabled(selectedAnswerIndex == nil)
                
            }
            .navigationBarTitle("\(model.currentModule?.category ?? "")  Test")
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
