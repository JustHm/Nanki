//
//  MultipleChoiceQuizView.swift
//  Nanki
//
//  Created by kyuhyeon Lee on 2/19/25.
//


import SwiftUI

struct MultipleChoiceQuizView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var isFlipped = false
    @State private var selectedAnswer = ""
    @State private var toastMessage = ""
    @State private var showToast = false
    @State private var correctCount = 0
    @State private var showResult = false
    @State private var options: [String] = []
    
    @State var list: [Word]
    @State var index: Int = 0
    
    var body: some View {
        VStack(spacing: 32) {
            // 단어 카드
            ZStack {
                CardFace(text: list[index].title, isFlipped: isFlipped, isFront: true)
                    .opacity(isFlipped ? 0 : 1)
                
                CardFace(text: list[index].meaning, isFlipped: isFlipped, isFront: false)
                    .opacity(isFlipped ? 1 : 0)
            }
            .onTapGesture {
                withAnimation {
                    isFlipped.toggle()
                }
            }
            
            // 퀴즈 진행상황
            HStack {
                Text("\(index + 1) / \(list.count)")
                    .font(.headline)
                    .foregroundStyle(.gray)
            }
            
            // 객관식 보기
            VStack(spacing: 16) {
                ForEach(options, id: \.self) { option in
                    Button(action: {
                        selectedAnswer = option
                        withAnimation { checkAnswer() }
                    }) {
                        Text(option)
                            .foregroundColor(.primary)  // 글자색 검정으로 통일
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(getOptionColor(option), lineWidth: 2)
                            )
                    }
                    .disabled(showToast)
                }
            }
            .padding(.horizontal)
        }
        .overlay(ToastMessage(toastMessage: $toastMessage, showToast: $showToast))
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showResult) {
            QuizResultView(totalQuestions: list.count, correctAnswers: correctCount)
                .onDisappear {
                    dismiss()
                }
        }
        .onAppear {
            generateOptions()
        }
    }
    
    private func generateOptions() {
        var tempOptions = [list[index].meaning]
        
        // 현재 단어를 제외한 나머지 단어들에서 랜덤하게 3개 선택
        var remainingWords = list.filter { $0.title != list[index].title }
        remainingWords.shuffle()
        
        // 3개의 오답 추가
        for i in 0..<min(3, remainingWords.count) {
            tempOptions.append(remainingWords[i].meaning)
        }
        
        // 보기 순서 랜덤화
        options = tempOptions.shuffled()
    }
    
    private func getOptionColor(_ option: String) -> Color {
        if selectedAnswer.isEmpty {
            return .gray
        }
        if option == list[index].meaning {
            return selectedAnswer == option ? .green : .gray
        }
        return selectedAnswer == option ? .red : .gray
    }
    
    private func checkAnswer() {
        if selectedAnswer == list[index].meaning {
            toastMessage = "정답입니다!"
            correctCount += 1
        } else {
            toastMessage = "틀렸습니다"
        }
        
        showToast = true
        isFlipped = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation {
                showToast = false
                isFlipped = false
                selectedAnswer = ""
                
                if (index + 1) < list.count {
                    index += 1
                    generateOptions()
                } else {
                    showResult = true
                }
            }
        }
    }
}

#Preview {
    @Previewable var temp = [
        Word(title: "Apple", meaning: "사과"),
        Word(title: "Banana", meaning: "바나나"),
        Word(title: "Orange", meaning: "오렌지"),
        Word(title: "Grape", meaning: "포도")
    ]
    @Previewable @State var index = 0
    MultipleChoiceQuizView(list: temp, index: index)
}
