//
//  WordSet.swift
//  Nanki
//
//  Created by 안정흠 on 2/18/25.
//

import Foundation

struct WordSet: Codable, Identifiable {
    var id: UUID
    var title: String
    var wordList: [Word]
    
    init(id: UUID = UUID(), title: String, wordList: [Word]) {
        self.id = id
        self.title = title
        self.wordList = wordList
    }
}

struct Word: Codable, Hashable{
    var title: String
    var meaning: String
}
