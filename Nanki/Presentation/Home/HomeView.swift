//
//  HomeView.swift
//  Nanki
//
//  Created by 안정흠 on 2/18/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var store: WordStore // WordStore 환경 객체
    @State var pickerSelected: HomePicker = .Custom

    var body: some View {
        List {
            Section {
                Picker("Picker", selection: $pickerSelected) {
                    ForEach(HomePicker.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }
                .pickerStyle(.segmented)
            }
            .listRowBackground(Color.clear)
            ForEach(currentWordSet()) { item in
                HomeCell(item: item, isCustom: (pickerSelected == .Custom))
            }
            .onDelete { index in
                store.deleteWordSet(indexSet: index)
            }
            .deleteDisabled(pickerSelected == .Gallery)
        }
        .listStyle(.sidebar)
        .navigationTitle("NanKi")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Add" ,systemImage: "plus") {
                    withAnimation { store.addNewWordSet() }
                }
                .disabled(pickerSelected == .Gallery)
            }
        }
        .navigationBarTitleDisplayMode(.large)
    }
    
    enum HomePicker: String, CaseIterable {
        case Custom, Gallery
    }
    private func currentWordSet() -> Binding<[WordSet]>{
        pickerSelected == .Custom ? $store.wordList : $store.gallery
    }
}

#Preview {
    NavigationView {
        HomeView()
            .environmentObject(WordStore())
    }
}
