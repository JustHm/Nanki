//
//  CardFace.swift
//  Nanki
//
//  Created by 안정흠 on 2/18/25.
//

import SwiftUI

struct CardFace: View {
    let text: String
    let isFlipped: Bool
    let isFront: Bool
    
    var body: some View {
        Rectangle()
            .foregroundColor(isFront ? .green : .blue)
            .overlay(
                Text(text)
                    .frame(maxWidth: 300, maxHeight: 200) // 카드와 동일한 고정 프레임 지정 (최대치로)
                    .font(.system(size: 30, weight: .bold))
                    .foregroundColor(.white)
                    .rotation3DEffect(
                        .degrees(isFront ? 0 : 180),
                        axis: (x: 0, y: 1, z: 0)
                    )
                    .lineLimit(nil) // 라인 수 제한 없음 (frame을 설정해서 프레임을 벗어나면...으로 표시됨
                    .multilineTextAlignment(.leading)
                    .padding(4)
            )
            .cornerRadius(10)
            .frame(width: 300, height: 200)
            .shadow(color: .gray, radius: 10)
            .rotation3DEffect(
                .degrees(isFlipped ? 180 : 0),
                axis: (x: 0, y: 1, z: 0)
            )
    }
}

#Preview {
    CardFace(text: "HIHIHIHIHIHIHIHIHIHI", isFlipped: false, isFront: true)
}
