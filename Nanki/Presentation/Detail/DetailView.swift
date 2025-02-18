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
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

//#Preview {
//    DetailView()
//}
