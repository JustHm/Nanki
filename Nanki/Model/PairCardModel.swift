//
//  PairCardModel.swift
//  Nanki
//
//  Created by 안정흠 on 2/19/25.
//

import SwiftUI

struct PairCard {
    var id: UUID
    var name: String
    var isMatched: Bool
    var color: Color
    
    var opacity: CGFloat {
        isMatched ? 0.5 : 1.0
    }
}
