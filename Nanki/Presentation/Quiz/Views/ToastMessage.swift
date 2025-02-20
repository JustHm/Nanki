//
//  ToastMessage.swift
//  Nanki
//
//  Created by 안정흠 on 2/18/25.
//

import SwiftUI

struct ToastMessage: View {
    @Binding var toastMessage: String
    @Binding var showToast: Bool
    var body: some View {
        VStack {
            Spacer()
            Text(toastMessage)
                .foregroundColor(.white)
                .padding()
                .background(Color.black.opacity(0.7))
                .cornerRadius(10) // 여기서 cornerRadius를 background 뒤에 적용
                .opacity(showToast ? 1 : 0)
                .offset(y: showToast ? 0 : 20)
            
        }
        .padding(.bottom, 40)
        .animation(.easeInOut(duration: 0.1), value: showToast)
    }
}
