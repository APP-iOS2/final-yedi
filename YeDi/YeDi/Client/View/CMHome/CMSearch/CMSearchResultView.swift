//
//  CMSearchResultView.swift
//  YeDi
//
//  Created by 박채영 on 2023/09/25.
//

import SwiftUI

struct CMSearchResultView: View {
    var designers: [Designer]
    
    var body: some View {
        VStack {
            HStack {
                Text("디자이너(\(designers.count)건)")
                Spacer()
            }
            .padding([.top, .leading])
            
            ScrollView {
                ForEach(designers, id: \.id) { designer in
                    CMSearchResultCell(designer: designer)
                }
            }
            
            Spacer()
        }
    }
}

struct CMSearchResultCell: View {
    @State private var isHeartSelected: Bool = false
    var designer: Designer
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "person.circle.fill")
                    .font(.largeTitle)
                    .foregroundStyle(.yellow)
                VStack(alignment: .leading) {
                    Text(designer.name)
                    Text("유칼립투스 헤어 | 단원구 선부동")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                }
                Spacer()
                Button(action: {
                    isHeartSelected.toggle()
                }, label: {
                    Image(systemName: isHeartSelected ? "heart.fill" : "heart")
                        .foregroundStyle(isHeartSelected ? .red : .black)
                })
            }
            
            ScrollView(.horizontal) {
                HStack {
                    ForEach(0..<5) { _ in
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.gray)
                            .frame(width: 100, height: 100)
                    }
                }
            }
            .scrollIndicators(.never)
        }
        .padding()
    }
}

//#Preview {
//    CMSearchResultView()
//}
