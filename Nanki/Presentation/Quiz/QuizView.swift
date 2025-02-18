//
//  QuizView.swift
//  Nanki
//
//  Created by 안정흠 on 2/18/25.
//

import SwiftUI

struct QuizView: View {
    @State var list: [Word]
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    @Previewable var temp = [Word(title: "HIHIHIHIHIHIHIHIHIHIHIHIHHIHIHIHIHHIHIHIHIHHIHIHIHIHIHIHHIHIHIHIHHIHIHIHIHHIHIHIHIHHIHIHIHIHHIHIHIHIHI", meaning: "IH")]
    QuizView(list: temp)
}
