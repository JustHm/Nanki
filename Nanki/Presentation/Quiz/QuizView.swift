//
//  QuizView.swift
//  Nanki
//
//  Created by 안정흠 on 2/18/25.
//

import SwiftUI

struct QuizView: View {
    @Environment(\.dismiss) private var dismiss // 현재 뷰를 닫기 위한 dismiss 환경 변수
    @State private var isFlipped = false
    @State private var userAnswer = ""
    @State private var toastMessage = ""
    @State private var showToast = false
    @State private var correctCount = 0  // 맞은 개수를 추적하는 상태 변수
    @State private var showResult = false // 결과 화면 표시 여부
    
    @State var list: [Word]
    @State var index: Int = 0
    
    var body: some View {
        VStack(spacing: 32) {
            // 단어 카드
            ZStack {
                // 앞면 (단어)
                CardFace(text: list[index].title, isFlipped: isFlipped, isFront: true)
                    .opacity(isFlipped ? 0 : 1)
                
                // 뒷면 (의미)
                CardFace(text: list[index].meaning, isFlipped: isFlipped, isFront: false)
                    .opacity(isFlipped ? 1 : 0)
            }
            .onTapGesture {
                withAnimation {
                    isFlipped.toggle()
                }
            }
            // 단어 퀴즈 진행상황
            HStack {
                Text("\(index+1) / \(list.count)")
                    .font(.headline)
                    .foregroundStyle(.gray)
            }
            
            // 답변 입력 영역
            HStack(spacing: 15) {
                TextField("뜻을 입력하세요", text: $userAnswer)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                Button(action: {
                    withAnimation { next() }
                }) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(showToast ? .gray : .green)
                        .font(.system(size: 30))
                }
                .disabled(showToast)
            }
            .padding()
        }
        .overlay(ToastMessage(toastMessage: $toastMessage, showToast: $showToast))
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showResult) {
            QuizResultView(totalQuestions: list.count, correctAnswers: correctCount)
                .onDisappear {
                    dismiss()
                }
        }
    }
}

extension QuizView {
    private func next() {
        let correct = list[index].meaning.split(whereSeparator: {["(", ")", ",", " "].contains($0)})
        if correct.contains(where: {$0 == userAnswer}){
            toastMessage = "정답입니다!"
            correctCount += 1
        } else {
            toastMessage = "틀렸습니다"
        }
        
        userAnswer = ""
        showToast = true
        isFlipped = true
        // 일정 시간 후에 Toast 숨기기
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation {
                showToast = false
                isFlipped = false
                
                // 단어 리스트 갯수 확인
                if (index + 1) < list.count {
                    index += 1
                }
                else {
                   // 단어 게임 종료
                   showResult = true
                }
            }
        }
    }
}

#Preview {
    @Previewable var temp = [Word(title: "HIHIHIHIHIHIHIHIHIHIHIHIHHIHIHIHIHHIHIHIHIHHIHIHIHIHIHIHHIHIHIHIHHIHIHIHIHHIHIHIHIHHIHIHIHIHHIHIHIHIHI", meaning: "IH")]
    @Previewable @State var index = 0
    QuizView(list: temp, index: index)
}
