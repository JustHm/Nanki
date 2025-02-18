//
//  CustomInputView.swift
//  Nanki
//
//  Created by 안정흠 on 2/18/25.
//

import SwiftUI

struct CustomInputView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var wordInput: String = ""
    @State private var meaningInput: String = ""
    @Binding var words: [Word]
    
    let id: UUID
    
    var body: some View {
        List {
            Section("단어") {
                TextField("Input Word", text: $wordInput)
            }
            Section("의미") {
                TextField("Input meaning", text: $meaningInput)
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("추가", action: {
                    words.append(Word(title: wordInput, meaning: meaningInput))
                    dismiss()
                })
            }
            ToolbarItem(placement: .topBarLeading) {
                Button("취소", action: {
                    dismiss()
                })
            }
        }
        
    }
}
