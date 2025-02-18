//
//  WordStore.swift
//  Nanki
//
//  Created by 안정흠 on 2/18/25.
//

import SwiftUI
import Combine

class WordStore: ObservableObject {
    // 사용자 단어장 리스트
    @Published var wordList: [WordSet] = []
    // 구성되어 있는 단어장 리스트
    @Published var gallery: [WordSet] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadGalleryList()
        loadWordListAll()
        $wordList.sink { [weak self] newValue in
            print("변경되었어여!!!!")
            self?.saveWordListAll(data: newValue)
        }
        .store(in: &cancellables)
    }
    
    // 단어장 추가 삭제
    func addNewWordSet() {
        let temp = WordSet(title: "새로운 단어장", wordList: [])
        wordList.append(temp)
    }
    func deleteWordSet(id: UUID) {
        wordList.removeAll{ $0.id == id }
    }
    func deleteWordSet(indexSet: IndexSet) {
        wordList.remove(atOffsets: indexSet)
    }
    // 단어 추가 삭제
    func addWord(id: UUID, word: Word) {
        guard let index = wordList.firstIndex(where: { $0.id == id }) else { return }
        wordList[index].wordList.append(word)
    }
    func deleteWord(id: UUID, word: Word, index: Int) {
        guard let index = wordList.firstIndex(where: { $0.id == id }) else { return }
        wordList[index].wordList.remove(at: index)
    }
}

extension WordStore {
    private func saveWordListAll(data: [WordSet]) {
        if let data = try? JSONEncoder().encode(data) {
            UserDefaults.standard.set(data, forKey: "wordList")
        }
        else {
            print("Encoding&Save Failed")
        }
    }
    private func loadWordListAll() {
        guard let data = UserDefaults.standard.data(forKey: "wordList"),
              let list = try? JSONDecoder().decode([WordSet].self, from: data) else { return }
        wordList = list
    }
    private func loadGalleryList() {
        for fileName in GalleryWordList.allCases {
            guard let url = Bundle.main.url(forResource: fileName.rawValue, withExtension: "json"),
                  let data = try? Data(contentsOf: url) else { continue }
            do {
                let list = try JSONDecoder().decode(WordSet.self, from: data)
                gallery.append(list)
            } catch {
                print("Error decoding JSON: \(error)")
                return
            }
        }
    }
    
    enum GalleryWordList: String, CaseIterable {
        case YellowDay1, YellowDay2
    }
}


