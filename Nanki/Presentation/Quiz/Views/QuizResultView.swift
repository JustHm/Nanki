//
//  QuizResultView.swift
//  Nanki
//
//  Created by 안정흠 on 2/18/25.
//
import SwiftUI

struct QuizResultView: View {
    @Environment(\.dismiss) private var dismiss
    
    // 총 문제 수
    let totalQuestions: Int
    // 총 정답 수
    let correctAnswers: Int
    
    var body: some View {
        VStack(spacing: 40) {
            // 퀴즈 종료 메세지
            Text("퀴즈가 종료되었습니다.")
                .font(.title)
                .bold()
                .padding(.top, 50)
            
            // 결과 화면
            VStack(spacing: 20) {
                // 총 문제 표시
                HStack {
                    Text("총 문제 수:")
                    Text("\(totalQuestions)")
                        .bold()
                }
                .font(.title2)
                
                // 맞힌 문제 표시
                HStack {
                    Text("맞은 문제 수:")
                    Text("\(correctAnswers)")
                        .bold()
                        .foregroundColor(.green)
                }
                .font(.title2)
                
                // 정답률 표시
                HStack {
                    Text("정답률:")
                    Text("\(calculateAccuracy())%")
                        .bold()
                        .foregroundColor(
                            calculateAccuracy() >= 70 ? .green :
                                calculateAccuracy() >= 40 ? .orange : .red
                        )
                }
                .font(.title2)
            }
            .padding()
            
            // 돌아가기 버튼
            Button(action: {
                dismiss()
            }) {
                Text("돌아가기")
                    .font(.title3)
                    .bold()
                    .foregroundColor(.white)
                    .frame(width: 200, height: 50)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.top, 40)
            
            Spacer()
        }
        .navigationBarBackButtonHidden(true) // 돌아가기 숨기기
        .interactiveDismissDisabled() // 스와이프로 뒤로가기 비활성화
    }
    
    // 정답률 계산
    private func calculateAccuracy() -> Int {
        guard totalQuestions > 0 else { return 0 }
        let percentage = Double(correctAnswers) / Double(totalQuestions) * 100
        return Int(round(percentage))
    }
}

#Preview {
    // Preview 샘플 데이터
    QuizResultView(totalQuestions: 10, correctAnswers: 7)
}
