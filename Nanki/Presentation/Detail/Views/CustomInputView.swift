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
    
    @FocusState private var wordFocus: Bool
    @FocusState private var meaningFocus: Bool
    
    let id: UUID
    let selectedWordIndex: Int?
    
    var body: some View {
        List {
            Section("단어") {
                TextField("Input Word", text: $wordInput)
                    .onSubmit { meaningFocus = true }
                    .focused($wordFocus)
                    .submitLabel(.done)
            }
            Section("의미") {
                TextField("Input meaning", text: $meaningInput)
                    .focused($meaningFocus)
                    .submitLabel(.done)
            }
        }
        .onAppear {
            if let selectedWordIndex {
                let word = words[selectedWordIndex]
                wordInput = word.title
                meaningInput = word.meaning
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                if let selectedWordIndex {
                    Button("수정", action: {
                        guard wordInput != "", meaningInput != "" else { return }
                        words[selectedWordIndex] = Word(title: wordInput, meaning: meaningInput)
                        dismiss()
                    })
                }
                else {
                    Button("추가", action: {
                        guard wordInput != "", meaningInput != "" else { return }
                        words.append(Word(title: wordInput, meaning: meaningInput))
                        dismiss()
                    })
                }
            }
            ToolbarItem(placement: .topBarLeading) {
                Button("취소", action: {
                    dismiss()
                })
            }
        }
        
    }
}
