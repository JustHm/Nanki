//
//  PairQuizResultView.swift
//  Nanki
//
//  Created by 안정흠 on 2/19/25.
//

import SwiftUI

struct PairQuizResultView: View {
    @Environment(\.dismiss) var dismiss
    let elapsedTime: String
    let leaderBoard: [String]
    
    var body: some View {
        VStack {
            List {
                Section {
                    VStack(alignment: .center, spacing: 8) {
                        Text("🥳성공!")
                            .font(.largeTitle)
                        Text("⏱️ \(elapsedTime)")
                            .font(.title2)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                }
                
                Button("돌아가기") {dismiss()}
                    .buttonStyle(.borderedProminent)
                    .frame(maxWidth: .infinity)
                    .listRowBackground(Color.clear)
                
                Section {
                    ForEach(Array(leaderBoard.enumerated()), id: \.offset) { item in
                        HStack(spacing: 16) {
                            Text("\(item.offset + 1)")
                                .bold()
                            Text("⏱️ \(item.element)")
                        }
                        
                    }
                } header: {
                    Text("🏆 Leaderboard")
                }
            }
        }
    }
}

#Preview {
    PairQuizResultView(elapsedTime: "0", leaderBoard: [])
}
