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
    @Published var isEnded: Bool = false
    @Published var elapsedTime: String = ""
    
    private var list: [Word]
    private let WordSetID: UUID
    private var timer: Timer?
    private var matchCount: Int = 0
    private var cancelBag = Set<AnyCancellable>()
    let colors: [Color] = [.blue, .green, .orange, .brown, .green, .gray, .purple, .black, .cyan, .indigo, .mint, .pink]
    
    init(list: WordSet) {
        self.list = list.wordList.shuffled()
        self.WordSetID = list.id
        setCardsData()
        
        // 타이머 시작
        timer = Timer.scheduledTimer(
            withTimeInterval: 1.0,
            repeats: true) { [weak self] _ in
            self?.timeCount += 1
        }
        $timeCount
            .map{self.formatSecondsToMinutesSeconds($0)}
            .assign(to: &$elapsedTime)
        
        $selectedTitle.combineLatest($selectedMeaning)
            .compactMap { title, meaning -> (UUID, UUID)? in
                guard let title ,let meaning else { return nil }
                return (title, meaning)
            }
            .sink { [weak self] (title, meaning) in
                if (self?.checkAnswer(titleID: title, meaningID: meaning) == true) {
                    if (self?.list.isEmpty == true) && (self?.matchCount == 4) {
                        self?.gameOver()
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
    
    func getLeaderBoard() -> [String] {
        let key = "leaderBoard\(WordSetID)"
        let list = UserDefaults.standard.stringArray(forKey: key) ?? []
        return list
    }
}

extension PairQuizViewModel {
    private func setCardsData() {
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
    
    private func resetSelection() {
        selectedTitle = nil
        selectedMeaning = nil
    }
    
    private func gameOver() {
        timer?.invalidate()
        timer = nil
        addLeaderBoard()
        isEnded = true
    }
    private func checkAnswer(titleID: UUID, meaningID: UUID) -> Bool {
        if titleID == meaningID,
           let leftIndex = self.leftTitles.firstIndex(where: { $0.id == titleID}),
           let rightIndex = self.rightMeanings.firstIndex(where: { $0.id == titleID})
        {
            matchCount += 1
            leftTitles[leftIndex].isMatched = true
            rightMeanings[rightIndex].isMatched = true
            return true
        }
        else {
            return false
        }
    }
    private func addLeaderBoard() {
        let key = "leaderBoard\(WordSetID)"
        var list = UserDefaults.standard.stringArray(forKey: key) ?? []
        list.append(elapsedTime)  // 새로운 값 추가
        UserDefaults.standard.set(list.sorted(by: <), forKey: key)
    }
    
    private func formatSecondsToMinutesSeconds(_ seconds: Int) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second] // 분, 초만 표시
        formatter.unitsStyle = .positional // "0:00" 형식
        formatter.zeroFormattingBehavior = .pad // 01:05 같은 형식 유지
        return formatter.string(from: TimeInterval(seconds)) ?? "0:00"
    }
}



