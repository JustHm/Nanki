//
//  DetailView.swift
//  Nanki
//
//  Created by 안정흠 on 2/18/25.
//

import SwiftUI

struct DetailView: View {
    @Binding var list: WordSet
    @State private var isAdded: Bool = false
    @State private var addsheet: Bool = false
    @State private var title: String
    var isCanEdit: Bool
    
    init(list: Binding<WordSet>, isCanEdit: Bool) {
        //Property Wrapper가 달려있는 변수의경우 _를 붙여서 접근할 수 있다.
        //State를 기본값을 받아 초기화 하는경우 State(initialValue:) 함수를 사용해 초기화할 수 있다.
        _list = list
        _title = State(initialValue: list.wrappedValue.title)
        self.isCanEdit = isCanEdit
    }
    
    var body: some View {
        VStack(spacing: 0) {
            List {
                Section(footer: (isCanEdit) ? Text("제목 수정가능.") : Text("")) {
                    VStack {
                        TextField("제목을 입력하세요", text: $title)
                            .font(.largeTitle)
                            .bold()
                            .disabled(!isCanEdit)
                            .onSubmit {
                                list.title = title
                            }
                        Divider().background(.blue)
                    }
                }
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
                
                Section {
                    NavigationLink {
                    } label: {
                        Text("단어퀴즈")
                    }
                    .disabled(list.wordList.isEmpty)
                }
                Section("단어 (list.wordList.count)개") {
                    ForEach(list.wordList, id: \.title) { item in
                        Text(item.title)
                    }
                    .onDelete { index in
                        withAnimation {
                            list.wordList.remove(atOffsets: index)
                        }
                    }
                    .deleteDisabled(!isCanEdit)
                }
            }
        }
        .overlay(alignment: .bottomTrailing) {
            if isCanEdit {
                Button(action: {addsheet.toggle()}) {
                    Image(systemName: "plus")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.white)
                        .padding()
                }
                .background(Circle().fill(Color.blue))
                .frame(width: 64, height: 64)
            }
        }
        .sheet(isPresented: $addsheet, content: {
            NavigationView {
            }
            .presentationDetents([.medium])
        })
    }
}
#Preview {
    @Previewable @State var list = WordSet(title: "HI", wordList: [])
    NavigationView {
        DetailView(list: $list,
                   isCanEdit: true
        )
    }
}
