//
//  PairQuizViewModel.swift
//  Nanki
//
//  Created by 안정흠 on 2/19/25.
//

import SwiftUI
import Combine

class PairQuizViewModel: ObservableObject {
    @Published var selectedTitle: UUID? = nil
    @Published var selectedMeaning: UUID? = nil
    @Published var leftTitles: [PairCard] = []
    @Published var rightMeanings: [PairCard] = []
    @Published var timeCount: Int = 0
    
    private var list: [Word]
    private var timer: Timer?
    private var matchCount: Int = 0
    private var cancelBag = Set<AnyCancellable>()
    let colors: [Color] = [.blue, .green, .orange, .brown, .green, .gray, .purple, .black, .cyan, .indigo, .mint, .pink]
    
    init(list: [Word]) {
        self.list = list.shuffled()
        setCardsData()
        
        // 타이머 시작
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.timeCount += 1
        }
        
        $selectedTitle.combineLatest($selectedMeaning)
            .compactMap { title, meaning -> (UUID, UUID)? in
                guard let title ,let meaning else { return nil }
                return (title, meaning)
            }
            .sink { [weak self] (title, meaning) in
                //여기서 정답체크
                if title == meaning,
                   let leftIndex = self?.leftTitles.firstIndex(where: { $0.id == title}),
                   let rightIndex = self?.rightMeanings.firstIndex(where: { $0.id == title})
                {
                    self?.matchCount += 1
                    self?.leftTitles[leftIndex].isMatched = true
                    self?.rightMeanings[rightIndex].isMatched = true
                    
                    if (self?.list.isEmpty == true) {
                        print("GameOver")
                        self?.stopTimer()
                    }
                    else if (self?.matchCount == 4) {
                        withAnimation{ self?.setCardsData() }
                    }
                }
                //선택 초기화
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self?.resetSelection()
                }
            }
            .store(in: &cancelBag)
    }
    
    func setCardsData() {
        matchCount = 0
        leftTitles.removeAll()
        rightMeanings.removeAll()
        // 카드가 4개 미만이면 남은 카드만 보여주기
        let cardCount = (list.count >= 4) ? 4 : list.count
        
        for item in list.suffix(cardCount) {
            let id = UUID()
            let leftCard = PairCard(
                id: id,
                name: item.title,
                isMatched: false,
                color: colors.randomElement() ?? .blue
            )
            let rightCard = PairCard(
                id: id,
                name: item.meaning,
                isMatched: false,
                color: colors.shuffled().randomElement() ?? .blue
            )
            leftTitles.append(leftCard)
            rightMeanings.append(rightCard)
        }
        leftTitles.shuffle()
        rightMeanings.shuffle()
        
        list.removeLast(cardCount)
    }
    
    func resetSelection() {
        selectedTitle = nil
        selectedMeaning = nil
    }
    
    // 타이머 정지
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

struct PairCard {
    var id: UUID
    var name: String
    var isMatched: Bool
    var color: Color
    
    var opacity: CGFloat {
        isMatched ? 0.5 : 1.0
    }
}
