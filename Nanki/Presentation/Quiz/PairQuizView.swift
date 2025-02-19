//
//  PairQuizView.swift
//  Nanki
//
//  Created by 안정흠 on 2/19/25.
//

import SwiftUI

struct PairQuizView: View {
    @StateObject var viewModel: PairQuizViewModel
    @Environment(\.dismiss) var dismiss
    
    init(list: WordSet) {
        _viewModel = StateObject(
            wrappedValue: PairQuizViewModel(list: list)
        )
    }
    
    var body: some View {
        VStack {
            Text("⏱️\(formatSecondsToMinutesSeconds(viewModel.timeCount))")
                .font(.title)
                .bold()
            PairCardView(viewModel: viewModel)
        }
        .padding([.top, .bottom], 16)
        .sheet(isPresented: $viewModel.isEnded) {
            PairQuizResultView(elapsedTime: viewModel.elapsedTime, leaderBoard: viewModel.getLeaderBoard())
                .onDisappear {
                    dismiss()
                }
        }
    }
    
    func formatSecondsToMinutesSeconds(_ seconds: Int) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second] // 분, 초만 표시
        formatter.unitsStyle = .positional // "0:00" 형식
        formatter.zeroFormattingBehavior = .pad // 01:05 같은 형식 유지
        return formatter.string(from: TimeInterval(seconds)) ?? "0:00"
    }
}

#Preview {
    PairQuizView(
        list: WordSet(title: "HI", wordList: [
            Word(title: "HI1", meaning: "KEY1"),
            Word(title: "HI2", meaning: "KEY2"),
            Word(title: "HI3", meaning: "KEY3"),
            Word(title: "HI4", meaning: "KEY4"),
            Word(title: "HI5", meaning: "KEY5"),
            Word(title: "HI6", meaning: "KEY6")
        ])
    )
}
