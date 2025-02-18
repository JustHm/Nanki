//
//  HomeCell.swift
//  Nanki
//
//  Created by 안정흠 on 2/18/25.
//

import SwiftUI

struct HomeCell: View {
    @EnvironmentObject var store: WordStore
    @Binding var item: WordSet
    let isCustom: Bool
    var body: some View {
        NavigationLink {
            DetailView(list: $item, isCanEdit: isCustom)
        } label: {
            VStack(alignment: .leading, spacing: 8) {
                Text(item.title)
                Text("단어 갯수: \(item.wordList.count)")
                    .font(.footnote)
                    .foregroundStyle(.gray)
            }
        }
        .contextMenu {
            if isCustom {
                Button("Delete", systemImage: "trash", role: .destructive) {
                    withAnimation { store.deleteWordSet(id: item.id) }
                }
            }
        }
        
    }
}

//#Preview {
//    HomeCell()
//}
