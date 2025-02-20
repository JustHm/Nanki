//
//  WordListCell.swift
//  Nanki
//
//  Created by 안정흠 on 2/18/25.
//

import SwiftUI

struct WordListCell: View {
    let word: String
    let meaning: String
    var body: some View {
        HStack {
            Text(word)
                .foregroundStyle(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .lineLimit(nil)
            Divider()
            Text(meaning)
                .foregroundStyle(.gray)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .lineLimit(nil)
                .multilineTextAlignment(.trailing)
                .bold()
        }
//        .frame(maxWidth: .infinity)
        .padding(.vertical, 4)
//        .fixedSize(horizontal: false, vertical: true)
    }
}

#Preview {
    WordListCell(word: "HIHI", meaning: "Hello")
}
