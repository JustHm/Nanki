//
//  PairCardView.swift
//  Nanki
//
//  Created by 안정흠 on 2/19/25.
//

import SwiftUI

struct PairCardView: View {
    @ObservedObject var viewModel: PairQuizViewModel
    
    var body: some View {
        HStack {
            VStack {
                ForEach(viewModel.leftTitles, id: \.id) { item in
                    RoundedRectangle(cornerRadius: 16)
                        .foregroundStyle(item.color)
                        .overlay {
                            Text(item.name)
                                .bold()
                                .font(.title2)
                                .foregroundStyle(.white)
                        }
                        .opacity(item.opacity)
                        .scaleEffect(
                            (viewModel.selectedTitle == item.id) ?
                            0.9 : 1
                        )
                        .onTapGesture {
                            onTapAction(item: item, isLeft: true)
                        }
                }
                .animation(.easeInOut(duration: 0.1), value: viewModel.selectedTitle)
            }
            VStack {
//                ForEach($viewModel.rightMeanings, id: \.id) { $item in
                ForEach(viewModel.rightMeanings, id: \.id) { item in
                    RoundedRectangle(cornerRadius: 16)
                        .foregroundStyle(item.color)
                        .overlay {
                            Text(item.name)
                                .bold()
                                .font(.title2)
                                .foregroundStyle(.white)
                        }
                        .opacity(item.opacity)
                        .scaleEffect(
                            (viewModel.selectedMeaning == item.id) ?
                            0.9 : 1
                        )
                        .onTapGesture {
                            onTapAction(item: item, isLeft: false)
                        }
                }
                .animation(.easeInOut(duration: 0.1), value: viewModel.selectedMeaning)
            }
        }
        .padding()
    }
    
    private func onTapAction(item: PairCard, isLeft: Bool) {
        guard !item.isMatched else { return }
        if isLeft {
            if viewModel.selectedTitle == item.id {
                viewModel.selectedTitle = nil
            } else {
                viewModel.selectedTitle = item.id
            }
        }
        else {
            if viewModel.selectedMeaning == item.id {
                viewModel.selectedMeaning = nil
            } else {
                viewModel.selectedMeaning = item.id
            }
        }

    }
}




