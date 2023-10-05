//
//  CMSearchHistoryView.swift
//  YeDi
//
//  Created by 박채영 on 2023/09/25.
//

import SwiftUI

struct CMSearchHistoryView: View {
    var body: some View {
        VStack {
            HStack {
                Text("최근 검색어")
                Spacer()
                Button(action: {
                    // TODO: 최근 검색어 리스트 생성하기
                }, label: {
                    Text("전체 삭제")
                        .foregroundStyle(.gray)
                })
            }
            .padding([.top, .leading, .trailing])
            
            Spacer()
        }
    }
}

#Preview {
    CMSearchHistoryView()
}
